import 'package:chat_flutter_firebase/models/user.dart';
import 'package:flutter/material.dart';

class FriendCheckbox extends StatelessWidget {
  const FriendCheckbox({super.key, required this.friend, required this.onSelected, required this.isSelected});

  final User friend;
  final Function(User) onSelected;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onSelected(friend);
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Stack(
              children: [
                _avatar(),
                _checkIcon(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Text(friend.name!, style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _avatar() {
    return const Padding(
      padding: EdgeInsets.only(right: 10),
      child: SizedBox(width: 40, height: 40, child: CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/300'))),
    );
  }

  Widget _checkIcon() {
    return Positioned(
      right: 0,
      bottom: 0,
      child: AnimatedOpacity(
        opacity: isSelected ? 1 : 0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        child: Container(
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
          child: const Icon(Icons.check, color: Colors.white, size: 18),
        ),
      ),
    );
  }
}
