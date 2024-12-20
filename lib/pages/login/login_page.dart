import 'package:chat_flutter_firebase/services/auth_service.dart';
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

  @override
  void initState() {
    super.initState();
    _authService = _getIt.get<AuthService>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.always,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomFormField(
                  labelText: 'E-mail',
                  onSaved: (email) {
                    _email = email;
                  },
                  padding: const EdgeInsets.only(bottom: 10),
                  keyboardType: TextInputType.emailAddress,
                  validatorRegex: emailRegex,
                  validatorMessage: 'E-mail inválido',
                ),
                CustomFormField(
                  labelText: 'Senha',
                  onSaved: (password) {
                    _password = password;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                CustomButton(
                  label: 'Login',
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final result = await _authService.login(_email!, _password!);
                      if(result) {
                        print('Login realizado com sucesso.');
                      } else {
                        print('Login falhou.');
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
