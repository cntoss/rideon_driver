import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

/// Declare globals that are used frequently in application
class AppConfig {
  /// Manage navigator state from anywhere such as show dialog, push or pop route etc.
  static GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>(); //date diplay style

  DateFormat dateWithTime = DateFormat('MMM dd, yyyy   hh:mm a');
  DateFormat dateWithoutTime = DateFormat('MMM dd, yyyy');
  DateFormat dateOnlyTime = DateFormat('hh:mm a');
}

const hiveBoxName = 'rideOnBox';

const htSavedAddress = 1;
const htAddressType = 2;
const htlnModel = 3;
const htNotification = 4;

const hkEncryptionKey = "hkKey";
const hkUser = 'user';
const hkIsLoging = 'isLogin';
const hkIsWorkThrough = 'isWorkThrough';
const hkAddressType = 'addressType';
const hkTheme = 'theme';
const hkNotification = 'notification';

const googleAPIKey = 'AIzaSyA8yyji0eV-0jkNXg-yFhIRXUa5bIChX78';
const double CAMERA_ZOOM = 15;
const double CAMERA_ZOOM_HOME = 14;
const double CAMERA_TILT = 50; //80
const double CAMERA_BEARING = 0.0; //30
const LatLng SOURCE_LOCATION = LatLng(27.6844713, 85.3254059);
const LatLng DEST_LOCATION = LatLng(27.6431663, 85.2664908);
