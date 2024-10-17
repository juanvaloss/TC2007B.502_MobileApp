import 'package:flutter/material.dart';
import '../access_screens/login_screen.dart';

class GuestContract extends StatefulWidget {
  const GuestContract({super.key});

  @override
  _GuestContractState createState() => _GuestContractState();
}

class _GuestContractState extends State<GuestContract> {
  bool isChecked = false; // Estado inicial del Checkbox

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/bamx-logo.png',
              width: 200,
              height: 200,
            ),
            Center(
              child: Text(
                "Acepta nuestras políticas de privacidad",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF32343E),
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                const SizedBox(width: 10),
                const Text.rich(
                  TextSpan(
                    text: "He leído y acepto la ",
                    children: <TextSpan>[
                      TextSpan(
                        text: "\npolítica de privacidad",
                        style: TextStyle(color: Color(0xFFEF3030)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isChecked
                  ? () {
                // Acción cuando el botón es presionado (solo si el checkbox está marcado)
              }
                  : null, // Deshabilitado si el checkbox no está marcado
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF3030),
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text('Aceptar'),
            ),
          ],
        ),
      ),
    );
  }
}
