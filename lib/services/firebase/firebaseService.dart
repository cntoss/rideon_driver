import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';

class FirebaseService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  void initFirebase() {
    _firebaseMessaging.configure(onMessage: (dynamic message) async {
      print(message);
      _showNotificationDialog(message);
    }, onLaunch: (dynamic message) async {
      _showNotificationDialog(message, isBackground: true);
    }, onResume: (dynamic message) async {
      _showNotificationDialog(message, isBackground: true);
    });

    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {});
    _firebaseMessaging.subscribeToTopic("notification");
  }

  void _showNotificationDialog(dynamic message, {bool isBackground = false}) {
    String title;
    String content;

    if (Platform.isIOS) {
      title =
          !isBackground ? message['aps']['alert']["title"] : message["title"];

      content =
          !isBackground ? message['aps']['alert']["body"] : message['message'];
    } else {
      title = !isBackground
          ? message["notification"]["title"]
          : message["data"]["title"];
      content = !isBackground
          ? message["notification"]["body"]
          : message['data']['message'];
    }

    showDialog(
        barrierDismissible: false,
        context: AppConfig.navigatorKey.currentState.context,
        builder: (context) {
          return AlertDialog(
            title: Text(title ?? ' '),
            content: Text(content ?? ' '),
            actionsPadding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width / 2 - 50 * 2),
            actions: <Widget>[
              Center(
                child: FlatButton(
                  child: Text('OK',
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              )
            ],
          );
        });
  }

  Future<String> getFirebaseToken() {
    Future<String> firebaseToken =
        _firebaseMessaging.getToken().then((value) => value);
    return firebaseToken;
  }
}
