import 'package:dio/dio.dart';
import 'package:rideon_driver/models/googleModel/locationModel.dart';
import 'package:rideon_driver/models/googleModel/GeocodingModel.dart';
import 'package:rideon_driver/config/appConfig.dart';

class GeocodingService {
  Future<LocationDetail?> getPlaceDetailFromLocation(
      LocationModel locationModel) async {
    final request =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationModel.lat},${locationModel.lng}&key=$googleAPIKey';
    final response = await Dio().get(request);

    if (response.statusCode == 200) {
      var responseDate = response.data;
      final result = GeocodingModel.fromJson(responseDate);
      print(result);
      if (result.status == 'OK') {
        return result.results![0];
      } 
      print( Exception(responseDate['error_message']));
      return null;
      
    } else {
      print( Exception('Failed to fetch suggestion'));
      return null;
    }
  }
}
