import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:etuloc/main.dart';
import 'package:etuloc/services/firestore/firestore.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class NotifcationService {
  FireStoreService _fireStoreService = FireStoreService();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  //init notification
  Future<void> initNotifications() async {
    //request permission from user
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
    //fetch the fcm token for this device
    final fCMToken = await messaging.getToken();
    //print the token
    print("token $fCMToken");
    initPushNotifications();
  }
  //function to handle received messages
  void handleNotification(RemoteMessage? message) {
    //if the message is null, do nothing
    if (message == null) {
      return;
    }
    //navigate to new screen when message is received and user taps notification
    navigatorKey.currentState?.pushNamed(
      'notification',
      arguments: message,
    );
  }
  //funcation to initialize background settings
  Future initPushNotifications() async {
    //handle notification if the app was terminated and not open
    messaging.getInitialMessage().then(handleNotification);
    //attach event listeners for when a notification opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleNotification);
  }
}
