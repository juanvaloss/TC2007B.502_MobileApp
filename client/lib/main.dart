import 'package:flutter/material.dart';
import './screens/access_screens/starting_page.dart';
import 'screens/user_screens/user_main_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import './screens/user_screens/image_application_screen.dart';


Future<void> main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KANAAAAAAAAAAN!!!!',
      initialRoute: '/',
      routes: {
        '/': (context) => const StartingPage(),
        //'/': (context) => const CheckApplication(userId: 0),
        //'/': (context) => const ApplicationScreen(applicationId: 10),
      },
    );
  }
}
