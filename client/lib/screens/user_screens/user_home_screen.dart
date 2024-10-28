import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LocationCenter {
  final int id;
  final String centerName;

  LocationCenter({
    required this.id,
    required this.centerName,
  });

  factory LocationCenter.fromJson(Map<String, dynamic> json) {
    return LocationCenter(
      id: json['id'],
      centerName: json['centerName']
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
    final url = Uri.parse('http://192.168.101.104:3000/centers/coordinates'); // Replace with your API URL

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
    body:Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "Centros de acopio cerca de ti:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SingleChildScrollView(
        child: Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: centers.isNotEmpty
              ? GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 2,
                  ),
                  itemCount: centers.length,
                  itemBuilder: (context, index) {
                    final center = centers[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                            spreadRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(color: Colors.grey),
                            padding: const EdgeInsets.all(8.0),
                            child: const Text("[IMG]", style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(height: 8.0),
                          Text(center.centerName,  style: const TextStyle(fontSize: 16), textAlign: TextAlign.left,),

                        ],
                      ),
                    );
                  },
                )
              : const Center(child: CircularProgressIndicator()),
          ),
        ),
        ),
      ],
    ),
  );
}
}