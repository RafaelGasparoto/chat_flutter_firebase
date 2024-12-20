import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:chat_flutter_firebase/utils/firebase_setup.dart';
import 'package:chat_flutter_firebase/utils/register_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Future<void> main() async {
  await setup();
  final NavigationService navigationService = GetIt.instance.get<NavigationService>();
  runApp(MyApp(navigationService));
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();
  await registerServices();
}

class MyApp extends StatelessWidget {
  const MyApp(this._navigationService, {super.key});

  final NavigationService _navigationService; 
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: _navigationService.navigatorKey,
      routes: _navigationService.routes,
      initialRoute: '/login',
      title: 'Chat Flutter Firebase',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(),
        useMaterial3: true,
      ),
    );
  }
}