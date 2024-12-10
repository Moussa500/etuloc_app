import 'package:etuloc/components/background.dart';
import 'package:etuloc/components/buttons.dart';
import 'package:etuloc/components/colors.dart';
import 'package:etuloc/components/device_dimensions.dart';
import 'package:etuloc/components/textfields.dart';
import 'package:etuloc/controllers/landlord_controllers.dart/update_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class UpdatePage extends StatelessWidget {
  final String houseId;
  UpdatePage({super.key, required this.houseId});
  UpdateController controller = Get.put(UpdateController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Background(
            elements: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Center(
                  child: Text(
                    "Update",
                    style: TextStyle(
                        fontSize: 40,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 25),
                CustomTextField(
                  customwidth: Dimensions.deviceWidth(context) * .6,
                  label: "Price",
                  controller: controller.priceController,
                ),
                const SizedBox(height: 25),
                rentingTypeSection(context),
                const SizedBox(height: 25),
                genderSection(context),
                const SizedBox(height: 25),
                updateButton(),
              ],
            ),
          ),
        ));
  }

  Container rentingTypeSection(BuildContext context) {
    return Container(
      width: Dimensions.deviceWidth(context) * .6,
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
          width: Dimensions.deviceWidth(context) * .6,
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
      width: Dimensions.deviceWidth(context) * .6,
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
          width: Dimensions.deviceWidth(context) * .6,
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

  Widget updateButton() {
    return Obx(() {
      if (controller.isUpdating.value) {
        return const CircularProgressIndicator();
      } else {
        return MainButton(
          height: 70,
          width: 120,
          label: "Update",
          onPressed: () {
            controller.updateHouse(houseId);
          },
        );
      }
    });
  }
}
