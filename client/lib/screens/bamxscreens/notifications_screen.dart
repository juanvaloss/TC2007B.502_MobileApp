import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/bamxscreens/application_details_screen.dart';
//import 'package:flutter_application_1/screens/bamxscreens/bamx_admin_home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationsScreen extends StatefulWidget {
  final int adminId;
  const NotificationsScreen({required this.adminId, super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedOption = 'Centros de acopio'; // Opción seleccionada por defecto
  List<Map<String, dynamic>> requests = []; // Lista para almacenar las solicitudes

  @override
  void initState() {
    super.initState();
    fetchRequests();
    _requestPermission();
    FirebaseMessaging.onMessage.listen((payload) {
      final notification = payload.notification;
      print(notification);
      if (notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${notification.title} - ${notification.body}'),
          ),
        );
      }
    });
  }

  // Método para obtener las solicitudes desde el servidor
  Future<void> fetchRequests() async {
    try {
      final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/applications/getAll');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          requests = data.map((request) {
            return {
              "id": request['id'],
              "solicitor": request['solicitor'],
              "centerName": request['centerName'],
              "centerAddress": request['centerAddress'],
            };
          }).toList();
        });
      } else {
        print('Failed to load requests');
      }
    } catch (e) {
      print('Error fetching requests: $e');
    }
  }

  Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission();
    final fcm_token = await FirebaseMessaging.instance.getToken();

    if (fcm_token != null) {
      _setFcmToken(fcm_token);
    }

    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      await _setFcmToken(newToken);
    });

  }

  Future<void> _setFcmToken(String fcm_token) async {
    final supabase = SupabaseClient(dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_ANON_KEY']!);

    await supabase
        .from('admins')
        .update({'fcm_token': fcm_token}).eq('id', widget.adminId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Notificaciones'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(
              context,
            );
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20), // Espacio adicional antes de los botones
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Centros de acopio';
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Centros de acopio',
                        style: TextStyle(
                          color: selectedOption == 'Centros de acopio' ? Colors.red : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (selectedOption == 'Centros de acopio')
                        Container(
                          height: 2,
                          color: Colors.red,
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedOption = 'Solicitudes';
                      fetchRequests(); // Cargar solicitudes cuando se selecciona la opción
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Solicitudes',
                        style: TextStyle(
                          color: selectedOption == 'Solicitudes' ? const Color(0xFFEF3030) : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (selectedOption == 'Solicitudes')
                        Container(
                          height: 2,
                          color: Colors.red,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (selectedOption == 'Centros de acopio')
            Column(
              children: const [
                Text(
                  'Ventura',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          if (selectedOption == 'Solicitudes')
            Expanded(
              child: ListView.builder(
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ApplicationDetailsScreen(
                            applicationId: request['id'],
                            solicitorId:  request['solicitor'],
                            adminId: widget.adminId,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      color: const Color(0xFFEF3030),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request['centerName'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text('Presiona para ver más información', style: TextStyle(color: Colors.white),),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
