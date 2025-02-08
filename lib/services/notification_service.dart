import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';

class NotificationService {
  final _databaseService = GetIt.instance.get<DatabaseService>();
  final _navigationService = GetIt.instance.get<NavigationService>();

  Future<void> setFmcToken() async {
    final firebaseMessaging = FirebaseMessaging.instance;

    firebaseMessaging.requestPermission();

    String? token = await firebaseMessaging.getToken();

    _databaseService.setFcmToken(token!);
  }

  Future<void> onMessage() async {
    final firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.getInitialMessage().then((message) {
      if(message != null) {
      _handleMessage(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(message);
    });
  }

  void _handleMessage(RemoteMessage? message) {
    _navigationService.removeUntilNamed('/home');
    _navigationService.pushNamed('/chat', arguments: {'chatId': message!.data['chatId']});
  }
}
