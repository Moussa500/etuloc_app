import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etuloc/components/device_dimensions.dart';
import 'package:etuloc/components/my_drawer.dart';
import 'package:etuloc/components/student_card.dart';
import 'package:etuloc/components/textfields.dart';
import 'package:etuloc/pages/Etudiant/house_details.dart';
import 'package:etuloc/pages/Etudiant/profile_page.dart';
import 'package:etuloc/stateManagement/search_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class EtudiantHomePage extends StatelessWidget {
  EtudiantHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    var searchTextProvider = Provider.of<SearchTextProvider>(context);
    return SafeArea(
      child: Scaffold(
        drawer: MyDrawer(
          homeTap: () {
            Get.to(EtudiantHomePage());
          },
          profile: const StudentProfile(),
        ),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'E T U L O C',
            style: TextStyle(
              fontFamily: "poppins",
              fontSize: 30,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Center(
                  child: CustomTextField(
                    icon: const Icon(Icons.search),
                    label: 'Search',
                    controller: TextEditingController(
                        text: searchTextProvider.searchText),
                    onChanged: (text) {
                      searchTextProvider.searchText = text;
                    },
                    customwidth: MediaQuery.of(context).size.width * .9,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _getSearchStream(searchTextProvider.searchText),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      if (snapshot.hasData) {
                        final data = snapshot.data!.docs;
                        return Center(
                          child: Container(
                            width: Dimensions.deviceWidth(context),
                            height: Dimensions.deviceHeight(context) * .7,
                            child: ListView.separated(
                              scrollDirection: Axis.vertical,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                height: 10,
                              ),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                List<String> pathList =
                                    data[index]["images_url"].split(',');
                                return StudentCard(
                                  ontap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HouseDetails(
                                          id: data[index].id,
                                        ),
                                      ),
                                    );
                                  },
                                  state: data[index]["state"],
                                  path: pathList[0],
                                  city: data[index]["city_name"].toString(),
                                  gender: data[index]["gender"],
                                  availablePlaces: int.parse(
                                      data[index]["available_places"]),
                                  location: data[index]["location"],
                                  price: int.parse(data[index]["price"]),
                                  bed: data[index]["bed"],
                                  house: data[index]["house"],
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text("There are no houses at the moment"),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> _getSearchStream(String searchText) {
    final collection = FirebaseFirestore.instance.collection('houses');

    if (searchText.isEmpty) {
      return collection.snapshots();
    }

    return collection
        .where('search_field', isGreaterThanOrEqualTo: searchText)
        .where('search_field', isLessThanOrEqualTo: '$searchText\uf8ff')
        .snapshots();
  }
}
