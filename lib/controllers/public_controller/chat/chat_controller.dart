import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etuloc/services/firestore/firestore.dart';
import 'package:get/get.dart';

class MessagerController extends GetxController {
  final String uid;
  MessagerController({required this.uid});
  final FireStoreService fireStoreService=FireStoreService();
  List messages = [];
  void fetchAllChats() async {
    final result = await FirebaseFirestore.instance
        .collection("chat_rooms")
        .where("ids", arrayContains: uid)
        .get();
    messages = result.docs.map((e) => e.data()).toList();
    update();
  }
  String otherUserName = '';
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchAllChats();
  }

  void getSendersNames({required String otherUserID}) {
    
  }
}
