import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MediaService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<File?> getImage() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    }

    return null;
  }

  Future<String> uploadProfilePicture(File image, String userUid) async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child('profile_pictures/$userUid');

    final uploadTask = ref.putFile(image);
    late String url;

    await uploadTask.whenComplete(() async {
      await ref.getDownloadURL().then((value) {
        url = value;
      });
    });

    return url;
  }
}
