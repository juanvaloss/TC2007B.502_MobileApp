import 'package:flutter/material.dart';

class HomeScreenUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  return const MaterialApp(
  home: ScaffoldExample(),
  );
  }
  }

  class ScaffoldExample extends StatefulWidget {
  const ScaffoldExample({super.key});

  @override
  State<ScaffoldExample> createState() => _ScaffoldExampleState();
  }

  class _ScaffoldExampleState extends State<ScaffoldExample> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
  return Scaffold(
  appBar: AppBar(
  title: const Text('Sample Code'),
  ),
  body: Center(
  child: Text('You have pressed the button $_count times.'),
  ),
  bottomNavigationBar: BottomAppBar(
  shape: const CircularNotchedRectangle(),
  child: Container(height: 50.0),
  ),
  floatingActionButton: FloatingActionButton(
  onPressed: () => setState(() {
  _count++;
  }),
  tooltip: 'Increment Counter',
  child: const Icon(Icons.add),
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
  );
  }

}
