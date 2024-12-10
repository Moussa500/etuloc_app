import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etuloc/services/firestore/firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentHomePageController extends GetxController {
  List searchResult = [].obs;
  RxBool isSearching = false.obs;
  TextEditingController searchText = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllData();
  }

  FireStoreService fireStoreService = FireStoreService();
  void searchFromFirebase() async {
    if (searchText.text.isEmpty) {
      fetchAllData();
    } else {
      if (searchText.text.isNumericOnly) {
        searchByPrice();
      } else if (searchText.text == "Male" || searchText.text == "Female") {
        searchByGender();
      } else if (searchText.text.isAlphabetOnly) {
        searchByCityName();
      } else {
        searchByType();
      }
    }
  }

  void fetchAllData() async {
    try {
      isSearching.value = true;
      final result =
          await FirebaseFirestore.instance.collection("houses").get();
      searchResult = result.docs.map((e) => e.data()).toList();
    } catch (e) {
      print("Error Fetching data : $e");
    } finally {
      isSearching.value = false;
    }
  }

  void searchByCityName() async {
    try {
      isSearching.value = true;
      final result = await FirebaseFirestore.instance
          .collection("houses")
          .where("city_name", isEqualTo: searchText.text)
          .get();
      searchResult = result.docs.map((e) => e.data()).toList();
    } catch (e) {
      print("Error searching by cityName : $e");
    } finally {
      isSearching.value = false;
    }
  }
  void searchByPrice() async {
    try {
      isSearching.value = true;
      final result = await FirebaseFirestore.instance
          .collection("houses")
          .where("price", isEqualTo: searchText.text)
          .get();
      print("List $searchResult");
      searchResult.assignAll(result.docs.map((e) => e.data()).toList());
      update();
    } catch (e) {
      print("Error searching by price $e");
    } finally {
      isSearching.value = false;
    }
  }

  void searchByGender() async {
    try {
      isSearching.value = true;
      final result = await FirebaseFirestore.instance
          .collection("houses")
          .where("gender", isEqualTo: searchText.text)
          .get();
      searchResult = result.docs.map((e) => e.data()).toList();
    } catch (e) {
      print("Error searching by gender : $e");
    } finally {
      isSearching.value = false;
    }
  }

  void searchByType() async {
    try {
      isSearching.value = true;
      final result = await FirebaseFirestore.instance
          .collection("houses")
          .where("type", isEqualTo: searchText.text)
          .get();
      searchResult = result.docs.map((e) => e.data()).toList();
    } catch (e) {
      print("Error searching by by Type : $e");
    } finally {
      isSearching.value = false;
    }
  }

}
