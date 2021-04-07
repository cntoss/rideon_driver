/* import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/maps/providers/place_provider.dart';
import 'package:rideon_driver/maps/src/utils/uuid.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';


class StaticMap extends StatefulWidget {
  @override
  _StaticMapState createState() => _StaticMapState();
}

class _StaticMapState extends State<StaticMap> {
  Future<PlaceProvider> _futureProvider;
  PlaceProvider provider;
 final LatLng initialPosition = SOURCE_LOCATION;
  bool useCurrentLocation = true;
  Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();

    _futureProvider = _initPlaceProvider();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<PlaceProvider> _initPlaceProvider() async {
    final headers = await GoogleApiHeaders().getHeaders();
    BaseClient httpClient;
    String proxyBaseUrl;

    final provider = PlaceProvider(
      googleAPIKey,
      proxyBaseUrl,
      httpClient,
      headers,
    );
    provider.sessionToken = Uuid().generateV4();
    provider.desiredAccuracy = LocationAccuracy.high;
    provider.setMapType(MapType.normal);

    return provider;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _futureProvider,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          provider = snapshot.data;

          return ChangeNotifierProvider.value(
            value: provider,
            child: Builder(
              builder: (context) {
                return _buildMapWithLocation();
              },
            ),
          );
        } else {
          final children = <Widget>[];
          if (snapshot.hasError) {
            children.addAll([
              Icon(
                Icons.error_outline,
                color: Theme.of(context).errorColor,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ]);
          } else {
            children.add(CircularProgressIndicator());
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        }
      },
    );
  }

  Widget _buildMapWithLocation() {
    if (useCurrentLocation) {
      return FutureBuilder(
          future: provider.updateCurrentLocation(true),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (provider.currentPosition == null) {
                return _buildMap(initialPosition);
              } else {
                return _buildMap(LatLng(provider.currentPosition.latitude,
                    provider.currentPosition.longitude));
              }
            }
          });
    } else {
      return FutureBuilder(
        future: Future.delayed(Duration(milliseconds: 1)),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildMap(initialPosition);
          }
        },
      );
    }
  }

  Widget _buildMap(LatLng initialTarget) {
    CameraPosition _initialCameraPosition = CameraPosition(
        target: initialTarget,
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING);

    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      initialCameraPosition: _initialCameraPosition,
      gestureRecognizers: Set()
         ..add(Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer())),
        //    onMapCreated: (GoogleMapController controller) {
        // _controller.complete(controller);
      //},
    );
  }
}
 */