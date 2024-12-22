import 'package:chat_flutter_firebase/models/chat.dart';
import 'package:chat_flutter_firebase/models/message.dart';
import 'package:chat_flutter_firebase/models/user.dart';
import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/utils/generate_chat_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:get_it/get_it.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.otherUser});

  final User otherUser;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final GetIt _getIt = GetIt.instance;
  late ChatUser _currentUserChat, _otherUserChat;
  late final AuthService _authService;
  late final DatabaseService _databaseService;
  late final String _chatId;

  @override
  void initState() {
    _authService = _getIt.get<AuthService>();
    _databaseService = _getIt.get<DatabaseService>();

    _currentUserChat = ChatUser(
      id: _authService.user!.uid,
      firstName: _authService.user!.email!,
    );

    _otherUserChat = ChatUser(
      id: widget.otherUser.uid!,
      firstName: widget.otherUser.name!,
    );

    _chatId = generateChatId(uid1: _authService.user!.uid, uid2: widget.otherUser.uid!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _databaseService.getStreamChat(generateChatId(uid1: _authService.user!.uid, uid2: widget.otherUser.uid!)),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Erro ao buscar chat');
          }

          if (snapshot.hasData && snapshot.data != null) {
            Chat chat = snapshot.data!.data()!;
            List<ChatMessage> messages = _generateMessages(chat);

            return DashChat(
              messageOptions: const MessageOptions(
                showTime: true,
              ),
              currentUser: _currentUserChat,
              onSend: (ChatMessage message) => _sendMessage(message),
              messages: messages,
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> _sendMessage(ChatMessage chatMessage) async {
    final Message message = Message(
      senderId: _currentUserChat.id,
      content: chatMessage.text,
      messageType: MessageType.Text,
      sentAt: Timestamp.fromDate(chatMessage.createdAt),
    );

    await _databaseService.sendMessage(chatId: _chatId, message: message);
  }

  List<ChatMessage> _generateMessages(Chat chat) {
    List<ChatMessage> messages = [];
    if (chat.messages != null && chat.messages!.isNotEmpty) {
      messages = chat.messages!
          .map((message) => ChatMessage(
                text: message.content!,
                createdAt: message.sentAt!.toDate(),
                user: message.senderId == _currentUserChat.id ? _currentUserChat : _otherUserChat,
              ))
          .toList();
      messages.sort((ChatMessage a, ChatMessage b) => b.createdAt.compareTo(a.createdAt));
    }
    return messages;
  }
}
