import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../user_screens/user_home_screen.dart';
import './status_center.dart';

class DecimalInputFormatter extends TextInputFormatter {
  final RegExp _regex = RegExp(r'^\d{0,10}(\.\d{0,10})?$');

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_regex.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}

class CenterHome extends StatefulWidget {
  final int userId;

  const CenterHome({required this.userId, super.key});

  @override
  _CenterHome createState() => _CenterHome();
}

class _CenterHome extends State<CenterHome> {
  Map<String, dynamic> userInfo = {};
  Map<String, dynamic> centerInfo = {};
  late bool isSuccess = false;
  final TextEditingController _donationController = TextEditingController();


  @override
  void initState() {
    super.initState();
    fetchUserInfo();

  }

  Future<void> addDonation() async{
    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/donations/register');
    Map<String, dynamic> jsonData = {
      'receivIn': centerInfo['id'],
      'quan': _donationController.text,
    };

    try{
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      print(response.body);

    }catch(e){
      print(e);
    }
  }

  Future<void> fetchUserInfo()async{
    try {
      final url1 = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/users/userInfo');
      final url2 = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/users/userCenter');

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

        });
      } else {
        print('Failed to fetch user information. Please try again.');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> _sendCollectionRequest()async{
    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/collections/register');
    final result = (100 * (centerInfo['currentCapacity'] ?? 0)) / ((centerInfo['totalCapacity'] ?? 1).toDouble());

    Map<String, dynamic> jsonData = {
      'centerId': centerInfo['id'],
      'centerName': centerInfo['centerName'],
      'status': result
    };

    try{

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData)
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
                    "Bienvenido ${userInfo['nombre'] ?? ''}!",
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
                    const SizedBox(width: 10), // Add spacing between image and text
                    // Text
                    Text(
                      "${centerInfo['centerName'] ?? ''}",
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
                  icon: FontAwesomeIcons.circleDollarToSlot,
                  text: "Agregar donación al inventario",
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text(
                                "Agregar donación a tu inventario",
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              content: SingleChildScrollView(
                                child: isSuccess
                                    ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'images/bamx-logo.png',
                                      width: 150,
                                      height: 150,
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      '¡Donación registrada exitosamente!',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        Future.delayed(const Duration(seconds: 4));
                                        setState(() {
                                          isSuccess = false;
                                        });
                                        _donationController.clear();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFEF3030),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'CERRAR',
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                )
                                    : Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '¿Cuál fue la cantidad (En kilogramos) que fue donada?',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(height: 20),
                                    TextField(
                                      controller: _donationController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          borderSide: BorderSide.none,
                                        ),
                                        hintText: 'Ej. 123.456',
                                        hintStyle: const TextStyle(
                                          color: Color(0xFFA0A5BA),
                                          fontSize: 30,
                                        ),
                                        filled: true,
                                        fillColor: const Color(0xFFF0F5FA),
                                      ),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Color(0xFF4A4A4A),
                                        fontSize: 30,
                                      ),
                                      inputFormatters: [
                                        DecimalInputFormatter(),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: ()async {
                                        if (_donationController.text.isEmpty) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Escribe una cantidad.'),
                                              duration: Duration(seconds: 2),
                                              backgroundColor: Colors.red,
                                            ),
                                          );
                                          return;
                                        }
                                        await addDonation();
                                        setState(() {
                                          isSuccess = true;
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFEF3030),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        'REGISTRAR DONACIÓN',
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        _donationController.clear();
                                      },
                                      child: const Text(
                                        "Cancelar",
                                        style: TextStyle(fontSize: 20, color: Colors.grey),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                OptionCard(
                  icon: FontAwesomeIcons.clipboardCheck,
                  text: "Ver status del Centro",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StatusCenter(
                          centerId: centerInfo['id'],
                        ),
                      ),
                    );
                  },
                ),
                OptionCard(
                  icon: FontAwesomeIcons.truck,
                  text: "Solicitar envío",
                  onTap: () {
                    _sendCollectionRequest;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        padding: const EdgeInsets.only(bottom: 60),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.map, color: Colors.black,size: 50,),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserHomeScreen(userId: widget.userId, isBamxAdmin: false, isCenterAdmin: true,)),
                );
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

