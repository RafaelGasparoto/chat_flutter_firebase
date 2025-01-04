import 'package:chat_flutter_firebase/models/user.dart';
import 'package:chat_flutter_firebase/pages/request/components/label_divider.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:chat_flutter_firebase/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class GroupCreate extends StatefulWidget {
  const GroupCreate(this.friendsGroup, {super.key});

  final List<User> friendsGroup;

  @override
  State<GroupCreate> createState() => _GroupCreateState();
}

class _GroupCreateState extends State<GroupCreate> {
  final _key = GlobalKey<FormState>();
  final GetIt getIt = GetIt.instance;
  late final DatabaseService _databaseService;
  late final NavigationService _navigationService;
  String nameGroup = '';
  String descriptionGroup = '';

  @override
  void initState() {
    _databaseService = getIt.get<DatabaseService>();
    _navigationService = getIt.get<NavigationService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Grupo'),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (!_key.currentState!.validate()) return;
          _key.currentState!.save();
          _databaseService.createGroup(
            groupName: nameGroup,
            groupDescription: descriptionGroup,
            groupMembers: widget.friendsGroup,
          );
          _navigationService.removeUntilNamed('/home');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _form(),
          const LabelDivider('Amigos Selecionados'),
          _selectedFriends(),
        ],
      ),
    );
  }

  Widget _form() {
    return Form(
      key: _key,
      child: Column(children: [
        CustomFormField(
          labelText: 'Nome do Grupo',
          onSaved: (value) {
            nameGroup = value ?? '';
          },
          validator: (value) => value == null || value.isEmpty ? 'Nome do Grupo não pode ser vazio' : null,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: CustomFormField(
            labelText: 'Descrição do Grupo',
            onSaved: (value) {
              descriptionGroup = value ?? '';
            },
          ),
        ),
      ]),
    );
  }

  Widget _selectedFriends() {
    return Container(
      height: 80,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.friendsGroup.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const CircleAvatar(backgroundImage: NetworkImage('https://i.pravatar.cc/300')),
                SizedBox(
                  width: 60,
                  child: Text(
                    widget.friendsGroup[index].name!,
                    style: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 13,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
