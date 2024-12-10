import 'package:etuloc/controllers/landlord_controllers.dart/home_page_controller.dart';
import 'package:etuloc/controllers/landlord_controllers.dart/post_controller.dart';
import 'package:etuloc/controllers/public_controller/auth/auth_controller.dart';
import 'package:etuloc/firebase_options.dart';
import 'package:etuloc/services/auth/auth_gate.dart';
import 'package:etuloc/stateManagement/checkbox.dart';
import 'package:etuloc/stateManagement/search_state.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => SearchTextProvider()),
      ChangeNotifierProvider(create: (context) => CheckBoxChanger()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController());
        Get.lazyPut<PostController>(() => PostController());
        Get.lazyPut<HomePageController>(() => HomePageController());
      }),
      home: const AuthGate(),
    );
  }
}
