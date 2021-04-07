import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:location/location.dart';

class LocationService {
  BuildContext context = AppConfig.navigatorKey.currentState.overlay.context;
  Future<bool> showLocationDialog(
      {@required String title,
      VoidCallback onPressed,
      @required String message}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
                //onPressed: onPressed,
                onPressed: () async {
                  Navigator.pop(context);
                  getLocation();
                },
                child: Text("OK"))
          ],
        );
      },
    );
  }

  Future<String> getLocation() async {
    Location location = new Location();
    bool _locationServiceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _locationServiceEnabled = await location.serviceEnabled();
    if (!_locationServiceEnabled) {
      _locationServiceEnabled = await location.requestService();
      if (!_locationServiceEnabled) {
        showLocationDialog(
          title: 'Location Disabled',
          message: 'Please enable location service to continue',
        );
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        showLocationDialog(
          title: "Permission Denied",
          message:
              'Please allow permission to access device location to continue.',
        );

        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData.toString();
  }
  /*  Future<Position> getLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    LocationPermission permission;
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await Location.instance.requestService();
      if (!_serviceEnabled) {
        print('location disabled');
        showLocationDialog(
            title: 'Location disable',
            message: 'Please enable location service to continue',
            onPressed: () async {
              Navigator.pop(context, true);
              getLocation();
            });
        return null;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      showLocationDialog(
          title: 'Permission Denied',
          message:
              'Please allow permission to access device location to continue.',
          onPressed: () async {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied ||
                permission == LocationPermission.deniedForever) getLocation();
          });
      return null;
    } else if (permission == LocationPermission.deniedForever) {
      showLocationDialog(
              title: 'Permission Denied',
              message:
                  'Please allow permission to access device location to continue.')
          .then((value) async {
        await Geolocator.openAppSettings().then((value) => getLocation());
      });
      return null;
    }else
    return Geolocator.getCurrentPosition();
  }
 */
}
