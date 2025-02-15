import 'dart:io';

import 'package:chat_flutter_firebase/services/media_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({required this.onSelectPicture, required this.profilePictureUrl, super.key});

  final String? profilePictureUrl;
  final void Function(File picture) onSelectPicture;

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final GetIt _getIt = GetIt.instance;
  late final MediaService _mediaService;
  
  File? _selectedImage;

  @override
  void initState() {
    _mediaService = _getIt.get<MediaService>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: GestureDetector(
        onTap: () async {
          File? selectedImage = await _mediaService.getImage();

          if (selectedImage != null) {
            setState(() {
              _selectedImage = selectedImage;
              widget.onSelectPicture(selectedImage);
            });
          }
        },
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          radius: 60,
          backgroundImage: _getSelectedPicture(),
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

  ImageProvider<Object> _getSelectedPicture() {
    if(_selectedImage != null) return FileImage(_selectedImage!);
    if(widget.profilePictureUrl != null) return NetworkImage(widget.profilePictureUrl!);
    return const AssetImage('assets/user.png');
  }
}
