import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/bamxscreens/application_details_screen.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../user_screens/user_home_screen.dart';
import '/screens/user_screens/more_info_center.dart';

class NotificationsScreen extends StatefulWidget {
  final int adminId;
  const NotificationsScreen({required this.adminId, super.key});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedOption = 'Solicitudes';
  List<Map<String, dynamic>> requests = [];
  List<Map<String, dynamic>> collections = [];
  LatLng current = const LatLng(20.67471511804876, -103.43224564816127);

  @override
  void initState() {
    super.initState();
    fetchRequests();
    _requestPermission();
    FirebaseMessaging.onMessage.listen((payload) {
      final notification = payload.notification;
      if (notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${notification.title} - ${notification.body}'),
          ),
        );
      }
    });
  }
  


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchRequests();
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

Future<void> _goToCollectionRequest(int centerId) async{

  final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/centers/centerCoordinates');

    Map<String, dynamic> body = {
      'centerId': centerId,
    };

  try{
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );


    if(response.statusCode == 200){
      print("llegamos aquí");
      final Map<String, dynamic> data = json.decode(response.body);
      LatLng la = LatLng(data['latitude'], data['longitude']);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoreInfoCenter(
            centerId: centerId,
            userId: widget.adminId,
            currentUserPosition: current,
            centerPosition: la,
          )
        ),
      );
      print(data);
    }
  }
  catch(e){
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

  Future <void> _getAllCollectionRequests() async {
    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/collections/getAll');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        collections = data.map((collection) {
          return {
            "id": collection['id'],
            "whenReceived": collection['whenReceived'],
            "centerRequesting": collection['centerRequesting'],
            "centerStatus": collection['centerStatus'],
            "centerName": collection['centerName'],
          };
        }).toList();
      });
    } else {
      print('Failed to load requests');
    }
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
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => UserHomeScreen(userId: widget.adminId, isBamxAdmin: true, isCenterAdmin: false,)),
                  (Route<dynamic> route) => false,
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
                      selectedOption = 'Recolecciones pendientes';
                         _getAllCollectionRequests();
                    });
                  },
                  child: Column(
                    children: [
                      Text(
                        'Recolecciones pendientes',
                        style: TextStyle(
                          color: selectedOption == 'Recolecciones pendientes' ? Colors.red : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (selectedOption == 'Recolecciones pendientes')
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
          if (selectedOption == 'Recolecciones pendientes')
            Expanded(
              child: ListView.builder(
                itemCount: collections.length,
                itemBuilder: (context, index){
                  final collection = collections[index];
                  return GestureDetector(
                    onTap: (){
                      print(collection['centerRequesting']);
                      _goToCollectionRequest(collection['centerRequesting']);
                    },
                    child: Card(
                      margin: const EdgeInsets.all(10),
                      color: const Color(0xFFF6F8FA),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              collection['centerName'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text('Se encuentra al ${collection['centerStatus']}% de su capacidad máxima', style: const TextStyle(color: Colors.black),),
                          ],
                        ),
                      ),
                    )
                  );
                }
              )
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
                      color: const Color(0xFFF6F8FA),
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
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text('Presiona para ver más información', style: TextStyle(color: Colors.black),),
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
