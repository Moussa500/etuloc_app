import 'package:etuloc/components/background.dart';
import 'package:etuloc/components/buttons.dart';
import 'package:etuloc/components/text.dart';
import 'package:etuloc/components/textfields.dart';
import 'package:etuloc/services/auth/auth_service.dart';
import 'package:etuloc/services/sncak_bar_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  ResetPassword({super.key});
  final _emailController = TextEditingController();
  void resetPassword(BuildContext context) async {
    final authService = AuthService();
    try {
      await authService.resetPassword(_emailController.text);
      SnackBarService.showSuccessSnackBar(
          // ignore: use_build_context_synchronously
          "success", "a password reset email was successfuly sent to your email");
    } on FirebaseAuthException catch (e) {
      SnackBarService.showErrorSnackBar("Error", e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Background(
        elements: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Header(label: "Recover Password"),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 26),
              child: Text(
                "Enter the Email Adresse associated with your account",
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  fontFamily: "Poppins",
                ),
              ),
            ),
            CustomTextField(
              label: "Email",
              controller: _emailController,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35),
              child: MainButton(
                  height: 55,
                  width: 221,
                  label: "Recover Password",
                  onPressed: () {
                    resetPassword(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
