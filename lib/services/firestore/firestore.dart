import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:uuid/uuid.dart';

class FireStoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Uuid uuid = const Uuid();
  // Add user's info to separate document after logging in
  Future<void> saveUsersInfo(String email, String name, String phone,
      String status, String uid) async {
    try {
      await _firestore.collection('user').doc(uid).set({
        "pdp": "",
        "uid": uid,
        "email": email,
        "name": name,
        "phone": phone,
        "status": status,
      });
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      final fCMToken = await messaging.getToken();
      if (status == "landlord") {
        await _firestore.collection("landlordsProfile").doc(uid).set({
          "uid": uid,
          "phone_number": phone,
          "name": name,
          "sum_ratings": 0,
          "phone_visibility": false,
          "city_visibility": false,
          "number_ratings": 0,
          "posted_houses": 0,
          "rented_houses": 0,
          "city": "",
          "pdp": "",
          "token": fCMToken,
        });
      } else {
        await _firestore.collection("studentProfile").doc(uid).set({
          "uid": uid,
          "phone_number": phone,
          "name": name,
          "city_visibility": false,
          "number_ratings": 0,
          "city": "",
          "pdp": "",
        });
      }
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  // Get infos from the firebase
  Future<dynamic> getValueFromFirestore(DocumentReference docRef) async {
    DocumentSnapshot snapshot = await docRef.get();
    return snapshot.exists ? snapshot.data() : null;
  }

  DocumentReference getHouseRef(String houseId) {
    return _firestore.collection("houses").doc(houseId);
  }

  // Update infos
  Future<void> updateInfos(
      String collection, String docId, var newValue, String field) {
    return _firestore.collection(collection).doc(docId).update({
      field: newValue,
    });
  }

  // List messages
  Stream<QuerySnapshot> listMessages(String uid) {
    return _firestore
        .collection("chat_rooms")
        .where("ids", arrayContains: uid)
        .snapshots();
  }

  // Get all the documents from a collection
  Stream<List<Map<String, dynamic>>> getCollectionStream(
      String collectionName) {
    return _firestore.collection(collectionName).snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  // Get chat rooms
  Stream<QuerySnapshot> getChatRooms(String uid) {
    return _firestore
        .collection("chat_rooms")
        .where(
            _firestore
                .collection("chat_rooms")
                .id
                .substring(_firestore.collection("chat_rooms").id.indexOf('_')),
            isEqualTo: uid)
        .snapshots();
  }

  // Get posted houses stream
  Stream<QuerySnapshot> getPostedHousesStream(String uid) {
    return _firestore
        .collection("houses")
        .where('uid', isEqualTo: uid)
        .snapshots();
  }

  // Get housed stream
  Stream<QuerySnapshot> getHousedStream() {
    return _firestore.collection("houses").snapshots();
  }

  // Post a house
  Future<void> postHouse(
      String city,
      String price,
      String url,
      String availablePlaces,
      String location,
      bool bed,
      String type,
      String places,
      String uid,
      String gender) async {
    String documentId = uuid.v4();
    await _firestore.collection("houses").doc(documentId).set({
      "price": price,
      "documentId":documentId,
      "images_url": url,
      "city_name": city,
      "uid": uid,
      "available_places": places,
      "gender": gender,
      "location": location,
      "bed": bed,
      "house": !bed,
      "state": "available",
      "type": type,
      "places": places,
    });
  }

  // Delete house
  Future<void> deleteHouse(String uid) async {
    await _firestore.collection("houses").doc(uid).delete();
  }

  Future<String> getFieldValue(
      String collectionPath, String documentId, String fieldName) async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(documentId)
          .get();
      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey(fieldName)) {
          return data[fieldName].toString();
        } else {
          throw Exception("Field '$fieldName' does not exist in the document.");
        }
      } else {
        throw Exception("Document does not exist.");
      }
    } catch (e) {
      // Handle error (e.g., log it or throw a custom exception)
      rethrow; // Re-throw to allow calling code to handle the error
    }
  }
}
