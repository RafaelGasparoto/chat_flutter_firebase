import 'package:chat_flutter_firebase/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  CollectionReference? _userCollection;

  DatabaseService() {
    _setupCollectionsReference();
  }

  void _setupCollectionsReference() {
    _userCollection = _firebaseFirestore.collection('users').withConverter<User>(
          fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  Future<void> createUser({required User user}) async {
    try {
      await _userCollection!.doc(user.uid).set(user);
    } catch (e) {
      print(e);
    }
  }
}
