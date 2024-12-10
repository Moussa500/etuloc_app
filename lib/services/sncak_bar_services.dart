import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBarService {
  static void showErrorSnackBar(String title, String content) {
    Get.snackbar(title,content,
        colorText: Colors.white, backgroundColor: Colors.red);
  }

  static void showSuccessSnackBar(String title, String content) {
    Get.snackbar(title, content,
        colorText: Colors.white, backgroundColor: Colors.green);
  }
}
