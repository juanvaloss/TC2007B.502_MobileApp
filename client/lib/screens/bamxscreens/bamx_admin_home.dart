import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../user_screens/user_home_screen.dart';
import '../user_screens/user_profile.dart';



class BamxAdminHome extends StatefulWidget {
  final int userId;

  BamxAdminHome({required this.userId, super.key});

  @override
  _BamxAdminHome createState() => _BamxAdminHome();
}

class _BamxAdminHome extends State<BamxAdminHome> {
  bool isChecked = false; // Estado inicial del Checkbox

  @override
  Widget build(BuildContext context) {
    //double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('BAMX Admin Home'),
        backgroundColor: const Color(0xFFEF3030),
      ),
    );
  }
}
