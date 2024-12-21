import 'package:chat_flutter_firebase/services/snackbar_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final SnackbarService _snackbarService = GetIt.instance.get<SnackbarService>();

  User? _user;

  User? get user => _user;

  AuthService() {
    _firebaseAuth.authStateChanges().listen((user) => _user = user);
  }

  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        _user = userCredential.user;
        return true;
      }
    } on FirebaseAuthException catch (exception) {
      if (exception.code == 'user-not-found') {
        _snackbarService.snackBarWarning(message: 'Usuário não encontrado!');
      } else if (exception.code == 'wrong-password') {
        _snackbarService.snackBarWarning(message: 'Senha incorreta!');
      } else {
        _snackbarService.snackBarError(message: 'Falha ao realizar login!');
      }
    }
    return false;
  }

  Future<bool> logout() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> singUp({required String email, required String password}) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        _user = userCredential.user;
        _snackbarService.snackBarSucess(message: 'Cadastro realizado com sucesso.');
        return true;
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        _snackbarService.snackBarError(message: 'O email informado ja esta cadastrado!');
      } else {
        _snackbarService.snackBarError(message: 'Não foi possivel realizar o cadastro!');
      }
    }
    return false;
  }
}
