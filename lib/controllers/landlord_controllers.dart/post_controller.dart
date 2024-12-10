import 'package:etuloc/controllers/landlord_controllers.dart/home_page_controller.dart';
import 'package:etuloc/services/firebase_storage.dart/firebase_storage.dart';
import 'package:etuloc/services/firestore/firestore.dart';
import 'package:etuloc/services/firestore/location/location_service.dart';
import 'package:etuloc/services/sncak_bar_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PostController extends GetxController {
  //homePage Controller
  HomePageController homePageController = HomePageController();
  //reactive variables
  RxBool isPosting = false.obs;
  RxBool isGettingLocation = false.obs;
  //controllers
  TextEditingController searchController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController rentTypeController = TextEditingController();
  TextEditingController moreInfoController = TextEditingController();
  TextEditingController placesNumberController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  //services
  final StorageService storageService = StorageService();
  final FireStoreService fireStoreService = FireStoreService();
  final LocationService location = LocationService();
  //variables
  double? lat;
  double? long;
  List<XFile> images = [];
  //check if the user filled all the fields
  bool checkUserInput() {
    bool test = true;
    if (images.isEmpty) {
      SnackBarService.showErrorSnackBar("Error", "Images are required");
      test = false;
    } else if (priceController.text.isEmpty) {
      SnackBarService.showErrorSnackBar("Error", "The price is required");
      test = false;
    } else if (locationController.text.isEmpty) {
      SnackBarService.showErrorSnackBar("Error", "Location is required");
      test = false;
    } else {
      if (typeController.text.isEmpty) {
        SnackBarService.showErrorSnackBar("Error", "type is required");
        test = false;
      } else {
        if (genderController.text.isEmpty) {
          SnackBarService.showErrorSnackBar("Error", "Gender is required");
          test = false;
        } else {
          if (rentTypeController.text.isEmpty) {
            SnackBarService.showErrorSnackBar(
                "Error", "Renting Type is required");
            test = false;
          } else {
            if (placesNumberController.text.isEmpty &&
                rentTypeController.text == "Bed") {
              SnackBarService.showErrorSnackBar("Error",
                  "you should specify the number of places if you went to rent per bed");
              test = false;
            }
          }
        }
      }
    }
    return test;
  }

  //get the location of the house
  void locate() async {
    try {
      isGettingLocation.value = true;
      Position position = await location.getCurrentLocation();
      lat = position.latitude;
      long = position.longitude;
      locationController.text = await location.decodeCoordinates(lat!, long!);
    } catch (e) {
      print("Error : $e");
    } finally {
      isGettingLocation.value = false;
    }
  }

  //post the house
  void post() async {
    if (checkUserInput()) {
      isPosting.value = true;
      try {
        List results = await Future.wait([
          location.getCityNameFromCoordinates(lat!, long!),
          storageService.uploadMultipleImages(images, "house"),
          fireStoreService.getFieldValue("landlordsProfile",
              FirebaseAuth.instance.currentUser!.uid, "posted_houses")
        ]);
        String cityName = results[0];
        List imagesUrl = results[1];
        String postedHouses = results[2];
        await Future.wait([
          fireStoreService.postHouse(
              cityName,
              priceController.text,
              imagesUrl.join(','),
              placesNumberController.text,
              locationController.text,
              rentTypeController.text == "Bed",
              typeController.text,
              rentTypeController.text == "Bed"
                  ? placesNumberController.text
                  : "0",
              FirebaseAuth.instance.currentUser!.uid,
              genderController.text),
          fireStoreService.updateInfos(
              "landlordsProfile",
              FirebaseAuth.instance.currentUser!.uid,
              int.parse(postedHouses) + 1,
              "posted_houses"),
        ]);
        Get.back(result: true);
        SnackBarService.showSuccessSnackBar(
            "Success", "You're house has been posted successfully");
        Get.back(result: true);
      } catch (e) {
        print("Error : $e");
      } finally {
        isPosting.value = false;
      }
    }
  }

  void pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      images = await picker.pickMultiImage();
    } catch (e) {
      print("Error:$e");
    }
  }
}
