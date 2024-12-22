import 'package:chat_flutter_firebase/models/user.dart';
import 'package:flutter/material.dart';

class ChatListTile extends StatelessWidget {
  const ChatListTile(this._user, {super.key});

  final User _user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(_user.name!),
      leading: const CircleAvatar(
        backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
      ),
    );
  }
}
