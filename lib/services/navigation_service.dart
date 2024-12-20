import 'package:chat_flutter_firebase/pages/home/home_page.dart';
import 'package:chat_flutter_firebase/pages/login/login_page.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  final Map<String, WidgetBuilder> routes = {
    '/login': (_) => const LoginPage(),
    '/home': (_) => const HomePage(),
  };

  void navigateToNamed(String routeName) => _navigatorKey.currentState!.pushNamed(routeName);

  void replaceToNamed(String routeName) => _navigatorKey.currentState!.pushReplacementNamed(routeName);

  void goBack() => _navigatorKey.currentState!.pop();
}
