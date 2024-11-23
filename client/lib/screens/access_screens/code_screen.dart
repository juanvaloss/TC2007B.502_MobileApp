import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../user_screens/user_home_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../center_screens/center_home.dart';

class MfaScreen extends StatelessWidget {
  final int userId;
  final int typeOfUser;
  final String userEmail;

  MfaScreen({super.key, required this.userId, required this.typeOfUser, required this.userEmail});

  final TextEditingController mfaController = TextEditingController();

  void sendJsonData(context) async {
    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/tfa/${typeOfUser}');

    String mfaCode = mfaController.text;

    Map<String, dynamic> jsonData = {
      'userId': userId,
      'codeSentForVeri': mfaCode
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final userIdResponse = responseData['userId'];
        final bool isBamxAdmin = responseData['isBamxAdmin'];
        final bool isCenterAdmin = responseData['isCenterAdmin'] ?? false;
        print(isCenterAdmin);

        if(isCenterAdmin){
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => CenterHome(userId: userIdResponse)),
                (Route<dynamic> route) => false,
          );
        }else{
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => UserHomeScreen(userId: userIdResponse, isBamxAdmin: isBamxAdmin,)),
                (Route<dynamic> route) => false,
          );

        }




      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Algo salió mal, inténtalo de nuevo."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void getNewCode(context) async {
    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/tfa/newCode/${typeOfUser}');

    Map<String, dynamic> jsonData = {'userId': userId, 'email': userEmail};

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                "Se ha enviado un nuevo código, revisa tu correo electrónico."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Algo salió mal, inténtalo de nuevo."),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );

      }

    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121223),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            color: const Color(0xFF121223),
            child: const Padding(
              padding: EdgeInsets.only(top: 25.0, left: 12.5, right: 12.5),
              child: Column(
                children: [
                  Text(
                    "Ingresa el código",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Mandamos un código de verificación de 6 dígitos a tu correo electrónico",
                      style: TextStyle(color: Colors.white, fontSize: 17),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(flex: 2, child: Container()),
              Expanded(
                flex: 4,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 45),
                          const Text(
                            "Código de verificación: ",
                            style: TextStyle(
                              color: const Color(0xFF121223),
                              fontSize: 24,
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            width: 300,
                            height: 150,
                            child: TextField(
                              controller: mfaController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                              ],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 12,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: "     Escribe el código",
                                labelStyle: TextStyle(
                                    fontSize: 24, color: Colors.grey[500]),
                                hintText: "123456",
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF0F5FA),
                                isDense: true,
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(left: 25, right: 25),
                            child: Center(
                              child: Column(
                                children: [
                                  const Text(
                                    "¿No recibiste un código?",
                                    style: TextStyle(
                                        color: Color(0xFF646982), fontSize: 18),
                                    textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      getNewCode(context);
                                    },
                                    child: const Text(
                                      "Volver a enviar",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFFEF3030)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 50),
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
                                sendJsonData(context);
                              },
                              child: const Text(
                                'Ingresar',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
