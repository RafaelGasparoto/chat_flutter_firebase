import 'package:chat_flutter_firebase/utils/firebase_setup.dart';
import 'package:chat_flutter_firebase/pages/login/login_page.dart';
import 'package:chat_flutter_firebase/utils/register_services.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  await setup();
  runApp(const MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}