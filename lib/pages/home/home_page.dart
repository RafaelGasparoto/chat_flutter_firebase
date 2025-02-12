import 'package:chat_flutter_firebase/models/user.dart';
import 'package:chat_flutter_firebase/pages/home/components/chat_list_tile.dart';
import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/current_user_service.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:chat_flutter_firebase/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GetIt getIt = GetIt.instance;
  late final AuthService _authService;
  late final NavigationService _navigationService;
  late final DatabaseService _databaseService;
  late final NotificationService _notificationService;

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    _notificationService = GetIt.instance.get<NotificationService>();
    _notificationService.setFmcToken();
    super.initState();
  }

  Future<void> _getCurrentUser() async => await _databaseService.getUser(_authService.user!.uid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
      floatingActionButton: _floatingActionButton(),
    );
  }

  FloatingActionButton _floatingActionButton() {
    return FloatingActionButton(
      child: const Icon(Icons.add),
      onPressed: () {
        _navigationService.pushNamed('/request');
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: FutureBuilder(
          future: _getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Text('Erro ao buscar usuário');
            }

            final currentUser = snapshot.data as User;

            return GestureDetector(
              onTap: () => _navigationService.pushNamed('/profile', arguments: currentUser),
              child: Row(
                children: [
                  currentUser.profilePicture == null
                      ? CircleAvatar(
                          backgroundImage: const AssetImage('assets/user.png'),
                          backgroundColor: Colors.grey.shade300,
                        )
                      : CircleAvatar(backgroundImage: NetworkImage(currentUser.profilePicture!)),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(currentUser.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          }),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            bool result = await _authService.logout();
            if (result) {
              _navigationService.replaceToNamed('/login');
            }
          },
        ),
      ],
    );
  }

  Widget _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            _listChats(),
          ],
        ),
      ),
    );
  }

  Widget _listChats() {
    return StreamBuilder(
      stream: _databaseService.getStreamAvaliableChats(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Erro ao buscar usuários');
        }

        if (snapshot.hasData && snapshot.data != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return const Divider();
              },
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ChatListTile(snapshot.data![index]);
              },
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
