import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderName;
  final String senderID;
  final String receiverID;
  final String message;
  final Timestamp timestamp;
  Message(
      {
      required this.senderName,
      required this.senderID,
      required this.receiverID,
      required this.message,
      required this.timestamp});
  //convert to a map
  Map<String, dynamic> toMap() {
    return {
      'SenderName': senderName,
      'senderID': senderID,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
