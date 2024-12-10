import 'package:get/get.dart';

class LoginSignupController extends GetxController {
  RxBool shownLoginPage = true.obs;
  void togglePages() {
    shownLoginPage.value = !shownLoginPage.value;
  }
}
