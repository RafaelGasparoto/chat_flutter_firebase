import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/media_service.dart';
import 'package:chat_flutter_firebase/services/snackbar_service.dart';
import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:get_it/get_it.dart';

Future<void> registerServices() async {
  final GetIt getIt = GetIt.instance;
  
  getIt.registerSingleton<NavigationService>(NavigationService());
  getIt.registerSingleton<SnackbarService>(SnackbarService());
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<MediaService>(MediaService());
  getIt.registerSingleton<DatabaseService>(DatabaseService());
}
