import 'package:easy_debounce/easy_debounce.dart';
import 'package:etuloc/components/buttons.dart';
import 'package:etuloc/components/colors.dart';
import 'package:etuloc/components/device_dimensions.dart';
import 'package:etuloc/components/landlord_card.dart';
import 'package:etuloc/components/my_drawer.dart';
import 'package:etuloc/components/textfields.dart';
import 'package:etuloc/controllers/landlord_controllers.dart/home_page_controller.dart';
import 'package:etuloc/pages/landlord_view/views/post_page.dart';
import 'package:etuloc/pages/landlord_view/views/profile_page.dart';
import 'package:etuloc/pages/landlord_view/views/update_page.dart';
import 'package:etuloc/services/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LandLordHomePage extends StatelessWidget {
  LandLordHomePage({super.key});
  final HomePageController controller = Get.find();
  final FireStoreService fireStoreService = FireStoreService();
  final FireStoreService _fireStoreService = FireStoreService();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            bool houseAdded = await Get.to(PostPage());
            if (houseAdded == true) {
              controller.fetchAllData();
            }
          },
          backgroundColor: myPrimaryColor,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        drawer: MyDrawer(
          homeTap: () {
            Get.back();
          },
          profile: LandLordProfile(),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'E T U L O C',
            style: TextStyle(
                fontFamily: "poppins",
                fontSize: 30,
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Center(
                child: CustomTextField(
                  icon: const Icon(Icons.search),
                  label: 'Search',
                  controller: controller.searchText,
                  onChanged: (text) {
                    EasyDebounce.debounce(
                        'search-result',
                        const Duration(seconds: 1),
                        () => controller.searchFromFirebase());
                  },
                  customwidth: MediaQuery.of(context).size.width * .9,
                ),
              ),
            ),
            const SizedBox(height: 50),
            Obx(() {
              if (controller.isSearching.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (controller.searchResult.isEmpty) {
                return const Center(
                  child: Text("You didn't post any house yet"),
                );
              } else {
                return Center(
                  child: SizedBox(
                    width: Dimensions.deviceWidth(context),
                    height: Dimensions.deviceHeight(context) * .7,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: controller.searchResult.length,
                      itemBuilder: (context, index) {
                        List<String> pathList = controller.searchResult[index]
                                ["images_url"]
                            .split(',');
                        return LandLordCard(
                          onEdit: () async {
                            bool isUpdated = await Get.to(() => UpdatePage(
                                houseId: controller.searchResult[index]
                                    ["documentId"]));
                            if (isUpdated) {
                              controller.fetchAllData();
                            }
                          },
                          ontap: () async {
                            Get.dialog(
                              AlertDialog(
                                content: const Text(
                                  "Are you sure ?",
                                  style: TextStyle(
                                    fontFamily: "poppins",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                actions: [
                                  controller.isRemoving.value == true
                                      ? const CircularProgressIndicator()
                                      : MainButton(
                                          height: 50,
                                          width: 75,
                                          label: "Yes",
                                          onPressed: () {
                                            controller.deleteHouse(
                                                controller.searchResult[index]
                                                    ["documentId"],
                                                index);
                                          },
                                        ),
                                  MainButton(
                                    height: 50,
                                    width: 75,
                                    label: "No",
                                    onPressed: () => Get.back(),
                                  ),
                                ],
                              ),
                            );
                          },
                          state: controller.searchResult[index]["state"],
                          path: pathList[0],
                          city: controller.searchResult[index]["city_name"],
                          gender: controller.searchResult[index]["gender"],
                          availablePlaces: int.parse(controller
                              .searchResult[index]["available_places"]),
                          location: controller.searchResult[index]["location"],
                          price: int.parse(
                              controller.searchResult[index]["price"]),
                          bed: controller.searchResult[index]["bed"],
                          house: controller.searchResult[index]["house"],
                        );
                      },
                    ),
                  ),
                );
              }
            }),
          ]),
        ),
      ),
    );
  }
}
