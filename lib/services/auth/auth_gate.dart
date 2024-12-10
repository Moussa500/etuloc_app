import 'package:etuloc/controllers/public_controller/auth/auth_controller.dart';
import 'package:etuloc/pages/Etudiant/homepage.dart';
import 'package:etuloc/pages/landlord_view/views/home_page.dart';
import 'package:etuloc/services/auth/login_or_signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<AuthController>(
        builder: (controller) {
          if (controller.user.value != null) {
            if (controller.status.value == '') {
              return const Center(child: CircularProgressIndicator());
            } else if (controller.status.value == 'student') {
              return EtudiantHomePage();
            } else {
              return LandLordHomePage();
            }
          } else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
