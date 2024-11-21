import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../user_screens/user_profile.dart';

class AddDonation extends StatefulWidget {
  final int userId;
  final int centerId;

  const AddDonation({required this.userId, required this.centerId, super.key});

  @override
  _AddDonation createState() => _AddDonation();
}

class _AddDonation extends State<AddDonation> {
  final TextEditingController _donationController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Agregar donación a tu inventario',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¿Cuál fue la cantidad (En kilogramos) que fue donada?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _donationController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Escribe aquí la cantidad de la donación',
                  hintStyle: const TextStyle(
                    color: Color(0xFFA0A5BA),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF0F5FA),
                  isDense: true,
                ),
                style: const TextStyle(
                  color: Color(0xFFA0A5BA),
                ),
                textAlign: TextAlign.center,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9_. ]'))
                ],
              ),

              const SizedBox(height: 100),

              const Text(
                '¿Cuáles fueron los tipos de alimentos que se donaron?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(FontAwesomeIcons.drumstickBite, color: Color(0xFF747783)),
                        onPressed: () {
                          // Action for apple
                        },
                      ),
                      const Text('Manzanas')
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
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
                  MaterialPageRoute(
                    builder: (context) => UserProfileScreen(userId: widget.userId),
                  ),
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
    );
  }
}
