import 'package:etuloc/components/colors.dart';
import 'package:etuloc/components/item_list_tile.dart';
import 'package:etuloc/controllers/public_controller/auth/auth_controller.dart';
import 'package:etuloc/pages/messages.dart';
import 'package:etuloc/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? homeTap;
  Widget profile;
  MyDrawer({super.key, required this.homeTap,required this.profile});
  final AuthController authController = AuthController();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: myPrimaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(25.0),
                child: DrawerHeader(
                  decoration: BoxDecoration(),
                  child: Text(
                    "E T U L O C",
                    style: TextStyle(fontSize: 40, color: Colors.white),
                  ),
                ),
              ),
              //User Profile
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: ItemListTile(
                  label: "Profile",
                  icon: Icons.person,
                  ontap: ()=>Get.to(profile),
                ),
              )),
              const SizedBox(
                height: 25,
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: ItemListTile(
                  label: "HomePage",
                  icon: Icons.home,
                  ontap: () {
                    Get.back();
                    Get.to(authController.homepage);
                  },
                ),
              )),
              const SizedBox(
                height: 25,
              ),
              Center(
                  child: Padding(
                padding: const EdgeInsets.only(left: 40),
                child: ItemListTile(
                  label: "Messages",
                  icon: Icons.message_sharp,
                  ontap: () =>Get.to(MessagersPage()),
                ),
              )),
            ],
          ),
          //Logout
          Center(
              child: Padding(
            padding: const EdgeInsets.only(left: 40),
            child: ItemListTile(
              label: "Logout",
              icon: Icons.logout,
              ontap: () {
                AuthService auth = AuthService();
                auth.signOut();
              },
            ),
          )),
        ],
      ),
    );
  }
}
