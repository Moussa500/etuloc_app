import 'package:etuloc/services/firestore/firestore.dart';
import 'package:etuloc/services/sncak_bar_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthService {
  //instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FireStoreService _fireStoreService = FireStoreService();
  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //sign in
  Future<UserCredential> signInWithEmailPassword(
      String email, password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      SnackBarService.showErrorSnackBar("Error", getErrorMessage(e.code));
      throw Exception(e.code);
    }
  }

  //sign up
  Future<UserCredential> signUpWithEmailPassword(
      String email, password, name, phone, status,BuildContext context) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Perform multiple asynchronous operations concurrently using Future.wait
      await Future.wait([
        _fireStoreService.saveUsersInfo(
            email, name, phone, status, userCredential.user!.uid),
        userCredential.user!.updateDisplayName(name),
      ]);

      // Once all operations are completed, return the user credential
      return userCredential;
    } on FirebaseAuthException catch (e) {
      SnackBarService.showErrorSnackBar("Error", getErrorMessage(e.code));

      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  //reset password
  Future<void> resetPassword(String email) async {
    return await _auth.sendPasswordResetEmail(email: email);
  }

  //errors
  String getErrorMessage(String error) {
    switch (error) {
      case 'email-already-in-use':
        return 'The email address is already in use by another account.';
      case 'invalid-email':
        return 'The email address is badly formatted.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'user-not-found':
        return 'There is no user record corresponding to this identifier. The user may have been deleted.';
      case 'wrong-password':
        return 'The password is invalid for the given email, or the account corresponding to the email does not have a password set.';
      default:
        return 'An error occurred. Please try again later.';
    }
  }
}
