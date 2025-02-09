import 'dart:io';

import 'package:chat_flutter_firebase/models/user.dart';
import 'package:chat_flutter_firebase/services/auth_service.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/media_service.dart';
import 'package:chat_flutter_firebase/services/navigation_service.dart';
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
  late final AuthService _authService;
  late final MediaService _mediaService;
  late final DatabaseService _databaseService;

  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  String? _password;
  File? _selectedImage;

  @override
  void initState() {
    _navigationService = _getIt.get<NavigationService>();
    _authService = _getIt.get<AuthService>();
    _mediaService = _getIt.get<MediaService>();
    _databaseService = _getIt.get<DatabaseService>();
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: GestureDetector(
        onTap: () async {
          File? selectedImage = await _mediaService.getImage();

          if (selectedImage != null) {
            setState(() {
              _selectedImage = selectedImage;
            });
          }
        },
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          radius: 60,
          backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : const AssetImage('assets/user.png'),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(),
                color: Colors.white,
              ),
              height: 45,
              width: 45,
              child: const Icon(
                Icons.camera_alt,
                size: 30,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _formSingUp() {
    return Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomFormField(
              labelText: 'Nome',
              onSaved: (name) {
                _name = name;
              },
              validator: (name) {
                if (name == null || name.isEmpty) return 'Nome não pode ser vazio';
                return null;
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
              validator: (email) {
                if (email != null && !emailRegex.hasMatch(email)) return 'E-mail inválido';
                return null;
              },
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
              validator: (password) {
                if (password == null || password.length < 6) return 'Senha precisa ter ao menos 6 caracteres';
                return null;
              },
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
        _databaseService.createUser(
          user: User(
            uid: _authService.user!.uid,
            email: _email!,
            name: _name!,
          ),
        );
        _navigationService.goBack();
      }
    }
  }
}
