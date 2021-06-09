// To parse this JSON data, do
//
//     final geocodingModel = geocodingModelFromJson(jsonString);

import 'dart:convert';
import 'package:rideon_driver/maps/google_maps_place_picker.dart';
import 'package:rideon_driver/maps/web_service/places.dart';

GeocodingModel geocodingModelFromJson(String str) =>
    GeocodingModel.fromJson(json.decode(str));

String geocodingModelToJson(GeocodingModel data) => json.encode(data.toJson());

class GeocodingModel {
  GeocodingModel({
    this.plusCode,
    this.results,
    this.status,
  });

  PlusCode? plusCode;
  List<LocationDetail>? results;
  String? status;

  factory GeocodingModel.fromJson(Map<String, dynamic> json) => GeocodingModel(
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
        results: List<LocationDetail>.from(
            json["results"].map((x) => LocationDetail.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "plus_code": plusCode?.toJson(),
        "results": List<dynamic>.from(results!.map((x) => x.toJson())),
        "status": status,
      };
}

class PlusCode {
  PlusCode({
    this.compoundCode,
    this.globalCode,
  });

  String? compoundCode;
  String? globalCode;

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
        compoundCode: json["compound_code"],
        globalCode: json["global_code"],
      );

  Map<String, dynamic> toJson() => {
        "compound_code": compoundCode,
        "global_code": globalCode,
      };
}

class LocationDetail {
  LocationDetail({
    this.addressComponents,
    this.formattedAddress,
    this.geometry,
    this.placeId,
    this.types,
    this.plusCode,
    this.adrAddress,
    this.id,
    this.reference,
    this.icon,
    this.name,
    this.scope,
    this.vicinity,
    this.utcOffset,
  });

  List<AddressComponent>? addressComponents;
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;
  List<String>? types;
  PlusCode? plusCode;

  // Below results will not be fetched if 'usePlaceDetailSearch' is set to false (Defaults to false).
  final String? adrAddress;
  final String? id;
  final String? reference;
  final String? icon;
  final String? name;
  final String? scope;
  final String? vicinity;
  final num? utcOffset;

  factory LocationDetail.fromJson(Map<String, dynamic> json) => LocationDetail(
        addressComponents: List<AddressComponent>.from(
            json["address_components"]
                .map((x) => AddressComponent.fromJson(x))),
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
        types: json["types"] == null
            ? null
            : List<String>.from(json["types"].map((x) => x)),
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
      );

  factory LocationDetail.fromPlaceDetailResult(PlaceDetails result) {
    return LocationDetail(
      placeId: result.placeId,
      geometry: result.geometry,
      formattedAddress: result.formattedAddress,
      types: result.types,
      addressComponents: result.addressComponents,
      adrAddress: result.adrAddress,
      id: result.id,
      reference: result.reference,
      icon: result.icon,
      name: result.name,
      scope: result.scope,
      vicinity: result.vicinity,
      utcOffset: result.utcOffset,
    );
  }

  factory LocationDetail.fromPickResult(PickResult result) {
    return LocationDetail(
      placeId: result.placeId,
      geometry: result.geometry,
      formattedAddress: result.formattedAddress,
      types: result.types,
      addressComponents: result.addressComponents,
      adrAddress: result.adrAddress,
      id: result.id,
      reference: result.reference,
      icon: result.icon,
      name: result.name,
      scope: result.scope,
      vicinity: result.vicinity,
      utcOffset: result.utcOffset,
    );
  }

  Map<String, dynamic> toJson() => {
        "address_components":
            List<dynamic>.from(addressComponents!.map((x) => x.toJson())),
        "formatted_address": formattedAddress,
        "location": {
          "type": "Point",
          "coordinates": [geometry!.location.lng, geometry!.location.lat]
        },
        "place_id": placeId,
      };
}
