import 'package:chat_flutter_firebase/models/friend_request.dart';
import 'package:chat_flutter_firebase/pages/request/components/label_divider.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/utils/regex.dart';
import 'package:chat_flutter_firebase/widgets/custom_button.dart';
import 'package:chat_flutter_firebase/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class FriendRequestTab extends StatefulWidget {
  const FriendRequestTab({super.key});

  @override
  State<FriendRequestTab> createState() => _FriendRequestTabState();
}

class _FriendRequestTabState extends State<FriendRequestTab> {
  final GetIt _getIt = GetIt.instance;
  late final DatabaseService _databaseService;
  final _formKey = GlobalKey<FormState>();
  late String _emailToSendRequest;

  @override
  void initState() {
    _databaseService = _getIt.get<DatabaseService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _requestForm(),
        const LabelDivider('Pedidos Pendentes'),
        _pendingRequests(),
      ],
    );
  }

  Widget _requestForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomFormField(
            labelText: 'Email',
            onSaved: (email) {
              _emailToSendRequest = email!;
            },
            validator: (email) {
              if (email != null && !emailRegex.hasMatch(email)) return 'E-mail inválido';
              return null;
            },
          ),
          CustomButton(
            label: 'Enviar Pedido',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _databaseService.sendFriendRequest(emailToSendRequest: _emailToSendRequest);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _pendingRequests() {
    return Expanded(
      child: StreamBuilder(
        stream: _databaseService.getStreamFriendRequests(),
        builder: (_, snapshot) {
          if (snapshot.hasError) {
            return const Text('Erro ao buscar pedidos pendentes');
          }

          if (snapshot.hasData) {
            return ListView.separated(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                FriendRequest friendRequest = snapshot.data![index];
                return ListTile(
                  minTileHeight: 20,
                  title: Text(friendRequest.senderName!, style: const TextStyle(fontSize: 18)),
                  subtitle: Text(friendRequest.senderEmail!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: const Color.fromARGB(255, 234, 102, 93),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.check),
                        color: const Color.fromARGB(255, 101, 234, 105),
                        onPressed: () {
                          _databaseService.acceptFriendRequest(senderId: friendRequest.senderId!, chatName: friendRequest.senderName!);
                        },
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (_, index) => const Divider(),
              itemCount: snapshot.data!.length,
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
