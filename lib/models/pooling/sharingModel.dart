// To parse this JSON data, do
//
//     final sharingModel = sharingModelFromJson(jsonString);

import 'dart:convert';

List<SharingModel> sharingModelFromJson(String str) => List<SharingModel>.from(json.decode(str).map((x) => SharingModel.fromJson(x)));

String sharingModelToJson(List<SharingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SharingModel {
    SharingModel({
        this.id,
        this.fromLocation,
        this.fromLocationId,
        this.toLocation,
        this.toLocationId,
        this.passenger,
        this.cost,
        this.date,
        this.time,
        this.phoneNumber,
        this.email,
    });

    int id;
    String fromLocation;
    int fromLocationId;
    String toLocation;
    int toLocationId;
    int passenger;
    int cost;
    DateTime date;
    String time;
    int phoneNumber;
    String email;

    factory SharingModel.fromJson(Map<String, dynamic> json) => SharingModel(
        id: json["id"],
        fromLocation: json["fromLocation"],
        fromLocationId: json["fromLocationId"],
        toLocation: json["toLocation"],
        toLocationId: json["toLocationId"],
        passenger: json["passenger"],
        cost: json["cost"],
        date: json["date"],
        time: json["time"],
        phoneNumber: json["phoneNumber"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fromLocation": fromLocation,
        "fromLocationId": fromLocationId,
        "toLocation": toLocation,
        "toLocationId": toLocationId,
        "passenger": passenger,
        "cost": cost,
        "date": date,
        "time": time,
        "phoneNumber": phoneNumber,
        "email": email,
    };
}
