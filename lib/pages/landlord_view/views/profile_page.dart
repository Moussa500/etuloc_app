import 'package:etuloc/components/background.dart';
import 'package:etuloc/components/buttons.dart';
import 'package:etuloc/components/colors.dart';
import 'package:etuloc/components/profile_list_tile.dart';
import 'package:etuloc/components/text.dart';
import 'package:etuloc/components/textfields.dart';
import 'package:etuloc/controllers/landlord_controllers.dart/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:svg_flutter/svg.dart';

class LandLordProfile extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: FittedBox(
            child: Background(
              elements: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 200,
                        width: 200,
                        child: ClipOval(
                          child: controller.imagePath.value == ''
                              ? Image.asset(
                                  "assets/images/profile.png",
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  controller.imagePath.value,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() => Header(label: controller.name.value)),
                      const SizedBox(height: 10),
                      rating(),
                      const SizedBox(height: 10,),
                      postedHouses(),
                      const SizedBox(height: 20),
                      rentedHouses(),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(() => city()),
                      Obx(() => phoneNumber()),
                      // Add your rating, posted houses, rented houses, city, and phone number UI components here
                      // Use similar approach with Obx to make them reactive
                      MainButton(
                        height: 41,
                        width: 165,
                        label: "Edit",
                        onPressed: () => editUserInfos(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  void editUserInfos(BuildContext context) {
    Get.dialog(
      AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: controller.pickImage,
                child: Image.asset(
                  "assets/images/upload.png",
                  height: 170,
                  width: 170,
                ),
              ),
              const Text("Tap to upload a picture"),
              const SizedBox(height: 25),
              CustomTextField(
                  label: 'Name', controller: controller.nameController),
              const SizedBox(height: 25),
              CustomTextField(
                  label: 'city', controller: controller.cityController),
              const SizedBox(height: 25),
              CustomTextField(
                  label: 'Phone Number',
                  controller: controller.phoneController),
              const SizedBox(height: 25),
              MainButton(
                height: 41,
                width: 150,
                label: 'Update',
                onPressed: controller.updateProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  //rating section
  ProfileListTile rating() {
    int? avg;
    if (controller.numberRatings != 0) {
      avg = controller.sumRatings ~/ controller.numberRatings;
    } else {
      print("not rated yet");
    }
    return ProfileListTile(
      label: "Rating :",
      content: controller.numberRatings == 0
          ? const Text(
              "not rated yet",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            )
          : SizedBox(
              width: 50,
              height: 50,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: avg,
                  itemBuilder: (context, index) {
                    return SvgPicture.asset(
                      "assets/images/star.svg",
                      height: 25,
                      width: 25,
                    );
                  })),
    );
  }
    ProfileListTile postedHouses() {
    return ProfileListTile(
        label: "Posted Houses :",
        content: Text(
          controller.postedHouses.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ));
  }
      ProfileListTile rentedHouses() {
    return ProfileListTile(
        label: "Rented Houses :",
        content: Text(
          controller.rentedHouses.toString(),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ));
  }
  Row phoneNumber() {
    return Row(
      children: [
        SizedBox(
          width: 270,
          child: ProfileListTile(
            label: "Number :",
            content: Text(
              controller.phoneNumber.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 14, 13, 13),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.togglePhoneVisibility();
          },
          child: SvgPicture.asset(
            controller.phoneVisibility.value
                ? "assets/images/visible.svg"
                : "assets/images/not_visible.svg",
            height: 35,
            width: 35,
            color: myPrimaryColor,
          ),
        ),
      ],
    );
  }

  Row city() {
    return Row(
      children: [
        SizedBox(
          width: 270,
          child: ProfileListTile(
            label: "City :",
            content: Text(
              controller.city.value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 14, 13, 13),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.toggleCityVisibility();
          },
          child: SvgPicture.asset(
            controller.cityVisibility.value
                ? "assets/images/visible.svg"
                : "assets/images/not_visible.svg",
            height: 35,
            width: 35,
            color: myPrimaryColor,
          ),
        ),
      ],
    );
  }
}
