import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';


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

  UserHomeScreen({required this.userId, super.key});

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
    final url = Uri.parse('http://192.168.101.118:3000/centers/coordinates'); // Replace with your API URL

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Data received: $data'); // Debugging line

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

  GoogleMapController? _mapController;

  // Initial location (latitude and longitude) for the map
  static const LatLng _initialPosition = LatLng(37.7749, -122.4194); // Example: San Francisco

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding to add space for rounded corners
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0), // Adjust the radius as needed
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialPosition,
                zoom: 12,
              ),
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
              },
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
            ),
          ),
        ),
      ),
    );
  }
}
