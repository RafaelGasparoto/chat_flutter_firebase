import 'package:chat_flutter_firebase/pages/request/components/create_group_tab.dart';
import 'package:chat_flutter_firebase/pages/request/components/friend_request_tab.dart';
import 'package:flutter/material.dart';

class RequestPage extends StatelessWidget {
  const RequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person_add)),
              Tab(icon: Icon(Icons.group_add)),
            ],
          ),
        ),
        body: _body(),
      ),
    );
  }

  Widget _body() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: TabBarView(
        children: [
          FriendRequestTab(),
          CreateGroupTab(),
        ],
      ),
    );
  }
}
