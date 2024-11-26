import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class StatusCenter extends StatefulWidget {
  final int centerId;

  const StatusCenter({ required this.centerId, super.key});

  @override
  _StatusCenterState createState() => _StatusCenterState();
}


class _StatusCenterState extends State<StatusCenter>{
  late Map<String, dynamic> centerInfo = {};
  String errormessage = '';
  double result = 0.0;
  late var firstNameOfC;
  Uint8List? _imageFile;


  @override
  void initState(){
    super.initState();
    getCenterInfo();
    calculateCapacity();
  }

  String removeDiacritics(String str) {
    var withDiacritics = 'áéíóúÁÉÍÓÚ';
    var withoutDiacritics = 'aeiouAEIOU';

    String result = '';

    for (int i = 0; i < str.length; i++) {
      int index = withDiacritics.indexOf(str[i]);
      if (index != -1) {
        result += withoutDiacritics[index];
      } else {
        result += str[i];
      }
    }

    return result;
  }

 Future<void> getCenterInfo() async {
   final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/centers/centerinfo');

   Map<String, dynamic> jsonData = {
     'centerId': widget.centerId
   };
   try {

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(jsonData),
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        centerInfo = responseData;
        firstNameOfC = removeDiacritics(responseData['centerName'].split(' ').first);
      });
      calculateCapacity();

      final supabase =
      SupabaseClient(dotenv.env['SUPABASE_URL']!, dotenv.env['SUPABASE_ANON_KEY']!);
      final storageResponse = await supabase
          .storage
          .from('imagesOfCenters')
          .download('center${centerInfo['centerAdmin']}${firstNameOfC}.jpg');

      setState(() {
        _imageFile = storageResponse;
      });

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


void calculateCapacity() {
  setState(() {
    result = (100 * (centerInfo['currentCapacity'] ?? 0)) /
             ((centerInfo['totalCapacity'] ?? 1).toDouble());
    });
}

List<Widget> getAcceptedItems() {
  List<Widget> items = [];

  if(centerInfo['acceptsMeat'] == true){
    items.add(Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color:  Color(0xFFEF3030),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
        child: const Icon(FontAwesomeIcons.drumstickBite, color: Colors.white, size: 25),
        ),
        const Text('Carne', style: TextStyle(fontSize: 16),),
      ],
    ));
  }

  if(centerInfo['acceptsVegetables'] == true){
    items.add(Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFEF3030),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
       child: const Icon(FontAwesomeIcons.carrot, color: Colors.white, size: 25),
        ),
        const Text('Vegetales',style: TextStyle(fontSize: 16))
      ],
    ));
  }

  if(centerInfo['acceptsCans'] == true){
    items.add(Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color:  Color(0xFFEF3030),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
        child: const Icon(FontAwesomeIcons.solidTrashCan, color: Colors.white, size: 25),
        ),
        const Text('Latas', style: TextStyle(fontSize: 16))
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
      title: const Text('Información de tu centro de acopio', style: TextStyle(color: Colors.black, fontSize: 20)),
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
    ),
    body: Padding(
      padding: const EdgeInsets.all(30),
      child: Center(
        child: Column(
          children: [
            if (_imageFile != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.memory(
                  _imageFile!,
                  width: 250,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  strokeWidth: 4.0,
                ),
              ),
            const SizedBox(height: 20),
            Text(
            '${centerInfo['centerName'] ?? 'No disponible'}',
             style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
             
             const SizedBox(height: 20),

             Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color:const  Color(0xFFF6F8FA),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child:  Center(
                child: Padding(padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.archive, color: Color(0xFF369BFF)),
                        SizedBox(width: 10),
                        Text('Almacenacimiento', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      ]
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${result.round()} % lleno', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 20),
                        Text('${centerInfo?['currentCapacity'] ?? -1} / ${centerInfo?['totalCapacity'] ?? -1} Kg', style: const TextStyle(fontSize: 22)),


                    ],),

                    const SizedBox(height: 15),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, color: Color(0xFF413DFB)),
                        SizedBox(width: 10),
                        Text('Dirección', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text('${centerInfo?['centerAddress'] ?? 'No disponible'}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22)),

                    const SizedBox(height: 20),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.restaurant, color: Color(0xFFEF3030)),
                        Text('Comida aceptada', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        SizedBox(width: 10),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: getAcceptedItems(),
                    ),
                  ],
                ),
              )
              )
             ),
          ]
        )
      )
      ),
);
  }
}