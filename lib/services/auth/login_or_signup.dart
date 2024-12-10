import 'package:etuloc/controllers/public_controller/auth/login_signup_controller.dart';
import 'package:etuloc/pages/login_page.dart';
import 'package:etuloc/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginOrRegister extends StatelessWidget {
  LoginOrRegister({super.key});
  final LoginSignupController controller = LoginSignupController();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.shownLoginPage.value) {
        return LoginPage(onTap: controller.togglePages);
      } else {
        return RegisterPage(onTap: controller.togglePages);
      }
    });
  }
}
