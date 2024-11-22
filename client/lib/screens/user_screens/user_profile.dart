import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../access_screens/starting_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './application_screen.dart';

class UserProfileScreen extends StatefulWidget {
  final int userId;
  final bool isBamxAdmin;

  const UserProfileScreen({super.key, required this.userId, required this.isBamxAdmin});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic> userInfo = {};
  List<Map<String, dynamic>> centerInfo = [];

  @override
  void initState() {

    fetchUserInfo();
    super.initState();

  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _generateMapUrl(double latitude, double longitude) {
    var apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=17&size=650x300&markers=color:red%7C$latitude,$longitude&key=$apiKey';
  }

  void _goToApplication(){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplicationScreen(userId: widget.userId,), // Replace with your screen widget
      ),
    );


  }

  Future<void> fetchUserInfo() async {
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

      if (response1.statusCode == 200 && response1.body.isNotEmpty) {
        final responseData1 = json.decode(response1.body);
        setState(() {
          userInfo = {
            "nombre": responseData1['name'],
            "email": responseData1['email'],
            "isCenterAdmin": responseData1['isCenterAdmin'],
          };
        });
      } else {
        print('Failed to fetch user information. Please try again.');
      }

      if (response2.statusCode == 200 && response2.body.isNotEmpty) {
        final List<dynamic> responseData2 = json.decode(response2.body);
        final List<Map<String, dynamic>> centers = responseData2.map((item) {
          return {
            "centerName": item['centerName'],
            "centerAddress": item['centerAddress'],
            "latitude": item['latitude'],
            "longitude": item['longitude'],
          };
        }).toList();

        setState(() {
          centerInfo = centers;
        });
      } else {
        print('No information available.');
      }


    } catch (e) {
        print('An error occurred: $e');
    }
  }

  Future<void> _deleteUserAccount()async{
    try{
      final url = Uri.parse("http://${dotenv.env['LOCAL_IP']}:3000/users/delete");

      Map<String, dynamic> jsonData = {
        'userId': widget.userId,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      if(response.statusCode == 200){

      }

    }catch(e){
      print(e);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: const Text('Perfil de usuario'), backgroundColor: Colors.white,),
      backgroundColor: Colors.white,
      body: userInfo.isNotEmpty
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
          Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.red[200],
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tu perfil',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

          ],
        ),
            Container(
              padding: const EdgeInsets.all(16.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F5FA),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tu información:',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ...userInfo.entries
                      .where((entry) => entry.key.toLowerCase() != 'iscenteradmin')
                      .map((entry) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${_capitalizeFirstLetter(entry.key)}:",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.value.toString(),
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                      ],
                    );
                  }),
                ],
              ),
            ),
            if (userInfo['isCenterAdmin'] == true) ...[
              const Text(
                'Información de tu centro:',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: centerInfo.length,
                itemBuilder: (context, index) {
                  final center = centerInfo[index];
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Nombre del centro:",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text("     ${center['centerName']}", style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 4),
                          const Text(
                            "Dirección del centro: ",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          Text("     ${center['centerAddress']}", style: const TextStyle(fontSize: 18)),
                          const SizedBox(height: 8),
                          Center(
                            child: Image.network(
                              _generateMapUrl(center['latitude'], center['longitude']),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
            const SizedBox(height: 8),
            if (!userInfo['isCenterAdmin'])
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF3030),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    _goToApplication();
                  },
                  child: const Text(
                    'Solicitud de Centro',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => StartingPage()),
                        (Route<dynamic> route) => false,
                  );
                  print('Session closed');
                },
                child: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirmación", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        content: const Text("¿Estás seguro de que quieres eliminar tu cuenta? Esta acción no se puede deshacer.", style: TextStyle(fontSize: 20),),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancelar", style: TextStyle(fontSize: 18)),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () {
                              // Add your delete account logic here
                              Navigator.of(context).pop();
                              print('Account deleted');
                            },
                            child: const Text(
                              "Eliminar Cuenta",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text(
                  'Eliminar Cuenta',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      )
          : const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}