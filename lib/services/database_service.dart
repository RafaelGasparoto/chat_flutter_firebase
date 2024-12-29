import 'package:chat_flutter_firebase/models/chat.dart';
import 'package:chat_flutter_firebase/models/message.dart';
import 'package:chat_flutter_firebase/models/user.dart';
import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/utils/generate_chat_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final AuthService _authService = GetIt.instance.get<AuthService>();

  CollectionReference? _userCollection;
  CollectionReference? _chatCollection;

  DatabaseService() {
    _setupCollectionsReference();
  }

  void _setupCollectionsReference() {
    _userCollection = _firebaseFirestore.collection('users').withConverter<User>(
          fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );

    _chatCollection = _firebaseFirestore.collection('chats').withConverter<Chat>(
          fromFirestore: (snapshot, _) => Chat.fromJson(snapshot.data()!),
          toFirestore: (chat, _) => chat.toJson(),
        );
  }

  Future<void> createUser({required User user}) async {
    try {
      await _userCollection!.doc(user.uid).set(user);
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<User>> getStreamUsers() {
    return _userCollection!.where('uid', isNotEqualTo: _authService.user!.uid).snapshots() as Stream<QuerySnapshot<User>>;
  }

  Stream<Message?> getLastMessage(String otherUserUid) {
    final currentUserUid = _authService.user!.uid;
    final chatId = generateChatId(uid1: currentUserUid, uid2: otherUserUid);
    return FirebaseFirestore.instance.collection('chats').doc(chatId).collection('messages').orderBy('sentAt', descending: true).limit(1).snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) return Message.fromJson(snapshot.docs.first.data());
      return null;
    });
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    final chatId = generateChatId(uid1: uid1, uid2: uid2);
    final chat = await _chatCollection!.doc(chatId).get();
    return chat.exists;
  }

  Future<void> createChat({required String currentUserUid, required String otherUserUid}) async {
    final String chatId = generateChatId(uid1: currentUserUid, uid2: otherUserUid);
    final docRef = _chatCollection!.doc(chatId);
    final Chat chat = Chat(
      id: chatId,
      participants: [currentUserUid, otherUserUid],
      messages: [],
    );

    await docRef.set(chat);
  }

  Stream<DocumentSnapshot<Chat>> getStreamChat(String chatId) => _chatCollection!.doc(chatId).snapshots() as Stream<DocumentSnapshot<Chat>>;

  Future<void> sendMessage({required String chatId, required Message message}) async {
    await _chatCollection!.doc(chatId).update({
      'messages': FieldValue.arrayUnion([message.toJson()])
    });
  }
}
