import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../user_screens/user_home_screen.dart';

class MfaScreen extends StatelessWidget {

  final int userId;
  MfaScreen({super.key, required this.userId});

  final TextEditingController mfaController = TextEditingController();

  void sendJsonData(context) async {
    final url = Uri.parse('http://x.x.x.x:3000/tfa/');

    String mfaCode = mfaController.text;

    Map<String, dynamic> jsonData = {
      'userId':  userId,
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
        final int userIdResponse = responseData['id'];
        print(responseData);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserHomeScreen(userId: userIdResponse)),
        );
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121223),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop(); // Acción del botón de regreso
          },
        ),
        elevation: 0, // Sin sombra para el AppBar
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      "Mandamos un código de verificación de 6 dígitos a tu correo electrónico",
                      style: TextStyle(
                        color: Colors.white,
                      ),
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
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ingresa el código: ",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: mfaController,
                            decoration: InputDecoration(
                              labelText: "Escribe el código",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Ingresa tu nombre completo:',
                              hintStyle: const TextStyle(
                                color: Color(0xFFA0A5BA),
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF0F5FA),
                              isDense: true,
                            ),
                            style: const TextStyle(
                              color: Color(0xFFA0A5BA),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                            ],
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
                                      color: Color(0xFF646982),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  TextButton(
                                    onPressed: (){},
                                    style: TextButton.styleFrom(
                                      foregroundColor: const Color(0xFFEF3030)
                                    ),
                                    child: const Text("Volver a envíar"),
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
                                      'INGRESAR',
                                      style: TextStyle(
                                        fontSize: 18,
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
