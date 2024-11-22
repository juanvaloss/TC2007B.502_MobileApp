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
  bool _isMeatPressed = false;
  bool _isVeggiePressed = false;
  bool _isCanPressed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
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
                      FilteringTextInputFormatter.allow(RegExp('[0-9_. ]')),
                    ],
                  ),
                ],
              ),
              //const SizedBox(height: 400),
              Column(
                children: [
                  const Text(
                    '¿Cuáles fueron los tipos de alimentos que se donaron?',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: _isMeatPressed
                                  ? const Color(0xFFEF3030)
                                  : const Color(0xFFEF3030).withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.drumstickBite,
                                color: _isMeatPressed
                                    ? Colors.white
                                    : const Color(0xFF747783),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isMeatPressed = !_isMeatPressed;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Carne'),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: _isVeggiePressed
                                  ? const Color(0xFFEF3030)
                                  : const Color(0xFFEF3030).withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.carrot,
                                color: _isVeggiePressed
                                    ? Colors.white
                                    : const Color(0xFF747783),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isVeggiePressed = !_isVeggiePressed;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Vegetales'),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: _isCanPressed
                                  ? const Color(0xFFEF3030)
                                  : const Color(0xFFEF3030).withOpacity(0.25),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                FontAwesomeIcons.bucket,
                                color: _isCanPressed
                                    ? Colors.white
                                    : const Color(0xFF747783),
                              ),
                              onPressed: () {
                                setState(() {
                                  _isCanPressed = !_isCanPressed;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Enlatados'),
                        ],
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
              //const SizedBox(height: 200),
              SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF3030),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'REGISTRAR DONACIÓN',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
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
                    builder: (context) => UserProfileScreen(userId: widget.userId, isBamxAdmin: false),
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
