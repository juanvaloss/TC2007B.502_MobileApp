import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CenterHome extends StatefulWidget {
  final int userId;
  final int centerId;

  const CenterHome({required this.userId, required this.centerId, super.key});

  @override
  _CenterHome createState() => _CenterHome();
}

class _CenterHome extends State<CenterHome>{

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Centro de Vacunación'),
        backgroundColor: const Color(0xFFEF3030),
      ),
    );
  }
}