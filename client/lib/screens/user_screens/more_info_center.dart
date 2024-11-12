import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoreInfoCenter extends StatefulWidget {
  final int userId;
  final int centerId;

  const MoreInfoCenter({required this.userId, super.key, required this.centerId});

  @override
  _MoreInfoCenterState createState() => _MoreInfoCenterState();
}

class _MoreInfoCenterState extends State<MoreInfoCenter> {
  List<Map<String, dynamic>>? centerInfo;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchCenterData();
  }

  Future<void> fetchCenterData() async {
    final url = Uri.parse('http://192.168.101.125:3000/centers/centerinfo'); // Replace with your API URL

    Map<String, dynamic> jsonData = {
      'centerId': widget.centerId,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      ); 

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Data received: $data'); // Debugging line

        if (mounted) {
          setState(() {
            centerInfo = data;
          });
        }
      } else {
        setState(() {
          errorMessage = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Center Information'),
      ),
      body: centerInfo != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Text('Centro de acopio: ${centerInfo!['centerName']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('ID: ${widget.centerId}'),
                  // Agrega más campos según la información disponible en centerInfo
                ],
              ),
            )
          : Center(
              child: errorMessage.isEmpty
                  ? CircularProgressIndicator()
                  : Text(errorMessage, style: TextStyle(color: Colors.red)),
            ),
    );
  }
}
