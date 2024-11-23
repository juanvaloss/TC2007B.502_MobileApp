import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'notifications_screen.dart';

class ApplicationDetailsScreen extends StatefulWidget {
  final int applicationId;
  final int solicitorId;
  final int adminId;

  ApplicationDetailsScreen({required this.applicationId, required this.solicitorId, required this.adminId,super.key});

  @override
  _ApplicationDetailsScreen createState() => _ApplicationDetailsScreen();
}

class _ApplicationDetailsScreen extends State<ApplicationDetailsScreen> {
  Map<String, dynamic> userInfo = {};
  Map<String, dynamic> applicationInfo = {};
  late String firstNameOfC;
  Uint8List? _imageFile;
  late bool needsReloading;


  Future<void> _getApplicationInfo() async {
    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/applications/getReqInfo');
    Map<String, dynamic> jsonData = {
      'applicationId': widget.applicationId,
    };

    try{

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonData),
      );

      if(response.statusCode == 200){
        final responseData = json.decode(response.body);
        setState(() {
          applicationInfo = responseData;
          firstNameOfC = responseData['centerName'].split(' ').first;
        });

        print(applicationInfo);
      }

      final supabase = SupabaseClient(dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_ANON_KEY']!);

      final storageResponse = await supabase
          .storage
          .from('imagesOfCenters')
          .download('center${widget.solicitorId}${firstNameOfC}.jpg');

      setState(() {
        _imageFile = storageResponse;
      });

    }catch(e){
      print(e);
    }

  }

  Future<void> _getUserInfo()async{
    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/users/userInfo');
    Map<String, dynamic> jsonData = {
      'userId': widget.solicitorId,
    };

    try{

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonData),
      );

      if(response.statusCode == 200){
        final responseData = json.decode(response.body);
        setState(() {
          userInfo = responseData;
        });
      }

    }catch(e){
      print(e);
    }

  }

  Future<void> _acceptApplication() async{
    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/centers/create');
    final url2 = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/applications/deleteAll');

    Map<String, dynamic> jsonData = {
      'userId': widget.solicitorId,
      'adminId': widget.adminId,
      'centerNa': applicationInfo['centerName'],
      'centerAdd': applicationInfo['centerAddress'],
      'totalCapac': applicationInfo['capacity'],
      'acceptsM': applicationInfo['acceptsMeat'],
      'acceptsV': applicationInfo['acceptsVegetables'],
      'acceptsC': applicationInfo['acceptsCans']
    };

    Map<String, dynamic> jsonSolicitor = {
      'solicitor': widget.solicitorId
    };

    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonData),
      );

      final response2 = await http.post(
        url2,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonSolicitor),
      );

      if(response.statusCode == 200 && response2.statusCode == 200){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NotificationsScreen(adminId: widget.adminId,)),
              (Route<dynamic> route) => route.isFirst,
        );
      }
    }catch(e){
      print(e);
    }
  }

  Future<void> _rejectApplication() async{
    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/applications/delete');
    Map<String, dynamic> jsonSolicitor = {
      'applicationId': widget.applicationId
    };

    try{
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(jsonSolicitor),
      );

      if(response.statusCode == 200){
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => NotificationsScreen(adminId: widget.adminId,)),
              (Route<dynamic> route) => route.isFirst,
        );
      }
    }catch(e){
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _getApplicationInfo();
    _getUserInfo();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        title: const Text(
          "Detalles de solicitud",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.orangeAccent.withOpacity(0.3),
                      child: _imageFile != null
                          ? ClipOval(
                        child: Image.memory(
                          _imageFile!, // Use the Uint8List image
                          width: 80, // Match the CircleAvatar diameter
                          height: 80,
                          fit: BoxFit.cover, // Ensure the image covers the area
                        ),
                      )
                          : const Icon(
                        Icons.person, // Placeholder icon if no image is available
                        size: 40,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Nombre del Centro",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${applicationInfo['centerName']}",
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 12),

                    // Applicant Information Section
                    _buildSectionHeader("Información Del Solicitante"),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.person, "Nombre completo:", "${userInfo['name']}"),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.email, "Email", "${userInfo['email']}"),

                    const SizedBox(height: 14),
                    _buildSectionHeader("Detalles Del Centro"),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                        Icons.location_on, "Dirección del Centro", "${applicationInfo['centerAddress']}"),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.scale, "Capacidad en KG", "${applicationInfo['capacity']}"),

                    const SizedBox(height: 14),
                    _buildSectionHeader("ACEPTA:"),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _CategoryIcon(icon: Icons.restaurant_menu, label: "Carne", acceptsX: applicationInfo['acceptsMeat']?? false,),
                        _CategoryIcon(icon: Icons.eco, label: "Verduras", acceptsX: applicationInfo['acceptsVegetables']?? false),
                        _CategoryIcon(icon: FontAwesomeIcons.bucket, label: "Enlatados", acceptsX: applicationInfo['acceptsCans']?? false),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [ // Spacing between buttons
                  // Reject Button
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: _rejectApplication,
                      child: const Text(
                        "RECHAZAR",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                  // Accept Button
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.all(16),
                      ),
                      onPressed: _acceptApplication,
                      child: const Text(
                        "ACEPTAR",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.red,
          radius: 20,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool acceptsX;

  const _CategoryIcon({required this.icon, required this.label, required this.acceptsX});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: acceptsX ? Colors.red : Colors.red.withOpacity(0.1),
          child: Icon(
            icon,
            size: 30,
            color: acceptsX ? Colors.white : Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: acceptsX ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}