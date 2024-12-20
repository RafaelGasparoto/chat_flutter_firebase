import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

Future<void> registerServices() async {
  final GetIt _getIt = GetIt.instance;

  _getIt.registerSingleton<AuthService>(AuthService());
  _getIt.registerSingleton<NavigationService>(NavigationService());
  
}
