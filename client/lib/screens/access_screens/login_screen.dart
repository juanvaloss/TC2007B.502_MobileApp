import 'dart:convert'; // For converting data to JSON format
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../access_screens/register_screen.dart';
import '../access_screens/code_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obscurePassword = true;

  LoginScreen({super.key});

  void sendJsonData(context) async {
    final url = Uri.parse('http://x.x.x.x:3000/users/login');

    String email = usernameController.text;
    String password = passwordController.text;

    Map<String, dynamic> jsonData = {
      'email': email,
      'plainPassword': password,
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
        print(responseData);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MfaScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Invalid Credentials!. Please check the email and password and try again.'),
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
              padding: EdgeInsets.only(top: 70.0),
              child: Column(
                children: [
                  Text(
                    "Log in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Por favor ingresa los datos de tu cuenta",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            "Mail",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFB0B0B0),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: usernameController,
                            style: const TextStyle(color: Color(0xFFA0A5BA)),
                            decoration: InputDecoration(
                              hintText: 'example@gmail.com',
                              hintStyle: const TextStyle(color: Color(0xFFA0A5BA)),
                              fillColor: const Color(0xFFF0F5FA),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_.@]')),
                            ],
                          ),
                          const SizedBox(height: 35),
                          const Text(
                            "Contraseña",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFB0B0B0),
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            obscureText: true,
                            controller: passwordController,
                            style: const TextStyle(color: Color(0xFFA0A5BA)),
                            decoration: InputDecoration(
                              hintText: 'Contraseña',
                              hintStyle: const TextStyle(color: Color(0xFFA0A5BA)),
                              fillColor: const Color(0xFFF0F5FA),
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_.]')),
                            ],
                          ),
                          const SizedBox(height: 40),
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
                          const SizedBox(height: 50),
                          Center(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "¿No tienes una cuenta?",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => RegisterScreen()));
                                      },
                                      child: const Text(
                                        "REGÍSTRATE",
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
