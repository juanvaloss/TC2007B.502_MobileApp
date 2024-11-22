import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'image_application_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

class ApplicationScreen extends StatefulWidget {

  final int userId;
  const ApplicationScreen({super.key, required this.userId});

  @override
  State<ApplicationScreen> createState() => _ApplicationScreenState();
}

class _ApplicationScreenState extends State<ApplicationScreen> {
  final TextEditingController _centerNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _capacityKgController = TextEditingController();

  bool _isCarneSelected = false;
  bool _isVegetablesSelected = false;
  bool _isCansSelected = false;

  void _toggleProductSelection(String product) {
    setState(() {
      switch (product) {
        case 'Carne':
          _isCarneSelected = !_isCarneSelected;
          break;
        case 'Verduras':
          _isVegetablesSelected = !_isVegetablesSelected;
          break;
        case 'Enlatados':
          _isCansSelected = !_isCansSelected;
          break;
      }
    });
  }

  Future<void> _sendApplication() async {
    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/applications/create');
    final centerName = _centerNameController.text.trim();
    final centerAddress = _addressController.text.trim();
    final capacityKg = _capacityKgController.text.trim();

    if (centerName.isNotEmpty && centerAddress.isNotEmpty && capacityKg.isNotEmpty) {
      Map<String, dynamic> jsonData = {
        'userId': widget.userId,
        'centerName': centerName,
        'centerAddress': centerAddress,
        'capac': capacityKg,
        'acceptsM': _isCarneSelected,
        'acceptsV': _isVegetablesSelected,
        'acceptsC': _isCansSelected
      };

      try{

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: json.encode(jsonData),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = json.decode(response.body);
          final solicitorId = responseData['solicitor'];
          final firstNameOfC = responseData['centerName'].split(' ').first;

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => ImageApplicationScreen(userId: solicitorId, firstNameOfCenter: firstNameOfC,)),
                (Route<dynamic> route) => false,
          );

        }

      }catch (e){
        print(e);
      }

    }

  }

  Widget _buildProductTypeButton(String label, IconData icon, bool isSelected) {
    return GestureDetector(
      onTap: () => _toggleProductSelection(label),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
            isSelected ? const Color(0xFFEF3030) : const Color(0xFFEF3030).withOpacity(0.25),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : const Color(0xFF747783),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[800]),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Petición Centro de Acopio',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Solicitud de Centro de Acopio',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Ingresa el nombre de tu Centro de Acopio',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _centerNameController,
                  decoration: InputDecoration(
                    hintText: 'Nombre del centro',
                    filled: true,
                    fillColor: const Color(0xFFF7F8FA),
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '¿Dónde se encuentra tu Centro de Acopio?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'Dirección del centro',
                    filled: true,
                    fillColor: const Color(0xFFF7F8FA),
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  '¿Qué tipo de productos podrás almacenar dentro del Centro?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildProductTypeButton('Carne', Icons.restaurant_menu, _isCarneSelected),
                    _buildProductTypeButton('Verduras', Icons.eco, _isVegetablesSelected),
                    _buildProductTypeButton('Enlatados', FontAwesomeIcons.bucket, _isCansSelected),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '¿Cuál es la capacidad (Kg) que tendrá el Centro?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _capacityKgController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Escriba un estimado',
                    filled: true,
                    fillColor: const Color(0xFFF7F8FA),
                    hintStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      //WIP
                        RegExp(r'^\d*\.\d*$')),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _sendApplication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF3030),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'CONTINUAR',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}