// To parse this JSON data, do
//
//     final driverModel = driverModelFromJson(jsonString);

import 'dart:convert';

DriverModel driverModelFromJson(String str) => DriverModel.fromJson(json.decode(str));

String driverModelToJson(DriverModel data) => json.encode(data.toJson());

class DriverModel {
    DriverModel({
        this.id,
        this.displayName,
        this.profilePicture,
        this.age,
        this.rating,
        this.memberDate,
        this.music,
        this.smoke,
        this.funny,
        this.petAllow,
        this.rides,
    });

    int id;
    String displayName;
    String profilePicture;
    int age;
    double rating;
    String memberDate;
    bool music;
    bool smoke;
    bool funny;
    bool petAllow;
    int rides;

    factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        id: json["id"],
        displayName: json["display_name"],
        profilePicture: json["profile_picture"],
        age: json["age"],
        rating: json["rating"],
        memberDate: json["member_date"],
        music: json["music"],
        smoke: json["smoke"],
        funny: json["funny"],
        petAllow: json["pet_allow"],
        rides: json["rides"],
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
