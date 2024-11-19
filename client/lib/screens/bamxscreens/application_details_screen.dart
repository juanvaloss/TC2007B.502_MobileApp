import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../user_screens/user_home_screen.dart';
import '../user_screens/user_profile.dart';



class ApplicationDetailsScreen extends StatefulWidget {
  final int userId;

  ApplicationDetailsScreen({required this.userId, super.key});

  @override
  _ApplicationDetailsScreen createState() => _ApplicationDetailsScreen();
}

class _ApplicationDetailsScreen extends State<ApplicationDetailsScreen> {
  bool isChecked = false; // Estado inicial del Checkbox

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Application Details Screen'),
        backgroundColor: const Color(0xFFEF3030),
      ),
    );
  }
}
