import 'package:flutter/material.dart';
import './screens/login_screen.dart';
import './screens/home_screen_user.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/homeUser': (context) => HomeScreenUser(),
      },
    );
  }
}
