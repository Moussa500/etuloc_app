import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etuloc/components/background.dart';
import 'package:etuloc/components/buttons.dart';
import 'package:etuloc/components/colors.dart';
import 'package:etuloc/components/profile_list_tile.dart';
import 'package:etuloc/components/text.dart';
import 'package:etuloc/components/textfields.dart';
import 'package:etuloc/services/dialog_service.dart';
import 'package:etuloc/services/firebase_storage.dart/firebase_storage.dart';
import 'package:etuloc/services/firestore/firestore.dart';
import 'package:etuloc/services/sncak_bar_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:string_validator/string_validator.dart';
import 'package:svg_flutter/svg.dart';

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});
  @override
  State<StudentProfile> createState() => _StudentProfileState();
}
class _StudentProfileState extends State<StudentProfile> {
  final StorageService _storageService = StorageService();
  String? imagePath;
  XFile? image;
  //name controller
  TextEditingController nameController = TextEditingController();
  //city controller
  TextEditingController cityController = TextEditingController();
  //phone controller
  TextEditingController phoneController = TextEditingController();
  final FireStoreService _fireStoreService = FireStoreService();
  // Boolean variables that can potentially be null
  bool cityVisibility = false; // Initialized as false by default
  bool phoneVisibility = false; // Initialized as false by default
  User currentUser = FirebaseAuth.instance.currentUser!;
  final CollectionReference studentReferenceProfile =
      FirebaseFirestore.instance.collection('studentProfile');
  //edit the user infos
  void editUserInfos() async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final ImagePicker picker = ImagePicker();
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (image != null) {
                          successDialog(context,
                              "Your image has been uploaded successfully");
                        } else {
                          errorDialog(
                              "Error occurred while uploading your image");
                        }
                      },
                      child: Image.asset(
                        "assets/images/upload.png",
                        height: 170,
                        width: 170,
                      ),
                    ),
                    const Text("Tap to upload a StudentProfile picture"),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomTextField(label: 'Name', controller: nameController),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomTextField(label: 'city', controller: cityController),
                    const SizedBox(
                      height: 25,
                    ),
                    CustomTextField(
                        label: 'Phone Number', controller: phoneController),
                    const SizedBox(
                      height: 25,
                    ),
                    MainButton(
                        height: 41,
                        width: 150,
                        label: 'Update',
                        onPressed: () async {
                          bool test = true;
                          //update infos if the user filled the textfields
                          if (cityController.text.isNotEmpty) {
                            setState(() {
                              _fireStoreService.updateInfos('studentProfile',
                                  currentUser.uid, cityController.text, 'city');
                            });
                          }
                          if (nameController.text.isNotEmpty) {
                            //check if it is a valid name
                            if (isAlpha(nameController.text)) {
                              setState(() {
                                _fireStoreService.updateInfos(
                                    'studentProfile',
                                    currentUser.uid,
                                    nameController.text,
                                    'name');
                              });
                              _fireStoreService.updateInfos('user',
                                  currentUser.uid, nameController.text, 'name');
                            } else {
                              SnackBarService.showErrorSnackBar(
                                  "Error", "Please Enter a valid name");
                              test = false;
                            }
                          }
                          if (phoneController.text.isNotEmpty) {
                            //check if it is a valid phone number
                            if (isNumeric(phoneController.text) &&
                                phoneController.text.length == 8) {
                              setState(() {
                                _fireStoreService.updateInfos(
                                    'studentProfile',
                                    currentUser.uid,
                                    phoneController.text,
                                    'phone_number');
                                _fireStoreService.updateInfos(
                                    'user',
                                    currentUser.uid,
                                    phoneController.text,
                                    'phone_number');
                              });
                            } else {
                              SnackBarService.showErrorSnackBar("Error",
                                  "Please Enter a valid phone Number ");
                              test = false;
                            }
                          }
                          if (image != null) {
                            String downloadUrl = await _storageService
                                .uploadImage('images', image!);
                            _fireStoreService.updateInfos('studentProfile',
                                currentUser.uid, downloadUrl.toString(), 'pdp');
                            setState(() {
                              imagePath = downloadUrl.toString();
                            });
                          }
                          if (test) {
                            SnackBarService.showSuccessSnackBar(
                                "Error", "Your Infos updated successfully");
                            Navigator.pop(context);
                          }
                        })
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Background(
        elements: FutureBuilder(
            future: _fireStoreService.getValueFromFirestore(FirebaseFirestore
                .instance
                .collection("studentProfile")
                .doc(currentUser.uid)),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                dynamic value = snapshot.data;
                value["pdp"] == ""
                    ? imagePath = "assets/images/profile.png"
                    : imagePath = value["pdp"];
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                            child: snapshot.connectionState ==
                                    ConnectionState.waiting
                                ? CircularProgressIndicator()
                                : value["pdp"] == ""
                                    ? Image.asset(
                                        imagePath!,
                                        fit: BoxFit.cover,
                                        height: 200,
                                        width: 200,
                                      )
                                    : Container(
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: Image.network(
                                          imagePath!,
                                          fit: BoxFit.cover,
                                          height: 200,
                                          width: 200,
                                        ),
                                      )),
                        const SizedBox(
                          height: 20,
                        ),
                        Header(label: value["name"]),
                        const SizedBox(
                          height: 10,
                        ),
                        phoneNumber(value, phoneVisibility),
                        const SizedBox(
                          height: 10,
                        ),
                        city(value, cityVisibility),
                        MainButton(
                            height: 41,
                            width: 165,
                            label: "Edit",
                            onPressed: editUserInfos)
                      ],
                    ),
                  ),
                );
              } else {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return const Text(
                      "Error occurred while loading StudentProfile data");
                }
              }
            }),
      ),
    );
  }

  //phone number section
  Row phoneNumber(value, bool phoneVisibility) {
    return Row(
      children: [
        SizedBox(
          width: 270,
          child: ProfileListTile(
            label: "Number :",
            content: Text(
              value["phone_number"] ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            setState(() {
              phoneVisibility = !phoneVisibility;
            });
            await _fireStoreService.updateInfos("studentProfile",
                currentUser.uid, phoneVisibility, "phone_visibility");
          },
          child: SvgPicture.asset(
            phoneVisibility
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

  Row city(value, bool cityVisibility) {
    return Row(
      children: [
        SizedBox(
          width: 270,
          child: ProfileListTile(
            label: "city :",
            content: Text(
              value["city"] == "" ? "Not specified" : value["city"] ?? "",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            setState(() {
              cityVisibility = !cityVisibility;
            });
            await _fireStoreService.updateInfos("studentProfile",
                currentUser.uid, cityVisibility, "city_visibility");
          },
          child: SvgPicture.asset(
            cityVisibility
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
