import 'package:chat_flutter_firebase/pages/request/group_create.dart';
import 'package:chat_flutter_firebase/pages/request/request_page.dart';
import 'package:chat_flutter_firebase/pages/home/home_page.dart';
import 'package:chat_flutter_firebase/pages/login/login_page.dart';
import 'package:chat_flutter_firebase/pages/register/register_page.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  final Map<String, WidgetBuilder> routes = {
    '/login': (_) => const LoginPage(),
    '/home': (_) => const HomePage(),
    '/register': (_) => const RegisterPage(),
    '/request': (_) => const RequestPage(),
    '/group-create': (_) => const GroupCreate(),
  };

  void pushRoute(MaterialPageRoute route) {
    _navigatorKey.currentState!.push(route);
  }

  void pushNamed(String routeName) => _navigatorKey.currentState!.pushNamed(routeName);

  void replaceToNamed(String routeName) => _navigatorKey.currentState!.pushReplacementNamed(routeName);

  void goBack() => _navigatorKey.currentState!.pop();
}
