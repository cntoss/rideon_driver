// To parse this JSON data, do
//
//     final requestNotification = requestNotificationFromJson(jsonString);

import 'dart:convert';

import 'package:rideon_driver/models/googleModel/GeocodingModel.dart';

RequestNotification requestNotificationFromJson(String str) => RequestNotification.fromJson(json.decode(str));

String requestNotificationToJson(RequestNotification data) => json.encode(data.toJson());

class RequestNotification {
    RequestNotification({
        this.notification,
        this.data,
    });

    NotificationHeader notification;
    NotificationData data;

    factory RequestNotification.fromJson(Map<dynamic, dynamic> json) => RequestNotification(
        notification: NotificationHeader.fromJson(json["notification"]),
        data: NotificationData.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "notification": notification.toJson(),
        "data": data.toJson(),
    };
}

class NotificationData {
    NotificationData({
        this.clickAction,
        this.message,
        this.type,
        this.title,
        this.fromLocation,
        this.toLocation,
        this.time,
        this.distance,
        this.id,
    });

    String clickAction;
    String message;
    String type;
    String title;
    LocationDetail fromLocation;
    LocationDetail toLocation;
    String time;
    String distance;
    String id;

    factory NotificationData.fromJson(Map<dynamic, dynamic> data) => NotificationData(
        clickAction: data["click_action"],
        message: data["message"],
        type: data["type"],
        title: data["title"],
        fromLocation: LocationDetail.fromJson(json.decode(data["from_location"])),
        toLocation: LocationDetail.fromJson(json.decode(data["to_location"])),
        time: data["time"],
        distance: data["distance"],
        id: data["id"],
    );

    Map<String, dynamic> toJson() => {
        "click_action": clickAction,
        "message": message,
        "type": type,
        "title": title,
        "from_location": fromLocation,
        "to_location": toLocation,
        "time": time,
        "distance": distance,
        "id": id,
    };
}

class NotificationHeader {
    NotificationHeader({
        this.title,
        this.body,
        this.sound,
    });

    String title;
    String body;
    String sound;

    factory NotificationHeader.fromJson(Map<dynamic, dynamic> json) => NotificationHeader(
        title: json["title"],
        body: json["body"],
        sound: json["sound"],
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "sound": sound,
    };
}
