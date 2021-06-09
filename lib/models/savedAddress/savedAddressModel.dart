// To parse this JSON data, do
//
//     final savedAddressModel = savedAddressModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/maps/google_maps_place_picker.dart';
import 'package:rideon_driver/models/savedAddress/addressType.dart';

part 'savedAddressModel.g.dart';

List<SavedAddressModel> savedAddressModelFromJson(String str) =>
    List<SavedAddressModel>.from(
        json.decode(str).map((x) => SavedAddressModel.fromJson(x)));

String savedAddressModelToJson(List<SavedAddressModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@HiveType(typeId: htSavedAddress)
class SavedAddressModel extends HiveObject {
  SavedAddressModel({
    this.id,
    this.type,
    this.placeId,
    this.location,    
    this.locationName, 
    this.detail   
  });

  @HiveField(0)
  String? id;

  @HiveField(1)
  AddressType? type;

  @HiveField(2)
  String? placeId;

  @HiveField(3)
  LnModel? location;

  @HiveField(4)
  String? locationName;

   @HiveField(5)
  String? detail;

  factory SavedAddressModel.fromJson(Map<String, dynamic> json) =>
      SavedAddressModel(
        id: json['id'],
        //type: json["type"],
        //location: LocationModel.fromJson(json["location"]),
        locationName: json["locationName"],
      );

factory SavedAddressModel.fromPickResult(PickResult result) {
    return SavedAddressModel(
      placeId: result.placeId,
      location: LnModel.fromGeomerty(result.geometry!.location.lat,result.geometry!.location.lng),
      locationName: result.formattedAddress,
      //types: result.types,
      //adrAddress: result.adrAddress,
      //name: result.name,
      );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "location": location,
        "locationName": locationName,
      };
}

@HiveType(typeId: htlnModel)
class LnModel extends HiveObject {
  LnModel({
    required this.lat,
    required this.lng,
  });
  @HiveField(0)
  double lat;

  @HiveField(1)
  double lng;

  factory LnModel.fromJson(Map<String, dynamic> json) => LnModel(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };

    factory LnModel.fromGeomerty(lat, lng) {
    return LnModel(
      lat: lat,
      lng: lng,
    );
  }
}