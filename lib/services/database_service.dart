import 'package:chat_flutter_firebase/models/chat.dart';
import 'package:chat_flutter_firebase/models/friend_request.dart';
import 'package:chat_flutter_firebase/models/message.dart';
import 'package:chat_flutter_firebase/models/user.dart';
import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/current_user_service.dart';
import 'package:chat_flutter_firebase/services/snackbar_service.dart';
import 'package:chat_flutter_firebase/utils/generate_chat_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final AuthService _authService = GetIt.instance.get<AuthService>();
  final SnackbarService _snackbarService = GetIt.instance.get<SnackbarService>();
  final CurrentUserService _currentUserService = GetIt.instance.get<CurrentUserService>();

  CollectionReference<User>? _userCollection;
  CollectionReference<Chat>? _chatCollection;
  CollectionReference<FriendRequest>? _friendRequestCollection;

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

    _friendRequestCollection = _firebaseFirestore.collection('friend_requests').withConverter<FriendRequest>(
          fromFirestore: (snapshot, _) => FriendRequest.fromJson(snapshot.data()!),
          toFirestore: (friendRequest, _) => friendRequest.toJson(),
        );
  }

  Future<void> createUser({required User user}) async {
    try {
      await _userCollection!.doc(user.uid).set(user);
    } catch (e) {
      print(e);
    }
  }

  void setFcmToken(String fcmToken) {
     _userCollection!.doc(_authService.user!.uid).update({'fcmToken': fcmToken});   
  }

  Future<User?> getUser(String userId) async {
    final userDoc = await _userCollection!.doc(userId).get();
    return userDoc.exists ? userDoc.data() : null;
  }

  Stream<List<Chat>> getStreamAvaliableChats() {
    return _userCollection!.doc(_authService.user!.uid).snapshots().asyncMap((user) async {
      final List<String> friends = user.data()?.friends ?? [];
      final List<String> chats = user.data()?.groups ?? [];

      for (String friend in friends) {
        chats.add(generateId(uid1: _authService.user!.uid, uid2: friend));
      }
  
      if(chats.isEmpty) return [];

      final List<DocumentSnapshot<Chat>> snapshotChats = await Future.wait(chats.map((group) async => _chatCollection!.doc(group).get()).toList());

      return snapshotChats.map((chat) => chat.data()!).toList();
    });
  }

  Stream getStreamFriends() {
    return _userCollection!.doc(_authService.user!.uid).snapshots().asyncMap((user) async {
      final List<String>? friends = user.data()!.friends;
      if (friends == null) return [];

      final List<DocumentSnapshot<User>> snapshots = await Future.wait(friends.map((friend) async => _userCollection!.doc(friend).get()).toList());
      return snapshots.map((user) => user.data()!).toList();
    });
  }

  Stream<Message?> getLastMessage(String chatId) {
    return _chatCollection!.doc(chatId).collection('messages').orderBy('sentAt', descending: true).limit(1).snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) return Message.fromJson(snapshot.docs.first.data());
      return null;
    });
  }

  Future<bool> checkChatExists(String uid1, String uid2) async {
    final chatId = generateId(uid1: uid1, uid2: uid2);
    final chat = await _chatCollection!.doc(chatId).get();
    return chat.exists;
  }

  Future<void> createChat({required String currentUserUid, required String otherUserUid, String? chatName}) async {
    final String chatId = generateId(uid1: currentUserUid, uid2: otherUserUid);
    final docRef = _chatCollection!.doc(chatId);

    final Chat chat = Chat(
      name: chatName,
      id: chatId,
      participants: [currentUserUid, otherUserUid],
      messages: [],
    );

    await docRef.set(chat);
  }

  Stream<List<Message>> getStreamMessages(String chatId) {
    return _chatCollection!.doc(chatId).collection('messages').snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) return snapshot.docs.map((message) => Message.fromJson(message.data())).toList();
      return [];
    });
  }

  Future<void> sendMessage({required String chatId, required Message message}) async => await _chatCollection!.doc(chatId).collection('messages').doc().set(message.toJson());

  Future<void> sendFriendRequest({required String emailToSendRequest}) async {
    final senderEmail = _currentUserService.user!.email;
    final senderId = _currentUserService.user!.uid;
    final senderName = _currentUserService.user!.name;

    try {
      final User? receiver = await _getUserByEmail(emailToSendRequest);

      if (receiver == null) {
        _snackbarService.snackBarError(message: 'Usuário não encontrado!');
        return;
      }

      final FriendRequest friendRequest = FriendRequest(senderEmail: senderEmail, senderId: senderId, senderName: senderName, receiverId: receiver.uid);

      _friendRequestCollection!.doc(generateId(uid1: senderId!, uid2: receiver.uid!)).set(friendRequest);

      _snackbarService.snackBarSucess(message: 'Solicitação de amizade enviada com sucesso!');
    } catch (e) {
      _snackbarService.snackBarError(message: 'Falha ao enviar solicitação de amizade!');
    }
  }

  Future<void> acceptFriendRequest({required String senderId, required String chatName}) async {
    try {
      final receiverId = _currentUserService.user!.uid;

      final FriendRequest friendRequest = await _friendRequestCollection!.doc(generateId(uid1: senderId, uid2: receiverId!)).get().then((value) => value.data()!);
      
      await createChat(currentUserUid: receiverId, otherUserUid: senderId);

      await _userCollection!.doc(friendRequest.senderId).update({
        'friends': FieldValue.arrayUnion([friendRequest.receiverId])
      });
      await _userCollection!.doc(friendRequest.receiverId).update({
        'friends': FieldValue.arrayUnion([friendRequest.senderId])
      });

      await _friendRequestCollection!.doc(generateId(uid1: senderId, uid2: receiverId)).delete();
      _snackbarService.snackBarSucess(message: 'Solicitação de amizade aceita com sucesso!');
    } catch (e) {
      _snackbarService.snackBarError(message: 'Falha ao aceitar solicitação de amizade!');
    }
  }

  Future<void> rejectFriendRequest({required String senderId}) async =>
      await _friendRequestCollection!.doc(generateId(uid1: senderId, uid2: _currentUserService.user!.uid!)).delete();

  Stream<List<FriendRequest>> getStreamFriendRequests() {
    return _friendRequestCollection!.where('receiverId', isEqualTo: _authService.user!.uid).snapshots().map(
      (snapshot) {
        if (snapshot.docs.isNotEmpty) return snapshot.docs.map((friendRequest) => friendRequest.data()).toList();
        return [];
      },
    );
  }

  Future<User?> _getUserByEmail(String userEmail) async {
    final userDoc = await _userCollection!.where('email', isNotEqualTo: _authService.user!.email, isEqualTo: userEmail).get();
    if (userDoc.docs.isNotEmpty) return userDoc.docs.first.data();
    return null;
  }

  Future<void> createGroup({required String groupName, required String groupDescription, required List<User> groupMembers}) async {
    final chatRef = _chatCollection!.doc();
    String groupId = chatRef.id;
    groupMembers.add(_currentUserService.user!);
    for (User member in groupMembers) {
      _userCollection!.doc(member.uid).update({
        'groups': FieldValue.arrayUnion([groupId])
      });
    }

    await chatRef.set(Chat(
      id: groupId,
      name: groupName,
      description: groupDescription,
      isGroup: true,
      participants: groupMembers.map((user) => user.uid!).toList(),
    ));
  }

  Stream<List<User>> getStreamChatUsers(List<String> users) {
    return _userCollection!.where('uid', whereIn: users).snapshots().map((snapshot) => snapshot.docs.map((user) => user.data()).toList());
  }

  Stream<Chat> getStreamChat(String chatId) => _chatCollection!.doc(chatId).snapshots().map((snapshot) => snapshot.data()!);
}
