import 'package:rideon_driver/config/appConfig.dart';
import 'package:dio/dio.dart';
import 'package:rideon_driver/models/googleModel/GeocodingModel.dart';

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {

  PlaceApiProvider(this.sessionToken);

  final sessionToken;

  /* static final String androidKey = 'YOUR_API_KEY_HERE';
  static final String iosKey = 'YOUR_API_KEY_HERE'; */
  

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&language=$lang&key=$googleAPIKey&sessiontoken=$sessionToken';
    final response = await Dio().get(request);

    if (response.statusCode == 200) {
      final result = response.data;
      print(result);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return result['predictions']
            .map<Suggestion>((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      }
      if (result['status'] == 'ZERO_RESULTS') {
        return [];
      }
      throw Exception(result['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<LocationDetail> getPlaceDetailFromId(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=address_component,formatted_address,geometry,place_id&key=$googleAPIKey&sessiontoken=$sessionToken';
    final response = await Dio().get(request);

    if (response.statusCode == 200) {
       var responseDate = response.data; 
      print(responseDate);
      if (responseDate['status'] == 'OK') {
               return LocationDetail.fromJson(responseDate['result']);
        
      }
      throw Exception(responseDate['error_message']);
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

}
