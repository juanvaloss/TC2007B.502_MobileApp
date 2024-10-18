import 'package:flutter/material.dart';

class UserHomeScreen extends StatelessWidget{
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text(
        "Felicidades pequeña, lo lograste",
        style: TextStyle(
          fontSize: 30,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        )
        )
    );
  }
}