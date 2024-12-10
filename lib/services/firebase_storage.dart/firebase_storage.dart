import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  // Upload image to Firebase Storage
  Future<String> uploadImage(String bucketName, XFile image) async {
    final storage = FirebaseStorage.instance;
    final imageRef = storage.ref().child('$bucketName/${image.name}'); // Use original file name
    await imageRef.putFile(File(image.path));
    final snapshot = await imageRef.getDownloadURL();
    return snapshot;
  }

  Future<List<String>> uploadMultipleImages(List<XFile> images, String bucketName) async {
    List<String> imageUrls = [];

    try {
      for (XFile image in images) {
        String imageUrl = await uploadImage(bucketName, image);
        imageUrls.add(imageUrl);
      }
    } catch (error) {
      // Handle individual upload errors
      // Consider returning a partial list of successful URLs
    }
    return imageUrls;
  }
}
