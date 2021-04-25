// To parse this JSON data, do
//
//     final notification = notificationFromJson(jsonfinal);

//import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:rideon_driver/config/appConfig.dart';

part 'notification.g.dart';
//List<Notification> notificationFromJson(final str) => List<Notification>.from(json.decode(str).map((x) => Notification.fromJson(x)));

//final notificationToJson(List<Notification> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
@HiveType(typeId: htNotification)
class OfflineNotification extends HiveObject {
  
  @HiveField(0)
  String id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  DateTime date;
  @HiveField(4)
  String image;
  @HiveField(5)
  String link;

   OfflineNotification({
    this.id,
    this.title,
    this.description,
    this.date,
    this.image,
    this.link,
  });
}

/* class Notification {
  const Notification({
    this.id,
    @required this.title,
    @required this.description,
    this.date,
    this.image,
    this.link,
  });

  final id;
  final title;
  final description;
  final DateTime date;
  final image;
  final link;

/*     factory Notification.fromJson(Map<final, dynamic> json) => Notification(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        date: json["date"],
        image: json["image"],
        link: json["link"],
    );

    Map<final, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "date": date,
        "image": image,
        "link": link,
    };
 */
}

const notifications = [
  Notification(
      title: 'Hello message',
      description:
          'In information technology, a notification system is a combination of software and hardware that provides a means of delivering a message to a set of recipients.',
      image:
          'https://miro.medium.com/max/765/1*tsToDy7vp-D6MGlAq1izOw.jpeg',
      link:
          'https://www.online-tech-tips.com/smartphones/how-to-get-your-android-devices-notifications-on-your-computer/'),
  Notification(
      title: 'Holiday Message',
      description: 'A day on which one is exempt from work specifically',
      link: 'https://www.merriam-webster.com/dictionary/holiday'),
  Notification(
      title: 'No link and image',
      description: "In this notification we provide no link and no image")
];
 */