import 'package:flutter/material.dart';
import './screens/access_screens/starting_page.dart';
import './screens/home_screen_user.dart';
import 'screens/user_screens/user_main_screen.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const StartingPage(),
        '/homeUser': (context) => HomeScreenUser(),
        '/map': (context) => MapScreen(),  // Add the map screen to routes
      },
    );
  }
}