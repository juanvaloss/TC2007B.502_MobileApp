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
    final url = Uri.parse('http://x.x.x.x:3000/centers/coordinates'); // Replace with your API URL

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
    body: Column(
      children: [
        Expanded(
          child: Container(),
        ),
        
        const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "Centros de acopio cerca de ti:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        
        Expanded(
          flex: 8,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 8.0, right: 10),
            child: centers.isNotEmpty
                ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0, 
                      crossAxisSpacing: 20.0, 
                      childAspectRatio: 1.2,
                    ),
                    itemCount: centers.length,
                    itemBuilder: (context, index) {
                      final center = centers[index];
                      return Container(
                        padding: const EdgeInsets.all(10.0), // Internal padding for each container
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                              spreadRadius: 2,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 50,
                              decoration: const BoxDecoration(color: Colors.grey),
                              alignment: Alignment.center,
                              child: const Text("[IMG]", style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              center.centerName,
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),

        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (){}
                , child: Text("Home")
                ),
                ElevatedButton(
                  onPressed: (){}
                , child: Text("Profile")
                )
      ] 
      )

            ,)
          )
      ],
    ),
  );
}
}