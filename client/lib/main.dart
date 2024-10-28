import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/user_screens/user_home_screen.dart';
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
        //'/': (context) => const StartingPage(),
        '/': (context) => UserHomeScreen(userId: 0),
        //'/homeUser': (context) => UserHomeScreen(),
        '/map': (context) => MapScreen(),  // Add the map screen to routes
      },
    );
  }
}