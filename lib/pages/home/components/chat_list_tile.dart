import 'package:chat_flutter_firebase/models/user.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ChatListTile extends StatelessWidget {
  ChatListTile(this._user, {super.key});
  
  final NavigationService _navigationService = GetIt.instance.get<NavigationService>();
  final User _user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        _navigationService.navigateToNamed('/chat');
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(_user.name!),
      leading: const CircleAvatar(
        backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
      ),
    );
  }
}
