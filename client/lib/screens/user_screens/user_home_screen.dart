import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../user_profile.dart';


class UserHomeScreen extends StatefulWidget {
  final int userId;

  const UserHomeScreen({required this.userId, super.key});

  @override
  _UserHomeScreenState createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {

  @override
  void initState() {
    rootBundle.loadString('assets/map_style.json').then((string) {
      _mapStyleString = string;
    });
    super.initState();
    fetchData();
  }

  List<List<dynamic>> centers = [];
  late String _mapStyleString;

  bool isInfoWindowVisible = false;
  bool _isMapLoaded = false;

  LatLng? _selectedMarkerPosition;
  String? _selectedMarkerTitle;
  String? _selectedMarkerSnippet;

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  final PanelController _panelController = PanelController();
  final Set<Marker> _markers = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20.67471511804876, -103.43224564816127),
    zoom: 15,
  );

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
            item['centerAddress'],
            item['latitude'],
            item['longitude']
          ]).toList();
        });

        for (var center in centers) {
          final id = center[0];
          final name = center[1];
          final address = center[2];
          final latitude = center[3];
          final longitude = center[4];

          _markers.add(
            Marker(
              markerId: MarkerId(id.toString()),
              position: LatLng(latitude, longitude),
              onTap: () => _onMarkerTapped(
                LatLng(latitude, longitude),
                name,
                address,
              )
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

  Future<void> _goToCenter(double lat, double long, String name, String address) async {

    final GoogleMapController controller = await _mapController.future;
    CameraPosition newPosition = CameraPosition(
      target: LatLng(lat, long),
      zoom: 15,
    );
    await controller.animateCamera(CameraUpdate.newCameraPosition(newPosition));


    Future.delayed(Duration(milliseconds: 500), () {
      if (_panelController.isPanelOpen) {
        _panelController.close();
      }
    });

    _onMarkerTapped(
      LatLng(lat, long),
      name,
      address,
    );

  }

  Future<void> _goToMe() async {
    final GoogleMapController controller = await _mapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_initialPosition));
    _hideCustomInfoWindow();
  }


  void _onMarkerTapped(LatLng position, String title, String snippet) {
    print('Tappeeeeeeeeeeeeed!!');
    setState(() {
      isInfoWindowVisible = true;
      _selectedMarkerPosition = position;
      _selectedMarkerTitle = title;
      _selectedMarkerSnippet = snippet;
    });
  }

  void _hideCustomInfoWindow() {

    if(isInfoWindowVisible){
      print("Hidiiiiing!!!!");
      setState(() {
        isInfoWindowVisible = false;
        _selectedMarkerPosition == null;
      });
    }

  }

  void _goToUserInfoScreen(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              UserProfileScreen(userId: widget.userId)),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SlidingUpPanel(
        controller: _panelController,
        panel: Center(
          child: centers.isNotEmpty
              ? Padding(
            padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
            child: ListView.builder(
              itemCount: centers.length,
              itemBuilder: (context, index) {
                final center = centers[index];
                return Card(
                  color: const Color(0xFFE78080),
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      '${center[1]}', // Center name
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Toca para ir al centro',
                      style: const TextStyle()// Coordinates
                    ),
                    onTap: () {
                      _goToCenter(center[3], center[4], center[1], center[2]);
                    },
                  ),
                );
              },
            ),
          )
              : const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _initialPosition,
              markers: _markers,
              zoomControlsEnabled: false,
              scrollGesturesEnabled: !isInfoWindowVisible,
              zoomGesturesEnabled: !isInfoWindowVisible,
              rotateGesturesEnabled: !isInfoWindowVisible,
              tiltGesturesEnabled: !isInfoWindowVisible,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
                _mapController.future.then((value) {
                  value.setMapStyle(_mapStyleString);
                });
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
                    const SizedBox(height: 20),
                    const CircularProgressIndicator(),
                  ],
                ),
              ),
            if (isInfoWindowVisible)
              GestureDetector(
                onTap: () {
                  _hideCustomInfoWindow(); // Hide the info window on tap outside
                },
                child: Container(
                  color: Colors.transparent, // Invisible full-screen overlay
                ),
              ),
            if (isInfoWindowVisible == true)
              Positioned(
                key: UniqueKey(),
                left: MediaQuery.of(context).size.width / 2 - 125,
                bottom: 500,
                child: Container(
                  width: 250,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _selectedMarkerTitle ?? "",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          IconButton(
                            onPressed: _hideCustomInfoWindow,
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _selectedMarkerSnippet ?? "",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            Positioned(
            top: 50,
            right: 20,
              child: FloatingActionButton(
                onPressed: _goToUserInfoScreen,
                backgroundColor: const Color(0xFFEF3030),
                foregroundColor: Colors.white,
                child: const Icon(Icons.person),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 20,
              child: FloatingActionButton(
                onPressed: _goToMe,
                backgroundColor: const Color(0xFFEF3030),
                foregroundColor: Colors.white,
                child: const Icon(Icons.navigation),
              ),
            ),
          ],
        ),
        minHeight: 80,
        maxHeight: 650,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),

        //Sliding panel
        header: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 13, left: 100),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 150,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8), // Space between the bar and text
              const Text(
                "Centros de Acopio", // Your custom text
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
