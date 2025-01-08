import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:chat_flutter_firebase/utils/firebase_setup.dart';
import 'package:chat_flutter_firebase/utils/register_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

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
    final NavigationService navigationService = GetIt.instance.get<NavigationService>();
    final AuthService authService = GetIt.instance.get<AuthService>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigationService.navigatorKey,
      routes: navigationService.routes,
      initialRoute: authService.user != null ? '/home' : '/login',
      title: 'Chat Flutter Firebase',
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
          secondary: const Color(0XFF2C2F33),
        ),
        useMaterial3: false,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0XFF2C2F33),
          foregroundColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0XFF2C2F33), 
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0XFF99AAB5),
          thickness: 0.5
        )
      ),
    );
  }
}
