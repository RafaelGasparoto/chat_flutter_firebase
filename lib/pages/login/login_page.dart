import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
import 'package:chat_flutter_firebase/utils/regex.dart';
import 'package:chat_flutter_firebase/widgets/custom_button.dart';
import 'package:chat_flutter_firebase/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late String? _email, _password;
  final _formKey = GlobalKey<FormState>();

  final GetIt _getIt = GetIt.instance;
  late AuthService _authService;
  late NavigationService _navigationService;

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
    _navigationService = _getIt.get<NavigationService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  _logo(),
                  _formLogin(),
                  _registerUser(),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logo() {
    return const Image(
      image: AssetImage('assets/icon/chat-icon.png'),
      height: 200,
    );
  }

  Widget _formLogin() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          CustomFormField(
            labelText: 'E-mail',
            onSaved: (email) {
              _email = email;
            },
            padding: const EdgeInsets.only(bottom: 10),
            keyboardType: TextInputType.emailAddress,
            validator: (email) {
              if (email != null && !emailRegex.hasMatch(email)) return 'E-mail inválido';
              return null;
            },
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
            label: 'Login',
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final result = await _authService.login(_email!, _password!);
                if (result) {
                  _navigationService.replaceToNamed('/home');
                }
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _registerUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text('Não possui uma conta? '),
        TextButton(
          onPressed: () => _navigationService.pushNamed('/register'),
          child: const Text('Cadastre-se'),
        ),
      ],
    );
  }
}
