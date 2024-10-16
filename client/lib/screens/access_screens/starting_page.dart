import 'package:flutter/material.dart';
import '../access_screens/login_screen.dart';
import '../access_screens/register_screen.dart';
import '../access_screens/guestContract.dart';

class StartingPage extends StatelessWidget{

  const StartingPage({super.key});

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
            Container(
              alignment: Alignment.center,
              width: screenWidth * 0.8,
              child: const Text(
                "Bienvenido a Kanan",
                style: TextStyle(fontSize: 24, 
                fontWeight: FontWeight.bold
                ),
              ),
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  LoginScreen()));

              },
              style: ElevatedButton.styleFrom(
                backgroundColor:  const Color(0xFFEF3030),
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                )
              ),
              child: const Text('Ingresa')
            ), //iniciar sesion
             ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()));

              },
              style: ElevatedButton.styleFrom(
                backgroundColor:  const Color(0xFFB4B7C3),
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                )
              ),
              child: const Text('Registrarte')
            ), //Registrarse
             OutlinedButton(
              onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GuestContract()));
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF3030),
                side: const BorderSide (color: Color(0xFFEF3030), width: 2),
                minimumSize: const Size(200, 40),
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                )
              ),
              child: const Text('Usuario Invitado')
            ), //Entrar como invitado
          ]
        )
      ),
      
    );
  } // Widget
} // class