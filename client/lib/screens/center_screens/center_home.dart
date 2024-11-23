import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CenterHome extends StatefulWidget {
  final int userId;

  const CenterHome({required this.userId, super.key});

  @override
  _CenterHome createState() => _CenterHome();
}

class _CenterHome extends State<CenterHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEF3030),
      ),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "Buenas Tardes, Usuario ${widget.userId}!",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Image.asset(
                  'images/bamx-logo.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),

          // Nombre del centro
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 3,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Text(
                  "WALMART",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          // Lista de botones
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                OptionCard(
                  icon: FontAwesomeIcons.donate,
                  text: "Agregar donación al inventario",
                  onTap: () {
                    // Acción para este botón
                    print("Agregar donación");
                  },
                ),
                OptionCard(
                  icon: FontAwesomeIcons.clipboardCheck,
                  text: "Ver status del Centro",
                  onTap: () {
                    // Acción para este botón
                    print("Ver status");
                  },
                ),
                OptionCard(
                  icon: FontAwesomeIcons.truck,
                  text: "Solicitar envío",
                  onTap: () {
                    // Acción para este botón
                    print("Solicitar envío");
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      // BottomAppBar en lugar del BottomNavigationBar
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
                // Acción para ir a la pantalla de inicio
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline_rounded, color: Colors.black),
              onPressed: () {
                // Acción para ir al perfil
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none_outlined, color: Colors.black),
              onPressed: () {
                // Acción para notificaciones
              },
            ),
          ],
        ),
      ),
    );
  }
}

class OptionCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const OptionCard({
    required this.icon,
    required this.text,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: const Color(0xFFEF3030),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

