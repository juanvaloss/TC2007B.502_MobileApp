import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_application_1/screens/user_screens/application_screen.dart';
import './screens/access_screens/starting_page.dart';
import './screens/center_screens/status_center.dart';
import './screens/user_screens/more_info_center.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        //'/': (context) => const StatusCenter(userId: 8, centerId: 3)

      },
    );
  }
}
