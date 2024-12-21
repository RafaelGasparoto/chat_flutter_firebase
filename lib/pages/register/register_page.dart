import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:chat_flutter_firebase/services/snackbar_service.dart';
import 'package:chat_flutter_firebase/utils/regex.dart';
import 'package:chat_flutter_firebase/widgets/custom_button.dart';
import 'package:chat_flutter_firebase/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GetIt _getIt = GetIt.instance;
  late final NavigationService _navigationService;
  late final SnackbarService _snackbarService;
  late final AuthService _authService;

  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;

  @override
  void initState() {
    _navigationService = _getIt.get<NavigationService>();
    _snackbarService = _getIt.get<SnackbarService>();
    _authService = _getIt.get<AuthService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _profilePicture(),
                  _formSingUp(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profilePicture() {
    return const Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: CircleAvatar(
        radius: 60,
        backgroundImage: NetworkImage('https://i.pravatar.cc/400'),
      ),
    );
  }

  Widget _formSingUp() {
    return Center(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomFormField(
              labelText: 'Nome',
              onSaved: (name) {
                _name = name;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            CustomFormField(
              labelText: 'E-mail',
              onSaved: (email) {
                _email = email;
              },
              keyboardType: TextInputType.emailAddress,
              validatorRegex: emailRegex,
              validatorMessage: 'E-mail inválido',
            ),
            const SizedBox(
              height: 30,
            ),
            CustomFormField(
              labelText: 'Senha',
              onSaved: (password) {
                _password = password;
              },
              keyboardType: TextInputType.visiblePassword,
              obscureText: true,
            ),
            const SizedBox(
              height: 20,
            ),
            CustomButton(
              label: 'Cadastrar',
              onPressed: () async => await _registerUser(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final result = await _authService.singUp(email: _email!, password: _password!);
      if (result) {
        _snackbarService.snackBarSucess(message: 'Usuário cadastrado com sucesso');
        _navigationService.goBack();
      } else {
        _snackbarService.snackBarError(message: 'Erro ao cadastrar usuário');
      }
    }
  }
}
