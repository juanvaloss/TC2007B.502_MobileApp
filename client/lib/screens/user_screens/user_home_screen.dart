import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationCenter {
  final int id;
  final String centerName;
  final double latitude;
  final double longitude;

  LocationCenter({
    required this.id,
    required this.centerName,
    required this.latitude,
    required this.longitude,
  });

  factory LocationCenter.fromJson(Map<String, dynamic> json) {
    return LocationCenter(
      id: json['id'],
      centerName: json['centerName'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class UserHomeScreen extends StatefulWidget {
  final int userId;

  UserHomeScreen({required this.userId});

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<LocationCenter> centers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://192.168.101.111:3000/centers/coordinates'); // Replace with your API URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          centers = data.map((item) => LocationCenter.fromJson(item)).toList();
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Centers')),
      body: centers.isNotEmpty
          ? ListView.builder(
              itemCount: centers.length,
              itemBuilder: (context, index) {
                final center = centers[index];
                return ListTile(
                  title: Text(center.centerName),
                  subtitle: Text('Lat: ${center.latitude}, Lng: ${center.longitude}'),
                );
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
