import 'package:etuloc/services/firestore/firestore.dart';
import 'package:etuloc/services/sncak_bar_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateController extends GetxController {
  final FireStoreService _fireStoreService = FireStoreService();
  //observal variable
  RxBool isUpdating = false.obs;
  //text Editing Controllers
  TextEditingController priceController = TextEditingController();
  TextEditingController rentTypeController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  void updateHouse(String houseId) async {
    try {
      if (genderController.text.isNotEmpty ||
          rentTypeController.text.isNotEmpty ||
          priceController.text.isNotEmpty) {
        if (priceController.text.isNotEmpty) {
          if (priceController.text.isNumericOnly) {
            isUpdating.value = true;
            await _fireStoreService.updateInfos(
                "houses", houseId, priceController.text, "price");
          } else {
            SnackBarService.showSuccessSnackBar(
                "Success", "Please Enter a valid Price");
          }
        }
        if (rentTypeController.text.isNotEmpty) {
          await _fireStoreService.updateInfos(
              "houses", houseId, rentTypeController.text, "type");
        }

        if (genderController.text.isNotEmpty) {
          await _fireStoreService.updateInfos(
              "houses", houseId, genderController.text, "gender");
        }
        Get.back(result: true);

        SnackBarService.showSuccessSnackBar(
            "Success", "House updated successfully");
      }
    } catch (error) {
      // Handle error
      print("Error updating house: $error");
      SnackBarService.showErrorSnackBar(
          "Error", "Error updating house. Please try again.");
    } finally {
      isUpdating.value = false;
    }
  }
}
