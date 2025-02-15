import 'package:chat_flutter_firebase/pages/chat/chat_page.dart';
import 'package:chat_flutter_firebase/pages/profile/profile_page.dart';
import 'package:chat_flutter_firebase/pages/request/request_page.dart';
import 'package:chat_flutter_firebase/pages/home/home_page.dart';
import 'package:chat_flutter_firebase/pages/login/login_page.dart';
import 'package:chat_flutter_firebase/pages/register/register_page.dart';
import 'package:chat_flutter_firebase/pages/splash/splash_page.dart';
import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  final Map<String, WidgetBuilder> routes = {
    '/login': (_) => const LoginPage(),
    '/home': (_) => const HomePage(),
    '/register': (_) => const RegisterPage(),
    '/request': (_) => const RequestPage(),
    '/chat': (_) => const ChatPage(),
    '/profile': (_) => const ProfilePage(),
    '/splashPage': (_) => const SplashPage(),
  };

  void pushRoute(MaterialPageRoute route) {
    _navigatorKey.currentState!.push(route);
  }

  Future<dynamic> pushNamed(String routeName, {Object? arguments}) async => await _navigatorKey.currentState!.pushNamed(routeName, arguments: arguments).then((result) => result);

  void replaceToNamed(String routeName) => _navigatorKey.currentState!.pushReplacementNamed(routeName);

  void removeUntilNamed(String routeName) => _navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName, (route) => false);

  void goBack() => _navigatorKey.currentState!.pop();
}
