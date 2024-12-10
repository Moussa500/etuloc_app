// post_house_page.dart
import 'package:etuloc/components/background.dart';
import 'package:etuloc/components/buttons.dart';
import 'package:etuloc/components/colors.dart';
import 'package:etuloc/components/device_dimensions.dart';
import 'package:etuloc/components/textfields.dart';
import 'package:etuloc/controllers/landlord_controllers.dart/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:svg_flutter/svg_flutter.dart';

class PostPage extends StatelessWidget {
  PostPage({super.key});
  final PostController controller = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Post House"),
        ),
        body: SingleChildScrollView(
          child: Background(
            elements: FittedBox(
              child: Column(
                children: [
                  SizedBox(
                      height: 170,
                      width: 170,
                      child: GestureDetector(
                          onTap: ()=>controller.pickImages(),
                          child: Image.asset("assets/images/upload.png"))),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text("Click here to upload images"),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                    label: "Price",
                    controller: controller.priceController,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  locationSection(),
                  const SizedBox(
                    height: 25,
                  ),
                  typeSection(context),
                  const SizedBox(
                    height: 25,
                  ),
                  genderSection(context),
                  const SizedBox(
                    height: 25,
                  ),
                  rentingTypeSection(context),
                  const SizedBox(
                    height: 25,
                  ),
                  placesNumberSection(context),
                  const SizedBox(
                    height: 25,
                  ),
                  postButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Container placesNumberSection(BuildContext context) {
    return Container(
      width: Dimensions.deviceWidth(context) * .7,
      decoration: BoxDecoration(
        color: myBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        border: Border.all(style: BorderStyle.none),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 3), blurRadius: 6, color: myShadowColor),
        ],
      ),
      child: DropdownMenu(
          controller: controller.placesNumberController,
          enableSearch: true,
          hintText: "Number of places",
          width: Dimensions.deviceWidth(context) * .65,
          menuHeight: 100,
          inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(25)))),
          dropdownMenuEntries: const <DropdownMenuEntry>[
            DropdownMenuEntry(value: 1, label: "1"),
            DropdownMenuEntry(value: 2, label: "2"),
            DropdownMenuEntry(value: 3, label: "3"),
            DropdownMenuEntry(value: 4, label: "4"),
          ]),
    );
  }

  Padding locationSection() {
    return Padding(
      padding: const EdgeInsets.only(left: 46),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(
            label: "Location",
            controller: controller.locationController,
          ),
          const SizedBox(
            width: 5,
          ),
          Obx(
            () => locate(),
          ),
        ],
      ),
    );
  }

  Widget locate() {
    return GestureDetector(
        onTap: () {
          controller.locate();
        },
        child: controller.isGettingLocation.value == false
            ? SvgPicture.asset(
                "assets/images/map.svg",
                height: 40,
                width: 40,
                // ignore: deprecated_member_use
                color: myPrimaryColor,
              )
            : const CircularProgressIndicator());
  }

  Container rentingTypeSection(BuildContext context) {
    return Container(
      width: Dimensions.deviceWidth(context) * .7,
      decoration: BoxDecoration(
        color: myBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        border: Border.all(style: BorderStyle.none),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 3), blurRadius: 6, color: myShadowColor),
        ],
      ),
      child: DropdownMenu(
          controller: controller.rentTypeController,
          enableSearch: true,
          hintText: "Renting Type",
          width: Dimensions.deviceWidth(context) * .65,
          menuHeight: 100,
          inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(25)))),
          dropdownMenuEntries: const <DropdownMenuEntry>[
            DropdownMenuEntry(value: "House", label: "House"),
            DropdownMenuEntry(value: "Bed", label: "Bed"),
          ]),
    );
  }

  Container genderSection(BuildContext context) {
    return Container(
      width: Dimensions.deviceWidth(context) * .7,
      decoration: BoxDecoration(
        color: myBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        border: Border.all(style: BorderStyle.none),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 3), blurRadius: 6, color: myShadowColor),
        ],
      ),
      child: DropdownMenu(
          controller: controller.genderController,
          enableSearch: true,
          hintText: "Gender",
          width: Dimensions.deviceWidth(context) * .65,
          menuHeight: 100,
          inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(25)))),
          dropdownMenuEntries: const <DropdownMenuEntry>[
            DropdownMenuEntry(value: "Female", label: "Female"),
            DropdownMenuEntry(value: "Male", label: "Male"),
          ]),
    );
  }

  Container typeSection(BuildContext context) {
    return Container(
      width: Dimensions.deviceWidth(context) * .7,
      decoration: BoxDecoration(
        color: myBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        border: Border.all(style: BorderStyle.none),
        boxShadow: const [
          BoxShadow(offset: Offset(0, 3), blurRadius: 6, color: myShadowColor),
        ],
      ),
      child: DropdownMenu(
          controller: controller.typeController,
          enableSearch: true,
          hintText: "Type",
          width: Dimensions.deviceWidth(context) * .65,
          menuHeight: 100,
          inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500),
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(25)))),
          dropdownMenuEntries: const <DropdownMenuEntry>[
            DropdownMenuEntry(value: "s+1", label: "s+1"),
            DropdownMenuEntry(value: "s+2", label: "s+2"),
            DropdownMenuEntry(value: "s+3", label: "s+3"),
          ]),
    );
  }

  Widget postButton() {
    return Obx(() {
      if (controller.isPosting.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Center(
          child: MainButton(
              height: 75,
              width: 100,
              label: "Post",
              onPressed: () => controller.post()),
        );
      }
    });
  }
}
