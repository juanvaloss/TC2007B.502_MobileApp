import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


class UserHomeScreen extends StatefulWidget {
  final int userId;

  UserHomeScreen({required this.userId, super.key});

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  List<List<dynamic>> centers = [];

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  Set<Marker> _markers = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20.733370980302727, -103.45433592828915),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    target: LatLng(20.733370980302727, -103.45433592828915),
    zoom: 14.4746,
  );


  bool _isMapLoaded = false;

  Future<void> fetchData() async {
    final url = Uri.parse('http://10.43.121.69:3000/centers/coordinates');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          centers = data.map((item) => [
            item['id'],
            item['centerName'],
            item['latitude'],
            item['longitude']
          ]).toList();
        });

        for (var center in centers) {
          final id = center[0];
          final name = center[1];
          final latitude = center[2];
          final longitude = center[3];

          _markers.add(
            Marker(
              markerId: MarkerId(id.toString()),
              position: LatLng(latitude, longitude),
              infoWindow: InfoWindow(
                title: name,
                snippet: "Center ID: $id",
              ),
            ),
          );
        }

      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _mapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SlidingUpPanel(
        panel: Center(
          child: centers.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: centers.length,
              itemBuilder: (context, index) {
                final center = centers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      '${center[1]}', // Center name
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Toca para ir al centro', // Coordinates
                    ),
                    onTap: () {
                      //_goToCenter(center[2], center[3]);
                    },
                  ),
                );
              },
            ),
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
                setState(() {
                  _isMapLoaded = true;
                });
              },
            ),
            if (!_isMapLoaded)
              Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/bamx-logo.png',
                      width: 600,
                      height: 200,
                    ),
                    SizedBox(height: 20),
                    CircularProgressIndicator(),
                  ],
                ),
              ),
            Positioned(
              bottom: 120,
              left: 20,
              child: FloatingActionButton(
                onPressed: _goToTheLake,
                child: Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
