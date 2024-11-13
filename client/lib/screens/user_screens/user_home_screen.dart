import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


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

  static const double maxDistance = 900;
  bool isInfoWindowVisible = false;
  LatLng? _selectedMarkerPosition;
  String? _selectedMarkerTitle;
  String? _selectedMarkerSnippet;

  final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
  final PanelController _panelController = PanelController();
  final Set<Marker> _markers = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20.7360372, -103.4557347),
    zoom: 15,
  );


  bool _isMapLoaded = false;

  Future<void> fetchData() async {
    final url = Uri.parse('http://192.168.101.118:3000/centers/coordinates');

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
  }


  void _onMarkerTapped(LatLng position, String title, String snippet) {
    setState(() {
      isInfoWindowVisible = true;
      _selectedMarkerPosition = position;
      _selectedMarkerTitle = title;
      _selectedMarkerSnippet = snippet;
    });
  }

  void _hideCustomInfoWindow() {
    setState(() {
      _selectedMarkerPosition = null;
    });
  }

  void _onCameraMove(CameraPosition position) {

    if ( _selectedMarkerPosition == null) {
      return;
    }

    double distance = Geolocator.distanceBetween(
      _selectedMarkerPosition!.latitude,
      _selectedMarkerPosition!.longitude,
      position.target.latitude,
      position.target.longitude,
    );
    print(distance);

    if (distance > maxDistance && isInfoWindowVisible) {
      _hideCustomInfoWindow();
    } else if (distance <= maxDistance && !isInfoWindowVisible) {
      _hideCustomInfoWindow();
    }
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
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(
                      '${center[1]}', // Center name
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Toca para ir al centro', // Coordinates
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
              zoomGesturesEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _mapController.complete(controller);
                _mapController.future.then((value) {
                  value.setMapStyle(_mapStyleString);
                });
                setState(() {
                  _isMapLoaded = true;
                });
              },
              onCameraMove: _onCameraMove,

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
            if (isInfoWindowVisible == true)
              Positioned(
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
              bottom: 100,
              left: 20,
              child: FloatingActionButton(
                onPressed: _goToMe,
                child: const Icon(Icons.my_location),
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
