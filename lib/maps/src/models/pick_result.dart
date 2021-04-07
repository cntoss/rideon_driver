import 'package:rideon_driver/maps/web_service/geocoding.dart';
import 'package:rideon_driver/maps/web_service/places.dart';

class PickResult {
  PickResult({
    this.placeId,
    this.geometry,
    this.formattedAddress,
    this.types,
    this.addressComponents,
    this.adrAddress,
    this.id,
    this.reference,
    this.icon,
    this.name,
    this.scope,
    this.vicinity,
    this.utcOffset,
  });

  final String placeId;
  final Geometry geometry;
  final String formattedAddress;
  final List<String> types;
  final List<AddressComponent> addressComponents;

  // Below results will not be fetched if 'usePlaceDetailSearch' is set to false (Defaults to false).
  final String adrAddress;
  final String id;
  final String reference;
  final String icon;
  final String name;
  final String scope;
  final String vicinity;
  final num utcOffset;

  factory PickResult.fromGeocodingResult(GeocodingResult result) {
    return PickResult(
      placeId: result.placeId,
      geometry: result.geometry,
      formattedAddress: result.formattedAddress,
      types: result.types,
      addressComponents: result.addressComponents,
    );
  }

  factory PickResult.fromPlaceDetailResult(PlaceDetails result) {
    return PickResult(
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
}
