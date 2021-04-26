import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/models/notification/notification.dart';
import 'package:rideon_driver/models/notification/request_notification.dart';
import 'package:rideon_driver/screens/notification/notification.dart';
import 'package:rideon_driver/screens/ride/request/request.dart';
import 'package:rideon_driver/widget/custom_dialog.dart';

import 'notification_service.dart';

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void initFirebase() {
    _firebaseMessaging.configure(onMessage: (dynamic message) async {
      print(message);
      _showNotificationDialog(message);
      _saveNotification(message);
    }, onLaunch: (dynamic message) async {
      _saveNotification(message);
      _openNotification(message);
    }, onResume: (dynamic message) async {
      _saveNotification(message);
      _openNotification(message);
    });

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
    _firebaseMessaging
        .subscribeToTopic("all"); //"to":"topics/all" in firebase body parameter
    _firebaseMessaging
        .subscribeToTopic("ride_request");
  }

  void _showNotificationDialog(message) {
    String title;
    String content;

    if (Platform.isIOS) {
      title = message['aps']["alert"]["title"];
      content = message['aps']["alert"]["body"];
    } else {
      title = message["notification"]["title"];
      content = message["notification"]["body"];
    }

    CustomDialog().showCustomDialog(title: title, content: content, actions: [
      CustomDialog().dialogButton(
        text: 'CLOSE',
        color: Colors.black12,
        onPressed: () {
          Navigator.pop(AppConfig.navigatorKey.currentState.context);
        },
      ),
      CustomDialog().dialogButton(
        text: 'OPEN',
        onPressed: () {
          Navigator.pop(AppConfig.navigatorKey.currentState.context);
          _openNotification(message);
        },
      ),
    ]);
  }

//Notification which type is news are stored locally rest are not
  void _saveNotification(dynamic message) {
    if (Platform.isIOS) {
      if (message["type"] == "news")
        NotificationService().saveNotification(OfflineNotification(
            title: message["title"],
            description: message["message"],
            date: DateTime.now()));
    } else {
      if (message["data"]["type"] == "news")
        NotificationService().saveNotification(OfflineNotification(
            title: message["data"]["title"],
            description: message["data"]["message"],
            image: message["data"]["image"],
            link: message["data"]["link"],
            date: DateTime.now()));
    }
  }

  void _openNotification(Map<String, dynamic> message) {
    if (message['data']['type'] == 'ride_request')
      Navigator.push(
        AppConfig.navigatorKey.currentState.context,
        MaterialPageRoute(
          builder: (context) {
            return RideRequestPage(
              notificationData: RequestNotification.fromJson(message).data,
            );
          },
        ),
      );
    else
      Navigator.push(
        AppConfig.navigatorKey.currentState.context,
        MaterialPageRoute(
          builder: (context) {
            return NotificationScreen();
          },
        ),
      );
  }

  Future<String> getFirebaseToken() {
    Future<String> firebaseToken =
        _firebaseMessaging.getToken().then((value) => value);
    return firebaseToken;
  }
}
