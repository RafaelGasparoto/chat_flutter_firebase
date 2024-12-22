import 'package:chat_flutter_firebase/models/user.dart';
import 'package:chat_flutter_firebase/pages/chat/chat_page.dart';
import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile(this._user, {super.key});

  final User _user;

  @override
  Widget build(BuildContext context) {
    GetIt getIt = GetIt.instance;
    final NavigationService navigationService = getIt.get<NavigationService>();
    final DatabaseService databaseService = getIt.get<DatabaseService>();
    final AuthService authService = getIt.get<AuthService>();

    return ListTile(
      onTap: () async {
        if (!await databaseService.checkChatExists(authService.user!.uid, _user.uid!)) {
          databaseService.createChat(currentUserUid: authService.user!.uid, otherUserUid: _user.uid!);
        }
        navigationService.pushRoute(
          MaterialPageRoute(
            builder: (context) {
              return ChatPage(otherUser: _user);
            },
          ),
        );
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(_user.name!),
      leading: const CircleAvatar(
        backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
      ),
    );
  }
}
