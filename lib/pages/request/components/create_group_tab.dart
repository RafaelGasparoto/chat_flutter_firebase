import 'package:chat_flutter_firebase/models/user.dart';
import 'package:chat_flutter_firebase/pages/request/components/friend_checkbox.dart';
import 'package:chat_flutter_firebase/pages/request/components/label_divider.dart';
import 'package:chat_flutter_firebase/pages/request/components/selected_friend.dart';
import 'package:chat_flutter_firebase/pages/request/group_create.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:chat_flutter_firebase/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

class CreateGroupTab extends StatefulWidget {
  const CreateGroupTab({super.key});

  @override
  State<CreateGroupTab> createState() => _CreateGroupTabState();
}

class _CreateGroupTabState extends State<CreateGroupTab> {
  final GetIt getIt = GetIt.instance;
  late final DatabaseService _databaseService;
  late final NavigationService _navigationService;
  RxList<User> selectedFriends = <User>[].obs;
  List<User> friends = [];

  @override
  void initState() {
    _databaseService = getIt.get<DatabaseService>();
    _navigationService = getIt.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _selectedFriends(),
        _createGroup(context),
        const LabelDivider('Lista de Amigos'),
        _friendList(),
      ],
    );
  }

  Widget _selectedFriends() {
    return Container(
      height: 80,
      alignment: Alignment.centerLeft,
      child: Obx(
        () => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: selectedFriends.length,
          itemBuilder: (_, index) {
            return SelectedFriend(
              selectedFriends[index],
              onRemove: () => {
                selectedFriends.removeAt(index),
              },
            );
          },
        ),
      ),
    );
  }

  Widget _friendList() {
    return Expanded(
      child: StreamBuilder(
        stream: _databaseService.getStreamFriends(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Text('Erro ao buscar usuários');
          }

          if (snapshot.hasData) {
            friends = snapshot.data ?? [];
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                User user = friends[index];
                return Obx(
                  () => FriendCheckbox(
                    friend: user,
                    onSelected: (userSelected) => _onFriendSelected(userSelected),
                    isSelected: selectedFriends.any((friend) => friend.uid == user.uid),
                  ),
                );
              },
              itemCount: snapshot.data?.length ?? 0,
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _createGroup(BuildContext context) {
    return Obx(() =>
      AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        width: selectedFriends.isNotEmpty ? context.width : 0,
        child: CustomButton(
          label: 'Criar Grupo',
          onPressed: () {
            _navigationService.pushRoute(
              MaterialPageRoute(
                builder: (context) {
                  return GroupCreate(friends);
                },
            ));
          },
        ),
      ),
    );
  }

  void _onFriendSelected(User userSelected) {
    int index = selectedFriends.indexWhere((friend) => friend.uid == userSelected.uid);
    if (index == -1) {
      selectedFriends.add(userSelected);
    } else {
      selectedFriends.removeAt(index);
    }
  }
}
