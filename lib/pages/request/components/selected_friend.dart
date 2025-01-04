import 'package:chat_flutter_firebase/models/user.dart';
import 'package:flutter/material.dart';

class SelectedFriend extends StatefulWidget {
  const SelectedFriend(this.friend, {required this.onRemove, super.key});

  final void Function() onRemove;
  final User friend;

  @override
  State<SelectedFriend> createState() => _SelectedFriendState();
}

class _SelectedFriendState extends State<SelectedFriend> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onRemove();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Stack(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    child: Container(
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(151, 244, 67, 54)),
                      child: const Icon(Icons.close, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            Text(widget.friend.name!, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
