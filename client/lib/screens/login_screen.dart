import 'dart:convert'; // For converting data to JSON format
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'home_screen_user.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void sendJsonData(context) async {
    //Replace the # symbols with the actual numbers of your IP address

    //If the connection keeps failing, try turning off the emulated device's Wi-Fi.
    final url = Uri.parse('http://#.#.#.#:3000/users/login');

    // Get the text from the TextField using the controller
    String username = usernameController.text;
    String password = passwordController.text;

    // Create the JSON data
    Map<String, dynamic> jsonData = {
      'username': username,
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreenUser()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid Credentials!. Please check the mail and password and try again.'),
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
    return Scaffold(
      appBar: AppBar(title: Text('Login Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: InputDecoration(hintText: 'Email'),
              //Regular expressions for preventing SQL Injections
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_.@]'))],
            ),
            TextField(
              obscureText: true,
              controller: passwordController,
              decoration: InputDecoration(hintText: 'Password'),
              //Regular expressions for preventing SQL Injections
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9_.]'))],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendJsonData(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}