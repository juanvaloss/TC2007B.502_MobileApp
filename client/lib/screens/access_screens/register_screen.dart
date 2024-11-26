import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../access_screens/code_screen.dart';
import '../access_screens/privacyNoticeScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailInputFormatter extends TextInputFormatter {
  final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]*@?[a-zA-Z0-9.-]*\.?[a-zA-Z]*$',
  );

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (_emailRegex.hasMatch(newValue.text) || newValue.text.isEmpty) {
      return newValue;
    }
    return oldValue;
  }
}

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
  final TextEditingController confirmPasswordController = TextEditingController();

  void sendJsonData() async {
    if (passwordController.text.isEmpty ||
        emailController.text.isEmpty ||
        nameController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor llena todos los campos requeridos'),
        ),
      );
      return;
    }
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
        ),
      );
      return;
    }

    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/users/create');

    Map<String, dynamic> jsonData = {
      'name': nameController.text,
      'email': emailController.text,
      'plainPassword': passwordController.text,
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

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MfaScreen(
              userId: userIdResponse,
              typeOfUser: 1,
              userEmail: emailController.text,
            ),
          ),
        );
      } else if (response.statusCode == 403) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Esta cuenta ya está registrada, intenta iniciar sesión."),
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
            Navigator.pop(context);
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
              padding: EdgeInsets.only(top: 12.5),
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
          Column(
            children: [
              Expanded(flex: 1, child: Container()),
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
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Nombre", style: TextStyle(fontSize: 10)),
                          const SizedBox(height: 10),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: "Ingresa tu nombre completo",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: const TextStyle(color: Color(0xFFA0A5BA)),
                              filled: true,
                              fillColor: const Color(0xFFF0F5FA),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text("Correo electrónico", style: TextStyle(fontSize: 10)),
                          const SizedBox(height: 10),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              hintStyle: const TextStyle(color: Color(0xFFA0A5BA)),
                              filled: true,
                              fillColor: const Color(0xFFF0F5FA),
                              isDense: true,
                            ),
                            inputFormatters: [EmailInputFormatter()],
                          ),
                          const SizedBox(height: 10),
                          const Text("Contraseña", style: TextStyle(fontSize: 10)),
                          const SizedBox(height: 10),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Contraseña",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF0F5FA),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text("Confirmar contraseña", style: TextStyle(fontSize: 10)),
                          const SizedBox(height: 10),
                          TextField(
                            controller: confirmPasswordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: "Confirma tu contraseña",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF0F5FA),
                              isDense: true,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                },
                              ),
                              RichText(
                                text: TextSpan(
                                  text: "He leído y acepto la ",
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const PrivacyNoticeScreen(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "política de privacidad",
                                          style: TextStyle(
                                            color: Color(0xFFEF3030),
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isChecked ? const Color(0xFFEF3030) : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: isChecked ? sendJsonData : null,
                              child: const Text(
                                'INGRESAR',
                                style: TextStyle(fontSize: 18, color: Colors.white),
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
