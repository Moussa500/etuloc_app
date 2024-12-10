import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etuloc/pages/Etudiant/homepage.dart';
import 'package:etuloc/pages/landlord_view/views/home_page.dart';
import 'package:etuloc/services/auth/login_or_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var user = Rxn<User>();
  var status = ''.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    ever(user, _setInitialScreen);
  }
  Widget? homepage;
  Widget? profile;
  void _setInitialScreen(User? user) async {
    if (user != null) {
      DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(user!.uid).get();
      status.value = userDoc['status'];
      if (status.value == 'student') {
        Get.offAll(EtudiantHomePage());
      } else {
        Get.offAll(LandLordHomePage());
      }
    } else {
      Get.offAll(() => LoginOrRegister());
    }
  }
}
