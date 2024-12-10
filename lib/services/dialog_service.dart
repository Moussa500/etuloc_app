import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void errorDialog(String error) {
  Get.dialog(AlertDialog(
    content: Text(
      error,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.red,
    actions: [ElevatedButton(onPressed: () => Get.back(), child: Text("ok"))],
  ));
}

//showing success
/*void successDialog(String message) {
  Get.dialog(AlertDialog(
    content: Text(
      error
    ),
  ))
}*/

Future<dynamic> successDialog(BuildContext context, String content) {
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            backgroundColor: Colors.green,
            content: Text(
              content,
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context), child: Text("Ok"))
            ],
          ));
}
