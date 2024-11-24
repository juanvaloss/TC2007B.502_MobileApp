import 'package:flutter/material.dart';
import '../access_screens/privacyNoticeScreen.dart';
import '../user_screens/user_home_screen.dart';

class GuestContract extends StatefulWidget {
  const GuestContract({super.key});

  @override
  _GuestContractState createState() => _GuestContractState();
}

class _GuestContractState extends State<GuestContract> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/bamx-logo.png',
              width: 200,
              height: 200,
            ),
            const Center(
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
                RichText(
                  text: TextSpan(
                    text: "He leído y acepto la ",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PrivacyNoticeScreen()));
                          },
                          child: const Text(
                            "política de privacidad",
                            style: TextStyle(
                              color: Color(0xFFEF3030),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
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
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserHomeScreen(userId: 0, isCenterAdmin: false, isBamxAdmin: false,)),
                          (Route<dynamic> route) => false,
                    );
              }
                  : null,
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
