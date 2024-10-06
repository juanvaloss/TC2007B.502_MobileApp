import 'package:flutter/material.dart';

class HomeScreenUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Second Screen')),
      body: Center(
        child: Text('Welcome to the Second Screen'),
      ),
    );
  }
}
