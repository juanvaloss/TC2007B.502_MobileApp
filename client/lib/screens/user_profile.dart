import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProfileScreen extends StatefulWidget{
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
    const apiKey = '#'; // Replace with your API key
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=17&size=650x300&markers=color:red%7C$latitude,$longitude&key=$apiKey';
  }

  Future<void> fetchUserInfo() async {
    try {
      // Replace the # with ur actual ip
      final url1 = Uri.parse('http://#.#.#.#:3000/users/userInfo');
      final url2 = Uri.parse('http://#.#.#.#:3000/users/userCenters');

      // Prepare the JSON data
      Map<String, dynamic> jsonData = {
        'userId': widget.userId,
      };

      // Send the first POST request
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

      if(response2.statusCode == 200 && response2.body.isNotEmpty){
        final Map<String, dynamic> responseData2 = json.decode(response2.body);

        setState(() {
          // Merge the data from both responses if necessary
          centerInfo = [responseData2];
        });
      }else{
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Info')),
      body: userInfo != null && centerInfo != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Separator for userInfo
            const Text(
              'User Information:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...userInfo!.entries.map((entry) {
              return ListTile(
                title: Text(_capitalizeFirstLetter(entry.key)),
                subtitle: Text(entry.value.toString()),
              );
            }),

            // Separator for centerInfo
            const SizedBox(height: 16),
            const Text(
              'Center Information:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Display each center's information
            ...centerInfo!.map((center) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name: ${center['name']}",
                    style: const TextStyle(fontSize: 16), // Set the font size for uniformity
                  ),
                  const SizedBox(height: 4), // Space between name and address
                  Text(
                    "Address: ${center['address']}",
                    style: const TextStyle(fontSize: 16), // Same font size as the name
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