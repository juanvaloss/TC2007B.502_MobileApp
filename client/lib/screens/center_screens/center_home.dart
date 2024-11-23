import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../user_screens/user_home_screen.dart';

class CenterHome extends StatefulWidget {
  final int userId;

  const CenterHome({required this.userId, super.key});

  @override
  _CenterHome createState() => _CenterHome();
}

class _CenterHome extends State<CenterHome> {
  Map<String, dynamic> userInfo = {};
  Map<String, dynamic> centerInfo = {};
  Uint8List? _imageFile;
  late var firstNameOfC;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();

  }

  Future<void> fetchUserInfo()async{
    try {
      final url1 = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/users/userInfo');
      final url2 = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/users/userCenters');

      Map<String, dynamic> jsonData = {
        'userId': widget.userId,
      };

      final response1 = await http.post(
        url1,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      final response2 = await http.post(
        url2,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      if (response1.statusCode == 200 && response2.statusCode == 200) {
        final responseData1 = json.decode(response1.body);
        final responseData2 = json.decode(response2.body);
        setState(() {
          userInfo = {
            "nombre": responseData1['name'],
            "email": responseData1['email'],
          };
          centerInfo = responseData2;
          firstNameOfC = removeDiacritics(responseData2['centerName'].split(' ').first);
        });

        final supabase =
        SupabaseClient(dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_ANON_KEY']!);
        final storageResponse = await supabase
            .storage
            .from('imagesOfCenters')
            .download('center${widget.userId}${firstNameOfC}.jpg');

        setState(() {
          _imageFile = storageResponse;
        });

      } else {
        print('Failed to fetch user information. Please try again.');
      }


    } catch (e) {
      print('An error occurred: $e');
    }
  }

  String removeDiacritics(String str) {
    var withDiacritics = 'áéíóúÁÉÍÓÚ';
    var withoutDiacritics = 'aeiouAEIOU';

    String result = '';

    for (int i = 0; i < str.length; i++) {
      int index = withDiacritics.indexOf(str[i]);
      if (index != -1) {
        result += withoutDiacritics[index];
      } else {
        result += str[i];
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF3030),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Bienvenido ${userInfo['nombre']}!",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Image.asset(
                  'images/bamx-logo.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),

          // Nombre del centro
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image
                    if (_imageFile != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _imageFile!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                    else
                      const SizedBox(),
                    const SizedBox(width: 10), // Add spacing between image and text
                    // Text
                    Text(
                      "${centerInfo['centerName']}",
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Lista de botones
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                OptionCard(
                  icon: FontAwesomeIcons.donate,
                  text: "Agregar donación al inventario",
                  onTap: () {
                    // Acción para este botón
                    print("Agregar donación");
                  },
                ),
                OptionCard(
                  icon: FontAwesomeIcons.clipboardCheck,
                  text: "Ver status del Centro",
                  onTap: () {
                    // Acción para este botón
                    print("Ver status");
                  },
                ),
                OptionCard(
                  icon: FontAwesomeIcons.truck,
                  text: "Solicitar envío",
                  onTap: () {
                    // Acción para este botón
                    print("Solicitar envío");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // BottomAppBar en lugar del BottomNavigationBar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.map, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserHomeScreen(userId: widget.userId, isBamxAdmin: false, isCenterAdmin: true,)),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline_rounded, color: Colors.black),
              onPressed: () {
                // Acción para ir al perfil
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
              onPressed: () {
                // Acción para notificaciones
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const OptionCard({
    required this.icon,
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: const Color(0xFFEF3030),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

