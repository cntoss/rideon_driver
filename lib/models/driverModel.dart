// To parse this JSON data, do
//
//     final driverModel = driverModelFromJson(jsonString);

import 'dart:convert';

DriverModel driverModelFromJson(String str) =>
    DriverModel.fromJson(json.decode(str));

String driverModelToJson(DriverModel data) => json.encode(data.toJson());

class DriverModel {
  DriverModel({
    required this.id,
    required this.displayName,
    this.profilePicture,
    required this.age,
    required this.rating,
    required this.memberDate,
    required this.music,
    required this.smoke,
    required this.funny,
    required this.petAllow,
    required this.rides,
  });

  int id;
  String displayName;
  String? profilePicture;
  int age;
  double rating;
  String memberDate;
  bool music;
  bool smoke;
  bool funny;
  bool petAllow;
  int rides;

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        id: json["_id"],
        displayName: json["display_name"],
        profilePicture: json["profile_picture"] ?? '',
        age: json["age"] ?? 0,
        rating: json["rating"] ?? 3,
        memberDate: json["member_date"],
        music: json["music"] ?? true,
        smoke: json["smoke"] ?? false,
        funny: json["funny"] ?? true,
        petAllow: json["pet_allow"] ?? false,
        rides: json["rides"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "display_name": displayName,
        "profile_picture": profilePicture,
        "age": age,
        "rating": rating,
        "member_date": memberDate,
        "music": music,
        "smoke": smoke,
        "funny": funny,
        "pet_allow": petAllow,
        "rides": rides,
      };
}
