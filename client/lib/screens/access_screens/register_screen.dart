import 'dart:convert'; // For converting data to JSON format
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../user_profile.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool isChecked = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void sendJsonData(context) async {
    final url = Uri.parse('http://#.#.#.#:3000/users/create');

    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;

    Map<String, dynamic> jsonData = {
      'name': name,
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
        final int userIdResponse = responseData['userId'];
        print(responseData);

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserProfileScreen(userId: userIdResponse)),
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
      body: Stack(
        children: [
          // Top Section
          Container(
            width: screenWidth,
            color: const Color(0xFF121223),
            child: const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Column(
                children: [
                  Text(
                    "Regístrate",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Por favor registra tus datos para hacer una cuenta",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Section with Form
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Username
                        const Text(
                          "Nombre",
                          style: TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Ingresa tu nombre completo",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_. ]'))
                          ],
                        ),

                        // Email
                        const SizedBox(height: 10),
                        const Text(
                          "Correo electrónico",
                          style: TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Ingresa tu correo electrónico:',
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
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_.@ ]'))
                          ],
                        ),

                        // Password
                        const SizedBox(height: 10),
                        const Text(
                          "Contraseña",
                          style: TextStyle(fontSize: 10),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'Ingresa tu contraseña:',
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
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_. ]'))
                          ],
                        ),

                        //Checkbox and policies
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        isChecked = value ?? false;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 20),
                                  const Text.rich(
                                    TextSpan(
                                      text: "He leído y acepto la ",
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: "\npolítica de privacidad",
                                          style: TextStyle(
                                              color: Color(0xFFEF3030)),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              //Button
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  if (isChecked){
                                  sendJsonData(context);
                                  }
                                  else {
                                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Debes aceptar las políticas de privacidad')));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF3030),
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(270, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Text('Registrarse',
                                style: TextStyle(fontSize: 20)),
                              ),
                            ],
                          ),
                        ),
                      ],
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
