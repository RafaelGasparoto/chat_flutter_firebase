import 'package:chat_flutter_firebase/models/chat.dart';
import 'package:chat_flutter_firebase/models/message.dart';
import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile(this.chat, {super.key});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    GetIt getIt = GetIt.instance;
    final DatabaseService databaseService = getIt.get<DatabaseService>();
    return StreamBuilder(
      stream: databaseService.getLastMessage(chat.id!),
      builder: (_, snapshot) {
        Message? message = snapshot.data;
        return FutureBuilder(
          future: (chat.isGroup ?? false) ? null : databaseService.getUser(chat.participants!.firstWhere((uid) => uid != getIt.get<AuthService>().user!.uid)),
          builder: (_, snapshot) {
            if (snapshot.hasError) return const Text('Erro ao buscar usuário');
            chat.name ??= snapshot.data?.name;
            return _chatTile(message, getIt);
          },
        );
      },
    );
  }

  ListTile _chatTile(Message? message, GetIt getIt) {
    return ListTile(
      onTap: () async => await onTapChat(getIt),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(chat.name ?? '', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
    final NavigationService navigationService = getIt.get<NavigationService>();
    navigationService.pushNamed('/chat', arguments: {'chatId': chat.id});
  }
}
