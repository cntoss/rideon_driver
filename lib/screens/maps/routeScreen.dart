import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'dart:async';
import 'package:rideon_driver/models/googleModel/GeocodingModel.dart';
import 'package:geolocator/geolocator.dart';
class PinInformation {
  String pinPath;
  String avatarPath;
  LatLng location;
  String locationName;
  Color labelColor;

  PinInformation(
      {required this.pinPath,
      required this.avatarPath,
      required this.location,
      required this.locationName,
      required this.labelColor});
}

class RouteScreen extends StatefulWidget {
  RouteScreen({required this.sourceDetail, required this.destinationDetail});
  final LocationDetail sourceDetail;
  final LocationDetail destinationDetail;
  @override
  State<StatefulWidget> createState() =>
      RouteScreenState(this.sourceDetail, this.destinationDetail);
}

class RouteScreenState extends State<RouteScreen> {
  RouteScreenState(this.sourceDetail, this.destinationDetail);
  late LocationDetail sourceDetail;
  late LocationDetail destinationDetail;
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = Set<Marker>();
// for my drawn routes on the map
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
// for my custom marker pins
  late BitmapDescriptor sourceIcon;
  late BitmapDescriptor destinationIcon;
// the user's initial location and current location
// as it moves
  late Position currentLocation;
// a reference to the destination location
  late Position destinationLocation;
// wrapper around the location API
  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: LatLng(0, 0),
      locationName: '',
      labelColor: Colors.grey);
  late PinInformation sourcePinInfo;
  late PinInformation destinationPinInfo;

  @override
  void initState() {
    super.initState();
    // create an instance of Location
    polylinePoints = PolylinePoints();
    currentLocation = Position.fromMap({
      "latitude": sourceDetail.geometry!.location.lat,
      "longitude": sourceDetail.geometry!.location.lng
    });
    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
   /*  location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;
      updatePinOnMap();
    }); */
    // set custom marker pins
    setSourceAndDestinationIcons();
    // set the initial location
    setInitialLocation();
    _getPolyline();
  }

  void setSourceAndDestinationIcons() async {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: 2.0), 'assets/driving_pin.png')
        .then((onValue) {
      sourceIcon = onValue;
    });

    BitmapDescriptor.fromAssetImage(ImageConfiguration(devicePixelRatio: 2.0),
            'assets/destination_map_marker.png')
        .then((onValue) {
      destinationIcon = onValue;
    });
  }

  void setInitialLocation() async {
    destinationLocation = Position.fromMap({
      "latitude": widget.destinationDetail.geometry!.location.lat,
      "longitude": widget.destinationDetail.geometry!.location.lng
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: true,
              compassEnabled: true,
              tiltGesturesEnabled: false,
              markers: _markers,
              polylines: Set<Polyline>.of(polylines.values),
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,
              onTap: (LatLng loc) {
                setState(() {
                  pinPillPosition = -100;
                });
              },
              onMapCreated: (GoogleMapController controller) {
                //controller.setMapStyle(Utils.mapStyles);
                _controller.complete(controller);
                // my map has completed being created;
                // i'm ready to show the pins on the map
                showPinsOnMap();
              }),
          MapPinPillComponent(
              pinPillPosition: pinPillPosition,
              currentlySelectedPin: currentlySelectedPin)
        ],
      ),
    );
  }

  void showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    // get a LatLng out of the LocationData object
    var destPosition =
        LatLng(destinationLocation.latitude, destinationLocation.longitude);

    sourcePinInfo = PinInformation(
        locationName: "Start Location",
        location: pinPosition,
        pinPath: "assets/driving_pin.png",
        avatarPath: "assets/friend1.jpg",
        labelColor: Colors.blueAccent);

    destinationPinInfo = PinInformation(
        locationName: "End Location",
        location: destPosition,
        pinPath: "assets/destination_map_marker.png",
        avatarPath: "assets/friend2.jpg",
        labelColor: Colors.purple);

    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });
        },
        icon: sourceIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        onTap: () {
          setState(() {
            currentlySelectedPin = destinationPinInfo;
            pinPillPosition = 0;
          });
        },
        icon: destinationIcon));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    if(!mounted) return;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPIKey,
      PointLatLng(currentLocation.latitude, currentLocation.longitude),
      PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  void updatePinOnMap() async {
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: 0,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude, currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));    
    setState(() {
      // updated position
      var pinPosition =
          LatLng(currentLocation.latitude, currentLocation.longitude);

      sourcePinInfo.location = pinPosition;

      
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          position: pinPosition, // updated position
          icon: sourceIcon));
    });
  }
}

class MapPinPillComponent extends StatefulWidget {
  final double pinPillPosition;
  final PinInformation currentlySelectedPin;

  MapPinPillComponent({required this.pinPillPosition, required this.currentlySelectedPin});

  @override
  State<StatefulWidget> createState() => MapPinPillComponentState();
}

class MapPinPillComponentState extends State<MapPinPillComponent> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: widget.pinPillPosition,
      right: 0,
      left: 0,
      duration: Duration(milliseconds: 200),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: EdgeInsets.all(20),
          height: 70,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(50)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 20,
                    offset: Offset.zero,
                    color: Colors.grey.withOpacity(0.5))
              ]),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(left: 10),
                child: ClipOval(
                    child: Image.asset(widget.currentlySelectedPin.avatarPath,
                        fit: BoxFit.cover)),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(widget.currentlySelectedPin.locationName,
                          style: TextStyle(
                              color: widget.currentlySelectedPin.labelColor)),
                      Text(
                          'Latitude: ${widget.currentlySelectedPin.location.latitude.toString()}',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                      Text(
                          'Longitude: ${widget.currentlySelectedPin.location.longitude.toString()}',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Image.asset(widget.currentlySelectedPin.pinPath,
                    width: 50, height: 50),
              )
            ],
          ),
        ),
      ),
    );
  }
}
