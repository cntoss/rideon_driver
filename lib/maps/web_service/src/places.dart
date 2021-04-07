library google_maps_webservice.places.src;

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

import 'core.dart';
import 'utils.dart';

const _placesUrl = '/place';
const _nearbySearchUrl = '/nearbysearch/json';
const _textSearchUrl = '/textsearch/json';
const _detailsSearchUrl = '/details/json';
const _autocompleteUrl = '/autocomplete/json';
const _queryAutocompleteUrl = '/queryautocomplete/json';

/// https://developers.google.com/places/web-service/
class GoogleMapsPlaces extends GoogleWebService {
  GoogleMapsPlaces({
    String apiKey,
    String baseUrl,
    Client httpClient,
    Map<String, dynamic> apiHeaders,
  }) : super(
          apiKey: apiKey,
          baseUrl: baseUrl,
          url: _placesUrl,
          httpClient: httpClient,
          apiHeaders: apiHeaders,
        );

  Future<PlacesSearchResponse> searchNearbyWithRadius(
    Location location,
    num radius, {
    String type,
    String keyword,
    String language,   
    String name,
    String pagetoken,
  }) async {
    final url = buildNearbySearchUrl(
      location: location,
      language: language,
      radius: radius,
      type: type,
      keyword: keyword,     
      name: name,
      pagetoken: pagetoken,
    );
    return _decodeSearchResponse(await doGet(url, headers: apiHeaders));
  }

  Future<PlacesSearchResponse> searchNearbyWithRankBy(
    Location location,
    String rankby, {
    String type,
    String keyword,
    String language,    
    String name,
    String pagetoken,
  }) async {
    final url = buildNearbySearchUrl(
      location: location,
      language: language,
      type: type,
      rankby: rankby,
      keyword: keyword,     
      name: name,
      pagetoken: pagetoken,
    );
    return _decodeSearchResponse(await doGet(url, headers: apiHeaders));
  }

  Future<PlacesSearchResponse> searchByText(
    String query, {
    Location location,
    num radius,
   
    bool opennow,
    String type,
    String pagetoken,
    String language,
    String region,
  }) async {
    final url = buildTextSearchUrl(
      query: query,
      location: location,
      language: language,
      region: region,
      type: type,
      radius: radius,     
      pagetoken: pagetoken,
    );
    return _decodeSearchResponse(await doGet(url, headers: apiHeaders));
  }

  Future<PlacesDetailsResponse> getDetailsByPlaceId(String placeId,
      {String sessionToken,
      List<String> fields,
      String language,
      String region}) async {
    final url = buildDetailsUrl(
      placeId: placeId,
      sessionToken: sessionToken,
      fields: fields,
      language: language,
      region: region,
    );
    return _decodeDetailsResponse(await doGet(url, headers: apiHeaders));
  }

  @deprecated
  Future<PlacesDetailsResponse> getDetailsByReference(
    String reference, {
    String sessionToken,
    List<String> fields,
    String language,
  }) async {
    final url = buildDetailsUrl(
      reference: reference,
      sessionToken: sessionToken,
      fields: fields,
      language: language,
    );
    return _decodeDetailsResponse(await doGet(url, headers: apiHeaders));
  }

  Future<PlacesAutocompleteResponse> autocomplete(
    String input, {
    String sessionToken,
    num offset,
    Location origin,
    Location location,
    num radius,
    String language,
    List<String> types,
    List<Component> components,
    bool strictbounds,
    String region,
  }) async {
    final url = buildAutocompleteUrl(
      sessionToken: sessionToken,
      input: input,
      origin: origin,
      location: location,
      offset: offset,
      radius: radius,
      language: language,
      types: types,
      components: components,
      strictbounds: strictbounds,
      region: region,
    );
    return _decodeAutocompleteResponse(await doGet(url, headers: apiHeaders));
  }

  Future<PlacesAutocompleteResponse> queryAutocomplete(
    String input, {
    num offset,
    Location location,
    num radius,
    String language,
  }) async {
    final url = buildQueryAutocompleteUrl(
      input: input,
      location: location,
      offset: offset,
      radius: radius,
      language: language,
    );
    return _decodeAutocompleteResponse(await doGet(url, headers: apiHeaders));
  }

  String buildNearbySearchUrl({
    Location location,
    num radius,
    String type,
    String keyword,
    String language,
    String name,
    String rankby,
    String pagetoken,
  }) {
    if (radius != null && rankby != null) {
      throw ArgumentError(
          "'rankby' must not be included if 'radius' is specified.");
    }

    if (rankby == 'distance' &&
        keyword == null &&
        type == null &&
        name == null) {
      throw ArgumentError(
          "If 'rankby=distance' is specified, then one or more of 'keyword', 'name', or 'type' is required.");
    }

    final params = {
      'location': location,
      'radius': radius,
      'language': language,
      'type': type,
      'keyword': keyword,     
      'name': name,
      'rankby': rankby,
      'pagetoken': pagetoken,
    };

    if (apiKey != null) {
      params.putIfAbsent('key', () => apiKey);
    }

    return '$url$_nearbySearchUrl?${buildQuery(params)}';
  }

  String buildTextSearchUrl({
    String query,
    Location location,
    num radius,
    String type,
    String pagetoken,
    String language,
    String region,
  }) {
    final params = {
      'query': query != null ? Uri.encodeComponent(query) : null,
      'language': language,
      'region': region,
      'location': location,
      'radius': radius,      
      'type': type,
      'pagetoken': pagetoken,
    };

    if (apiKey != null) {
      params.putIfAbsent('key', () => apiKey);
    }

    return '$url$_textSearchUrl?${buildQuery(params)}';
  }

  String buildDetailsUrl({
    String placeId,
    String reference,
    String sessionToken,
    String language,
    List<String> fields,
    String region,
  }) {
    if (placeId != null && reference != null) {
      throw ArgumentError("You must supply either 'placeid' or 'reference'");
    }

    final params = {
      'placeid': placeId,
      'reference': reference,
      'language': language,
      'region': region,
    };

    if (fields?.isNotEmpty == true) {
      params['fields'] = fields.join(',');
    }

    if (sessionToken != null) {
      params.putIfAbsent('sessiontoken', () => sessionToken);
    }

    if (apiKey != null) {
      params.putIfAbsent('key', () => apiKey);
    }

    return '$url$_detailsSearchUrl?${buildQuery(params)}';
  }

  String buildAutocompleteUrl({
    String input,
    String sessionToken,
    num offset,
    Location origin,
    Location location,
    num radius,
    String language,
    List<String> types,
    List<Component> components,
    bool strictbounds,
    String region,
  }) {
    final params = {
      'input': input != null ? Uri.encodeComponent(input) : null,
      'language': language,
      'origin': origin,
      'location': location,
      'radius': radius,
      'types': types,
      'components': components,
      'strictbounds': strictbounds,
      'offset': offset,
      'region': region,
    };
    if (apiKey != null) {
      params.putIfAbsent('key', () => apiKey);
    }
    if (sessionToken != null) {
      params.putIfAbsent('sessiontoken', () => sessionToken);
    }
    return '$url$_autocompleteUrl?${buildQuery(params)}';
  }

  String buildQueryAutocompleteUrl({
    String input,
    num offset,
    Location location,
    num radius,
    String language,
  }) {
    final params = {
      'input': input != null ? Uri.encodeComponent(input) : null,
      'language': language,
      'location': location,
      'radius': radius,
      'offset': offset,
    };

    if (apiKey != null) {
      params.putIfAbsent('key', () => apiKey);
    }

    return '$url$_queryAutocompleteUrl?${buildQuery(params)}';
  }

 PlacesSearchResponse _decodeSearchResponse(Response res) =>
      PlacesSearchResponse.fromJson(json.decode(res.body));

  PlacesDetailsResponse _decodeDetailsResponse(Response res) =>
      PlacesDetailsResponse.fromJson(json.decode(res.body));

  PlacesAutocompleteResponse _decodeAutocompleteResponse(Response res) =>
      PlacesAutocompleteResponse.fromJson(json.decode(res.body));
}

class PlacesSearchResponse extends GoogleResponseList<PlacesSearchResult> {
  /// JSON html_attributions
  final List<String> htmlAttributions;

  /// JSON next_page_token
  final String nextPageToken;

  PlacesSearchResponse(
    String status,
    String errorMessage,
    List<PlacesSearchResult> results,
    this.htmlAttributions,
    this.nextPageToken,
  ) : super(
          status,
          errorMessage,
          results,
        );

  factory PlacesSearchResponse.fromJson(Map json) => json != null
      ? PlacesSearchResponse(
          json['status'],
          json['error_message'],
          json['results']
              ?.map((r) => PlacesSearchResult.fromJson(r))
              ?.toList()
              ?.cast<PlacesSearchResult>(),
          json['html_attributions'] != null
              ? (json['html_attributions'] as List).cast<String>()
              : [],
          json['next_page_token'])
      : null;
}

class PlacesSearchResult {
  final String icon;
  final Geometry geometry;
  final String name;

  /// JSON place_id
  final String placeId;

  /// JSON alt_ids
  final List<AlternativeId> altIds;

  final List<String> types;

  final String vicinity;

  /// JSON formatted_address
  final String formattedAddress;
 
  final String id;

  final String reference;

  PlacesSearchResult(
    this.icon,
    this.geometry,
    this.name,
    this.placeId,
    this.altIds,
    this.types,
    this.vicinity,
    this.formattedAddress,
    this.id,
    this.reference,
  );

  factory PlacesSearchResult.fromJson(Map json) => json != null
      ? PlacesSearchResult(
          json['icon'],
          json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null,
          json['name'],         
          json['place_id'],
          json['alt_ids']
              ?.map((a) => AlternativeId.fromJson(a))
              ?.toList()
              ?.cast<AlternativeId>(),         
          json['vicinity'],
          json['formatted_address'],
          json['permanently_closed'],
          json['id'],
          json['reference'])
      : null;
}

class PlaceDetails {
  /// JSON address_components
  final List<AddressComponent> addressComponents;

  /// JSON adr_address
  final String adrAddress;

  /// JSON formatted_address
  final String formattedAddress;

  final String id;

  final String reference;

  final String icon;

  final String name;
  /// JSON place_id
  final String placeId;

  final String scope;

  final List<String> types;


  final String vicinity;

  /// JSON utc_offset
  final num utcOffset;

  final Geometry geometry;

  PlaceDetails(
    this.addressComponents,
    this.adrAddress,
    this.formattedAddress,
    this.id,
    this.reference,
    this.icon,
    this.name,
    this.placeId,
    this.scope,
    this.types,
    this.vicinity,
    this.utcOffset,
    this.geometry,
  );

  factory PlaceDetails.fromJson(Map json) => json != null
      ? PlaceDetails(
          json['address_components']
              ?.map((addr) => AddressComponent.fromJson(addr))
              ?.toList()
              ?.cast<AddressComponent>(),
          json['adr_address'],
          json['formatted_address'],
          json['id'],
          json['reference'],
          json['icon'],
          json['name'],
          json['place_id'],
          json['scope'],
          json['types'] != null ? (json['types'] as List)?.cast<String>() : [],
          json['vicinity'],
          json['utc_offset'],
          json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null)
      : null;
}


class AlternativeId {
  /// JSON place_id
  final String placeId;

  final String scope;

  AlternativeId(this.placeId, this.scope);

  factory AlternativeId.fromJson(Map json) =>
      json != null ? AlternativeId(json['place_id'], json['scope']) : null;
}


class PlacesDetailsResponse extends GoogleResponse<PlaceDetails> {
  /// JSON html_attributions
  final List<String> htmlAttributions;

  PlacesDetailsResponse(
    String status,
    String errorMessage,
    PlaceDetails result,
    this.htmlAttributions,
  ) : super(
          status,
          errorMessage,
          result,
        );

  factory PlacesDetailsResponse.fromJson(Map json) => json != null
      ? PlacesDetailsResponse(
          json['status'],
          json['error_message'],
          json['result'] != null ? PlaceDetails.fromJson(json['result']) : null,
          json['html_attributions'] != null
              ? (json['html_attributions'] as List)?.cast<String>()
              : [])
      : null;
}

class PlacesAutocompleteResponse extends GoogleResponseStatus {
  final List<Prediction> predictions;

  PlacesAutocompleteResponse(
    String status,
    String errorMessage,
    this.predictions,
  ) : super(
          status,
          errorMessage,
        );

  factory PlacesAutocompleteResponse.fromJson(Map json) => json != null
      ? PlacesAutocompleteResponse(
          json['status'],
          json['error_message'],
          json['predictions']
              ?.map((p) => Prediction.fromJson(p))
              ?.toList()
              ?.cast<Prediction>())
      : null;
}

class Prediction {
  final String description;
  final String id;
  final List<Term> terms;
  final int distanceMeters;

  /// JSON place_id
  final String placeId;
  final String reference;
  final List<String> types;

  /// JSON matched_substrings
  final List<MatchedSubstring> matchedSubstrings;

  final StructuredFormatting structuredFormatting;

  Prediction(
      this.description,
      this.id,
      this.terms,
      this.distanceMeters,
      this.placeId,
      this.reference,
      this.types,
      this.matchedSubstrings,
      this.structuredFormatting);

  factory Prediction.fromJson(Map json) => json != null
      ? Prediction(
          json['description'],
          json['id'],
          json['terms']?.map((t) => Term.fromJson(t))?.toList()?.cast<Term>(),
          json['distance_meters'],
          json['place_id'],
          json['reference'],
          json['types'] != null ? (json['types'] as List)?.cast<String>() : [],
          json['matched_substrings']
              ?.map((m) => MatchedSubstring.fromJson(m))
              ?.toList()
              ?.cast<MatchedSubstring>(),
          json['structured_formatting'] != null
              ? StructuredFormatting.fromJson(json['structured_formatting'])
              : null,
        )
      : null;
}

class Term {
  final num offset;
  final String value;

  Term(this.offset, this.value);

  factory Term.fromJson(Map json) =>
      json != null ? Term(json['offset'], json['value']) : null;

  @override
  String toString() {
    return 'Term{offset: $offset, value: $value}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Term &&
          runtimeType == other.runtimeType &&
          offset == other.offset &&
          value == other.value;

  @override
  int get hashCode => offset.hashCode ^ value.hashCode;
}

class MatchedSubstring {
  final num offset;
  final num length;

  MatchedSubstring(this.offset, this.length);

  factory MatchedSubstring.fromJson(Map json) =>
      json != null ? MatchedSubstring(json['offset'], json['length']) : null;

  @override
  String toString() {
    return 'MatchedSubstring{offset: $offset, length: $length}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MatchedSubstring &&
          runtimeType == other.runtimeType &&
          offset == other.offset &&
          length == other.length;

  @override
  int get hashCode => offset.hashCode ^ length.hashCode;
}

class StructuredFormatting {
  final String mainText;
  final List<MatchedSubstring> mainTextMatchedSubstrings;
  final String secondaryText;

  StructuredFormatting(
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
  );

  factory StructuredFormatting.fromJson(Map json) => json != null
      ? StructuredFormatting(
          json['main_text'],
          json['main_text_matched_substrings']
              ?.map((m) => MatchedSubstring.fromJson(m))
              ?.toList()
              ?.cast<MatchedSubstring>(),
          json['secondary_text'])
      : null;
}
