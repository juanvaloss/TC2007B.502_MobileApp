import 'dart:convert'; // For converting data to JSON format
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../user_profile.dart';

class RegisterScreen extends StatelessWidget {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterScreen({super.key});

  void sendJsonData(context) async {
    //Replace the # symbols with the actual numbers of your IP address

    //If the connection keeps failing, try turning on the emulated device's Wi-Fi.
    final url = Uri.parse('http://#.#.#.#:3000/users/create');

    // Get the text from the TextField using the controller
    String name = nameController.text;
    String email = emailController.text;
    String password = passwordController.text;


    // Create the JSON data
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
              builder: (context) => UserProfileScreen(userId: userIdResponse)
          ),

        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Algo salió mal, inténtalo de nuevo."),
            backgroundColor: Colors.red,  // You can style it to look like a warning
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch(e){
      print('Error: $e');
    }

  }

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
                          style: TextStyle(fontSize: 18),
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
                          style: TextStyle(fontSize: 18),
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
                          ),
                          style: const TextStyle(
                            color: Color(0xFFA0A5BA),
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_. ]'))
                          ],
                        ),

                        // Button
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            sendJsonData(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF3030),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(200, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text('Registrarse'),
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
