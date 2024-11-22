import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../user_screens/user_profile.dart';


class StatusCenter extends StatefulWidget {
  final int userId;
  final int centerId;

  const StatusCenter({required this.userId, required this.centerId, super.key});


  @override
  _StatusCenterState createState() => _StatusCenterState();
}


class _StatusCenterState extends State<StatusCenter>{
  Map<String, dynamic>? centerInfo;
  String errormessage = '';
  double result = 0.0;  

  @override
  void initState(){
    super.initState();
    getcenterinfo();
    calculateCapacity();
  }

 Future<void> getcenterinfo() async {
  try {
    final url = Uri.parse('http://${dotenv.env['LOCAL_IP']}:3000/centers/centerinfo');

    Map<String, dynamic> jsonData = {
      'centerId': widget.centerId
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
        calculateCapacity(); 
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


void calculateCapacity() {
  setState(() {
    if (centerInfo != null) {
      result = (100 * (centerInfo?['currentCapacity'] ?? 0)) / 
               ((centerInfo?['totalCapacity'] ?? 1).toDouble());
    } else {
      result = 0.0;
    }
  });
}

List<Widget> getAcceptedItems() {
  List<Widget> items = [];

  if(centerInfo?['acceptsMeat'] == true){
    items.add(Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEF3030).withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
        child: const Icon(FontAwesomeIcons.drumstickBite, color: Color(0xFF747783), size: 25),
        ),
        const Text('Carne', style: TextStyle(fontSize: 16),),
      ],
    ));
  }

  if(centerInfo?['acceptsVegetables'] == true){
    items.add(Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEF3030).withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
       child: const Icon(FontAwesomeIcons.carrot, color: Color(0xFF747783), size: 25),
        ),
        const Text('Vegetales',style: TextStyle(fontSize: 16))
      ],
    ));
  }

  if(centerInfo?['acceptsCans'] == true){
    items.add(Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEF3030).withOpacity(0.25),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(10),
        child: const Icon(FontAwesomeIcons.solidTrashCan, color: Color(0xFF747783), size: 25),
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
            Text(
            '${centerInfo?['centerName'] ?? 'No disponible'}',
             style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
             
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
                        Text('Almacenacimiento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ]
                    ),

                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${result.round()} % lleno', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 20),
                        Text('${centerInfo?['currentCapacity'] ?? -1} / ${centerInfo?['totalCapacity'] ?? -1} Kg', style: const TextStyle(fontSize: 16)),


                    ],),

                    const SizedBox(height: 40),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, color: Color(0xFF413DFB)),
                        SizedBox(width: 10),
                        Text('Dirección', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text('${centerInfo?['centerAddress'] ?? 'No disponible'}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),

                    const SizedBox(height: 40),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(width: 10),
                        Icon(Icons.restaurant, color: Color(0xFFEF3030)),
                        Text('Comida aceptada', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
      //bottom appbar starts
       bottomNavigationBar: BottomAppBar(
    color: Colors.white,
    shape: const CircularNotchedRectangle(), 
    notchMargin: 8.0, 
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround, 
      children: [
        IconButton(
          icon: const Icon(Icons.home_outlined, color: Colors.black),
          onPressed: () {
            // Action for home
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_outline_rounded, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserProfileScreen(userId: widget.userId, isBamxAdmin: false)),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
          onPressed: () {
            // Action for notifications
          },
        ),
        
      ],
    ),
  ),
  //bottom appbar ends
);
  }
}