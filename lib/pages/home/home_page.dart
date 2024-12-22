import 'package:chat_flutter_firebase/pages/home/components/chat_list_tile.dart';
import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
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

  @override
  void initState() {
    _authService = GetIt.instance.get<AuthService>();
    _navigationService = GetIt.instance.get<NavigationService>();
    _databaseService = GetIt.instance.get<DatabaseService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Scaffold(
        body: _body(),
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
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
      stream: _databaseService.getStreamUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Erro ao buscar usuários');
        }

        if (snapshot.hasData && snapshot.data != null) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              return ChatListTile(snapshot.data!.docs[index].data());
            },
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
