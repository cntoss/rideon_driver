// To parse this JSON data, do
//
//     final location = locationFromJson(jsonString);

import 'dart:convert';

LocationModel locationFromJson(String str) =>
    LocationModel.fromJson(json.decode(str));

String locationToJson(LocationModel data) => json.encode(data.toJson());

class MapModel {
  MapModel({this.name, this.id, this.locationModel});
  
  String name;
  String id;
  LocationModel locationModel;
}

class LocationModel {
  LocationModel({
    this.lat,
    this.lng,
  });

  double lat;
  double lng;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };

    factory LocationModel.fromGeomerty(lat, lng) {
    return LocationModel(
      lat: lat,
      lng: lng,
    );
  }
}
