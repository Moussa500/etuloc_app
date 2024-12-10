import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etuloc/services/firebase_storage.dart/firebase_storage.dart';
import 'package:etuloc/services/firestore/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:string_validator/string_validator.dart';

class ProfileController extends GetxController {
  final StorageService _storageService = StorageService();
  final FireStoreService _fireStoreService = FireStoreService();
  var imagePath = ''.obs;
  var image = Rx<XFile?>(null);
  RxString name = ''.obs;
  RxString city = ''.obs;
  RxString phoneNumber = ''.obs;
  //controllers for text fields
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  //Boolean variables for visibility
  RxBool cityVisibility = false.obs;
  RxBool phoneVisibility = false.obs;
  int postedHouses = 0;
  int rentedHouses = 0;
  int numberRatings = 0;
  int sumRatings = 0;
  //Firestore reference
  final CollectionReference _LandLordProfileReference =
      FirebaseFirestore.instance.collection('landlordsProfile');
  //current user
  final User currentUser = FirebaseAuth.instance.currentUser!;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProfileData();
  }

  void fetchProfileData() async {
    var doc = await _LandLordProfileReference.doc(currentUser.uid).get();
    var data = doc.data() as Map<String, dynamic>;
    phoneNumber.value = data["phone_number"];
    imagePath.value = data["pdp"] ?? '';
    name.value = data["name"];
    city.value = data["city"];
    numberRatings = data["number_ratings"];
    sumRatings = data["sum_ratings"];
    phoneVisibility.value = data["phone_visibility"] ?? false;
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    image.value = await picker.pickImage(source: ImageSource.gallery);
    if (image.value != null) {
      Get.dialog(AlertDialog(
        content: const Text("you're image has been uploaded successfully"),
        actions: [
          ElevatedButton(onPressed: () => Get.back(), child: const Text("back"))
        ],
      ));
    }
  }

  void updateProfile() async {
    bool valid = true;
    if (cityController.text.isNotEmpty) {
      try {
        await _fireStoreService.updateInfos(
            'landlordsProfile', currentUser.uid, cityController.text, 'city');
        city.value = cityController.text;
      } catch (e) {
        print("Error : $e");
      }
    }
    if (nameController.text.isNotEmpty) {
      if (isAlpha(nameController.text)) {
        try {
          await Future.wait([
            _fireStoreService.updateInfos('landlordsProfile', currentUser.uid,
                nameController.text, 'name'),
            _fireStoreService.updateInfos(
                'user', currentUser.uid, nameController.text, 'name')
          ]);
          name.value = nameController.text;
        } catch (e) {
          print("Error:$e");
        }
      } else {
        Get.snackbar("Error", "Please Enter a valid name");
        valid = false;
      }
    }
    if (phoneController.text.isNotEmpty) {
      phoneNumber.value = phoneController.text;
      if (isNumeric(phoneController.text) && phoneController.text.length == 8) {
        try {
          await Future.wait([
            _fireStoreService.updateInfos('landlordsProfile', currentUser.uid,
                phoneController.text, 'phone_number'),
            _fireStoreService.updateInfos(
                'user', currentUser.uid, phoneController.text, 'phone')
          ]);
          phoneNumber.value = phoneController.text;
        } catch (e) {
          print("Error:$e");
        }
      } else {
        Get.snackbar("Error", "Please Enter a valid phone Number");
        valid = false;
      }
    }
    if (image.value != null) {
      try {
        String downloadUrl =
            await _storageService.uploadImage('images', image.value!);
        await _fireStoreService.updateInfos(
            'landlordsProfile', currentUser.uid, downloadUrl, 'pdp');
        imagePath.value = downloadUrl;
      } catch (e) {
        print("Error : $e");
      }
    }
    if (valid) {
      Get.dialog(AlertDialog(
          content: Text("Your infos has been updated successfully"),
          actions: [
            ElevatedButton(onPressed: () => Get.back(), child: const Text("Ok"))
          ]));
    }
  }

  void toggleCityVisibility() async {
    cityVisibility.value = !cityVisibility.value;
    await _fireStoreService.updateInfos("landlordsProfile", currentUser.uid,
        cityVisibility.value, "city_visibility");
  }

  void togglePhoneVisibility() async {
    phoneVisibility.value = !phoneVisibility.value;
    await _fireStoreService.updateInfos("landlordsProfile", currentUser.uid,
        phoneVisibility.value, "phone_visibility");
  }
}
