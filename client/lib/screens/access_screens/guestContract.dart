import 'package:flutter/material.dart';
import '../access_screens/login_screen.dart';

class GuestContract extends StatelessWidget{

  const GuestContract({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    //double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/bamx-logo.png',
                  width: 200,
                  height: 200,),

                ElevatedButton(
                    onPressed: (){
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor:  const Color(0xFFEF3030),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(200, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                    child: const Text('Aceptar')
                ), //iniciar sesion
              ]
          )
      ),

    );
  } // Widget
} // class