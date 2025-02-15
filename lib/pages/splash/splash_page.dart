import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/current_user_service.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 3), () async {
        final GetIt getIt = GetIt.instance;

        if (getIt.get<AuthService>().user == null) {
          getIt.get<NavigationService>().replaceToNamed('/login');
          return;
        }

        getIt.get<DatabaseService>().getUser(getIt.get<AuthService>().user!.uid).then((user) {
          getIt.get<CurrentUserService>().user = user;
          getIt.get<NavigationService>().replaceToNamed('/home');
        });
      });
    });

    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage('assets/icon/chat-icon.png'),
          height: 200,
        ),
      ),
    );
  }
}
