import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfileScreen extends StatefulWidget {
  final int userId;

  const UserProfileScreen({super.key, required this.userId});

  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserProfileScreen> {
  Map<String, dynamic>? userInfo;
  List<Map<String, dynamic>>? centerInfo;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _generateMapUrl(double latitude, double longitude) {
    const apiKey = 'AIzaSyAEW6obJehSR'; // Replace with your API key
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=17&size=650x300&markers=color:red%7C$latitude,$longitude&key=$apiKey';
  }

  Future<void> fetchUserInfo() async {
    try {
      final url1 = Uri.parse('http://192.168.101.125:3000/users/userInfo');
      final url2 = Uri.parse('http://192.168.101.125:3000/users/userCenters');

      Map<String, dynamic> jsonData = {
        'userId': widget.userId,
      };

      final response1 = await http.post(
        url1,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );
      final response2 = await http.post(
        url2,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(jsonData),
      );

      if (response1.statusCode == 200 && response1.body.isNotEmpty) {
        final responseData1 = json.decode(response1.body);
        setState(() {
          userInfo = {
            ...responseData1,
          };
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch user information. Please try again.';
        });
      }

      if (response2.statusCode == 200 && response2.body.isNotEmpty) {
        final dynamic responseData2 = json.decode(response2.body);

        if (responseData2 is List) {
          setState(() {
            centerInfo = List<Map<String, dynamic>>.from(responseData2);
          });
        } else if (responseData2 is Map<String, dynamic>) {
          setState(() {
            centerInfo = [responseData2];
          });
        } else {
          setState(() {
            errorMessage = 'Unexpected response format.';
          });
        }
      } else {
        setState(() {
          errorMessage = 'No information available.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  Widget _buildUserInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.red[200],
          child: Icon(Icons.person, size: 40, color: Colors.white),
        ),
        const SizedBox(height: 16),
        Text(
          userInfo?['name'] ?? 'Local Shop',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

      ],
    );
  }

  Widget _buildUserInfoContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFF0F5FA),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'User Info:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...userInfo!.entries
              .where((entry) => entry.key.toLowerCase() != 'id') // Filtrar "Id"
              .map((entry) {
            return ListTile(
              title: Text(_capitalizeFirstLetter(entry.key)),
              subtitle: Text(entry.value.toString()),
            );
          }),
        ],
      ),
    );
  }


  Widget _buildCenterInfoContainer() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Color(0xFFF0F5FA),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Center Info:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...centerInfo!.map((center) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Name: ${center['name']}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "Address: ${center['address']}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Image.network(
                    _generateMapUrl(
                      center['latitude'],
                      center['longitude'],
                    ),
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: userInfo != null && centerInfo != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildUserInfoSection(),
            _buildUserInfoContainer(),
            _buildCenterInfoContainer(),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF3030),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                },
                child: const Text(
                  'Solicitud de Centro',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
          : Center(
        child: errorMessage.isEmpty
            ? const CircularProgressIndicator()
            : Text(
          errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      ),
    );
  }
}
