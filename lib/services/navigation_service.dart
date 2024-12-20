import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  final Map<String, Widget> routes = {
    '/login': const Text('Login'),
  };

  void navigateToNamed(String routeName) => _navigatorKey.currentState!.pushNamed(routeName);

  void replaceToNamed(String routeName) => _navigatorKey.currentState!.pushReplacementNamed(routeName);

  void goBack() => _navigatorKey.currentState!.pop();
}
