import 'dart:io';

import 'package:chat_flutter_firebase/models/user.dart';
import 'package:chat_flutter_firebase/services/database_service.dart';
import 'package:chat_flutter_firebase/services/media_service.dart';
import 'package:chat_flutter_firebase/widgets/profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GetIt _getIt = GetIt.instance;
  late final MediaService _mediaService;
  late final User? user;
  File? _selectedPicture;

  @override
  void initState() {
    _mediaService = _getIt.get<MediaService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)!.settings.arguments as User?;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        if (_selectedPicture != null) {
          _mediaService.uploadProfilePicture(_selectedPicture!, user!.uid!).then((url) {
            _getIt.get<DatabaseService>().updateProfilePictureUrl(url);
          });
        }

        Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: Center(
          child: Column(
            children: [
              ProfilePicture(
                profilePictureUrl: user?.profilePicture,
                onSelectPicture: (File picture) {
                  _selectedPicture = picture;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
