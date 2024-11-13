import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MoreInfoCenter extends StatefulWidget {
  final int userId;
  final int centerId;

  const MoreInfoCenter({required this.userId, super.key, required this.centerId});

  @override
  _MoreInfoCenterState createState() => _MoreInfoCenterState();
}

class _MoreInfoCenterState extends State<MoreInfoCenter> {
  Map<String, dynamic>? centerInfo;
  String errormessage = '';

  @override
  void initState() {
    super.initState();
    futureCenterInfo();
    calculateCapacity();
  }
 Future<void> futureCenterInfo() async {
  try {
    final url = Uri.parse('http://10.43.41.205:3000/centers/centerinfo');

    Map<String, dynamic> jsonData = {
      'centerId': widget.centerId.toString()
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jsonData),
    );

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final responseData = json.decode(response.body);
      
      if (responseData is List && responseData.isNotEmpty) {
        setState(() {
          centerInfo = responseData[0]; 
        });
      } else {
        setState(() {
          errormessage = 'No se encontró información del centro.';
        });
      }
    } else {
      setState(() {
        errormessage = 'Error ${response.statusCode}: no se pudo cargar la información del centro.';
      });
    }
  } catch (e) {
    setState(() {
      errormessage = 'Error ${e}: no se pudo cargar la información del centro ayuda.';
    });
  }
}

double result = 0.0;

void calculateCapacity() async {
  setState(() {
    result = (100 * (centerInfo?['currentCapacity'] ?? 0)) / (centerInfo?['maxCapacity'] ?? 1);
  });
}

IconData getIcon() {
  if (result < 30) {
    return Icons.sentiment_dissatisfied; 
  } else if(result >= 30 && result < 70) {
    return Icons.sentiment_neutral; 
  }
  else{
    return Icons.sentiment_satisfied;
  }
}

Color getColor() {
  if (result < 30) {
    return Colors.red; 
  } else if(result >= 30 && result < 70) {
    return Colors.yellow; 
  }
  else{
    return Colors.green;
  }
}

List<Widget> getAcceptedItems() {
  List<Widget> items = [];

  if(centerInfo?['acceptsMeat'] == true){
    items.add(Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFEF3030),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
        child: const Icon(Icons.restaurant, color: Colors.black, size: 30),
        ),
        const Text('Carne'),
      ],
    ));
  }

  if(centerInfo?['acceptsVegetables'] == true){
    items.add(const Column(
      children: [
        Icon(Icons.local_florist, color: Colors.black, size: 30),
        Text('Vegetales')
      ],
    ));
  }

  if(centerInfo?['acceptsCans'] == true){
    items.add(const Column(
      children: [
        Icon(Icons.local_drink, color: Colors.black, size: 30),
        Text('Latas')
      ],
    ));
  }
  return items;
}


 @override 
Widget build(BuildContext context){
  return Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      title: const Text('Información del centro'),
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
    ),
    body: Padding(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,  // Aligns all items in the column to the left
        children: [
          Container(
            width: 400,
            height: 200,
            decoration: BoxDecoration(
              color: const Color(0xFF98A8B8),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          const SizedBox(height: 15),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '${centerInfo?['centerName'] ?? 'No disponible'}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Dirección: ${centerInfo?['centerAddress'] ?? 'No disponible'}',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ),
          if (errormessage.isNotEmpty) 
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  errormessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(getIcon(), color: getColor()),
                const SizedBox(width: 10),
                Text('$result% lleno', style: const TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 50),

            const Text(
              'Acepta: ',
              style: TextStyle(
                fontSize: 20
              )
            ),

            const SizedBox(height: 35),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: getAcceptedItems(),
            )
        ]
      ),
    ),
  );
}

}
