import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Top Section
          Container(
            width: screenWidth,
            color: const Color(0xFF1d1d37),
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
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Username",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'John Doe',
                            hintStyle: const TextStyle(
                              color: Color(0xFFA0A5BA),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF0F5FA),
                          ),
                          style: const TextStyle(
                            color: Color(0xFFA0A5BA),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_.]'))
                          ],
                        ),

                        // Email
                        const SizedBox(height: 10),
                        const Text(
                          "Email",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          decoration: InputDecoration(
                            labelText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'name@domain.com',
                            hintStyle: const TextStyle(
                              color: Color(0xFFA0A5BA),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF0F5FA),
                          ),
                          style: const TextStyle(
                            color: Color(0xFFA0A5BA),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_.@]'))
                          ],
                        ),

                        // Password
                        const SizedBox(height: 10),
                        const Text(
                          "Contraseña",
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: "Contraseña",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            hintText: 'UwU',
                            hintStyle: const TextStyle(
                              color: Color(0xFFA0A5BA),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFF0F5FA),
                          ),
                          style: const TextStyle(
                            color: Color(0xFFA0A5BA),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_.]'))
                          ],
                        ),

                        // Button
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Add your onPressed functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF3030),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(200, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text('Ingresa'),
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
