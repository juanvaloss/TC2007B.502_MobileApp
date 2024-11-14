import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CheckApplication extends StatefulWidget {
  final int userId;

  const CheckApplication({required this.userId, super.key});

  @override
  _CheckApplicationState createState() => _CheckApplicationState();
}

class _CheckApplicationState extends State<CheckApplication> {
  Map<String, dynamic>? applicationInfo;
  String errormessage = '';


  @override
  void initState() {
    super.initState();
    checkApplicationInfo();
  }

  String status = "Pendiente";

  Future<void> checkApplicationInfo() async {
    try {
      final url = Uri.parse('http:/');
    }
    catch (e){

      print('Error; $e');

    }
  }

  List<Widget> getCompletedCourses(){
    List<Widget> items = [];

    items.add(
      const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.check, color: Colors.green,)
      ],)
    
    );



    return items;
    }

    Text getText(){
      if(status == "Aprobado"){
        return const Text(
          "Aprobada",
          style:TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20
          ));
      }
      else if(status == "Pendiente"){
        return const Text(
          "Pendiente",
          style:TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20
          ));
      }
      else{
        return const Text(
          "Rechazada",
          style:TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20
          ));
      }
    }

    Color getStatusColor(){
      if(status == "Aprobado"){
        return const Color(0xFF70DA67);
      }
      else if(status == "Pendiente"){
        return const Color(0xFFFF9500);
      }
      else{
        return const Color(0xFFEF3030);
      }
    }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
    appBar: AppBar(
      title: const Text('Estatus de la solicitud'),
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
    ),
      body:  Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Column(children: [
              const SizedBox(height: 100),

              const Text(
                'Capacitaciones para tu centro de acopio',
                style: TextStyle( 
                  fontSize: 20,
                  fontWeight: FontWeight.bold,

                )),

              const SizedBox(height: 20),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: getCompletedCourses(),
                ),

              const Text("Estatus de tu solicitud: "),

              const SizedBox(height: 15),

              Container(
                width: 400,
                height: 50,
                decoration: BoxDecoration(
                  color: getStatusColor(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(child: getText(),)
              )


            ],)
          )
        ],
      )
    );
  }
}