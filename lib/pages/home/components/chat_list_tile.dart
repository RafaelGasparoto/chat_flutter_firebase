import 'package:chat_flutter_firebase/models/message.dart';
import 'package:chat_flutter_firebase/models/user.dart';
import 'package:chat_flutter_firebase/pages/chat/chat_page.dart';
import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile(this._user, {super.key});

  final User _user;

  @override
  Widget build(BuildContext context) {
    GetIt getIt = GetIt.instance;
    final DatabaseService databaseService = getIt.get<DatabaseService>();
    return StreamBuilder(
      stream: databaseService.getLastMessage(_user.uid!),
      builder: (_, snapshot) {
        Message? message = snapshot.data;
        return _chatTile(message, getIt);
      },
    );
  }

  ListTile _chatTile(Message? message, GetIt getIt) {
    return ListTile(
      onTap: () async => await onTapChat(getIt),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(_user.name!, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      subtitle: Text(
        message?.content ?? '',
        style: const TextStyle(color: Colors.black54, overflow: TextOverflow.ellipsis),
      ),
      trailing: Visibility(
        visible: message?.sentAt != null,
        child: Text(DateFormat('dd/MM/yyyy HH:mm').format(message?.sentAt?.toDate() ?? DateTime.now()), style: const TextStyle(color: Colors.black54)),
      ),
      leading: const CircleAvatar(
        backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
      ),
    );
  }

  Future<void> onTapChat(GetIt getIt) async {
    final AuthService authService = getIt.get<AuthService>();
    final NavigationService navigationService = getIt.get<NavigationService>();
    final DatabaseService databaseService = getIt.get<DatabaseService>();

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
  }
}
