import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/maps/web_service/distance.dart' as distance;
import 'dart:async';
import 'package:rideon_driver/models/googleModel/GeocodingModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rideon_driver/models/notification/request_notification.dart';
import 'package:rideon_driver/services/helper/zoomCalculate.dart';

class RideRequestPage extends StatefulWidget {
  RideRequestPage({required this.notificationData});
  final NotificationData notificationData;
  @override
  State<StatefulWidget> createState() =>
      RideRequestState(this.notificationData);
}

class RideRequestState extends State<RideRequestPage> with SingleTickerProviderStateMixin{
 
  RideRequestState(this._notificationData);
  NotificationData _notificationData;

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
  late AnimationController controller;
  bool _showDetails = true;
// enabling disabling show details; 
  bool _isExpand = false;
  @override
  void initState() {
    super.initState();
    // create an instance of Location
    sourceDetail = _notificationData.fromLocation;
    destinationDetail = _notificationData.toLocation;
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

     super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
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
      "latitude": destinationDetail.geometry!.location.lat,
      "longitude": destinationDetail.geometry!.location.lng
    });
  }

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
        target: LatLng(
            (sourceDetail.geometry!.location.lat +
                    destinationDetail.geometry!.location.lat) /
                2,
            (sourceDetail.geometry!.location.lng +
                    destinationDetail.geometry!.location.lng) /
                2),
        zoom: ZoomCalculate().getZoom(
            sourceDetail.geometry!.location.lat,
            sourceDetail.geometry!.location.lng,
            destinationDetail.geometry!.location.lat,
            destinationDetail.geometry!.location.lng),
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING);
        
    return Scaffold( 
      body: Stack(
        children: <Widget>[
          GoogleMap(
              myLocationEnabled: true,
              compassEnabled: false,
              tiltGesturesEnabled: false,
              zoomControlsEnabled: false,
              markers: _markers,
              polylines: Set<Polyline>.of(polylines.values),
              mapType: MapType.normal,
              initialCameraPosition: initialCameraPosition,             
              onMapCreated: (GoogleMapController controller) {
                //controller.setMapStyle(Utils.mapStyles);
                _controller.complete(controller);
                showPinsOnMap();
              }),

          ///TODO: disable back button
          /*  Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 20,
            child: IconButton(
              color: Colors.grey,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ), */
          //make future loader here if distance and time response is not
          // coming from firebase nitifiation
          if(_showDetails)
          _mapPinPillComponent(
          ),
          //Future.delayed(Duration.zero, ()=> showRequestBox())
        ],
      ),
    );
  }

 

  void showPinsOnMap() {
    var pinPosition =
        LatLng(currentLocation.latitude, currentLocation.longitude);
    var destPosition =
        LatLng(destinationLocation.latitude, destinationLocation.longitude);

    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        infoWindow: InfoWindow(
            title: sourceDetail.formattedAddress, snippet: 'rideon_driver map'),
        position: pinPosition,
        icon: sourceIcon));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon));
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id, color: Colors.blue, points: polylineCoordinates);
    polylines[id] = polyline;
    if (!mounted) return;
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

      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');
      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: sourceIcon));
    });
  }

  Future<String> getDistance() async {
    var distanceResponse =
        await distance.GoogleDistanceMatrix(apiKey: googleAPIKey)
            .distanceWithLocation([sourceDetail.geometry!.location],
                [destinationDetail.geometry!.location]);
    if (distanceResponse != null)
      return distanceResponse.rows.first.elements.first.distance.text;
    else
      return '';
  }

 Widget _mapPinPillComponent() {
    var width = MediaQuery.of(context).size.width;
    Future.delayed(
        const Duration(seconds: 100), () => {Navigator.pop(context)});
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              children: [
                IconButton(
                    padding: EdgeInsets.all(0),
                    icon: _isExpand
                        ? Icon(Icons.keyboard_arrow_up)
                        : Icon(Icons.keyboard_arrow_down),
                    onPressed: () {
                      setState(() {
                        _isExpand = !_isExpand;
                      });
                    }),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Text(
                    'You got a ride request',
                    style: title,
                  ),
                )
              ],
            ),
            LinearProgressIndicator(
              value: controller.value,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
            ),
            _isExpand
                ? _acceptButton()
                : Container(
                    color: Colors.white,
                    width: width,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                child: Icon(Icons.person, size: 30),
                                foregroundColor: Colors.grey[300],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pyari Suntali'),
                                Text('Damak, Jhapa')
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(height: 3, color: Colors.black45),
                        ),
                        Row(
                          children: [
                            Icon(Icons.person_pin_circle),
                            Expanded(
                                child: Text(
                                    _notificationData.fromLocation.formattedAddress!))
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.pin_drop),
                            Expanded(
                                child: Text(
                                    _notificationData.toLocation.formattedAddress!))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(height: 3, color: Colors.black45),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(flex: 1),
                            Flexible(
                              flex: 10,
                              child: Column(
                                children: [
                                  Text('Distance'),
                                  Text(
                                    _notificationData.distance,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 30,
                              color: Colors.black,
                              width: 1,
                            ),
                            Column(
                              children: [
                                Text('Fare'),
                                Text(
                                  'Rs 100',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                )
                              ],
                            ),
                            Spacer(
                              flex: 1,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(height: 3, color: Colors.black45),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(flex: 4),
                            Icon(Icons.call),
                            //Spacer(flex: 1),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Support',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(flex: 1),
                            Container(
                              height: 20,
                              color: Colors.black,
                              width: 1,
                            ),
                            Spacer(flex: 1),
                            TextButton(
                              onPressed: () {
                                _showDetails = false;
                                controller.stop();
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Reject',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ),
                            Spacer(
                              flex: 4,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(height: 3, color: Colors.black45),
                        ),
                        _acceptButton()
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _acceptButton() {
    return ElevatedButton(
      onPressed: () => setState((){_showDetails = false;controller.stop();}),
      child: Text('Accept rideon_driver request'),
    );
  }

}
/* 
class MapPinPillComponent extends StatefulWidget {
  final NotificationData data;
  MapPinPillComponent({this.data});

  @override
  _MapPinPillComponentState createState() => _MapPinPillComponentState();
}

class _MapPinPillComponentState extends State<MapPinPillComponent>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  //Animation animation;

  bool _isExpand = false;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);

    /*  controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween(begin: 0.0, end: 20.0).animate(controller)
      ..addListener(() {
        setState(() {
          // Change here any Animation object value.
        });
      }); */
  }

  @override
  void dispose() {
    controller.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    Future.delayed(
        const Duration(seconds: 100), () => {Navigator.pop(context)});
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              children: [
                IconButton(
                    padding: EdgeInsets.all(0),
                    icon: _isExpand
                        ? Icon(Icons.keyboard_arrow_up)
                        : Icon(Icons.keyboard_arrow_down),
                    onPressed: () {
                      setState(() {
                        _isExpand = !_isExpand;
                      });
                    }),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Text(
                    'You got a ride request',
                    style: title,
                  ),
                )
              ],
            ),
            LinearProgressIndicator(
              value: controller.value,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
            ),
            _isExpand
                ? _acceptButton()
                : Container(
                    color: Colors.white,
                    width: width,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                child: Icon(Icons.person, size: 30),
                                foregroundColor: Colors.grey[300],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Pyari Suntali'),
                                Text('Damak, Jhapa')
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(height: 3, color: Colors.black45),
                        ),
                        Row(
                          children: [
                            Icon(Icons.person_pin_circle),
                            Expanded(
                                child: Text(
                                    widget.data.fromLocation.formattedAddress))
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.pin_drop),
                            Expanded(
                                child: Text(
                                    widget.data.toLocation.formattedAddress))
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(height: 3, color: Colors.black45),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(flex: 1),
                            Flexible(
                              flex: 10,
                              child: Column(
                                children: [
                                  Text('Distance'),
                                  Text(
                                    widget.data.distance ?? '5.8 Km',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 30,
                              color: Colors.black,
                              width: 1,
                            ),
                            Column(
                              children: [
                                Text('Fare'),
                                Text(
                                  'Rs 100',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 20),
                                )
                              ],
                            ),
                            Spacer(
                              flex: 1,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(height: 3, color: Colors.black45),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Spacer(flex: 4),
                            Icon(Icons.call),
                            //Spacer(flex: 1),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Support',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(flex: 1),
                            Container(
                              height: 20,
                              color: Colors.black,
                              width: 1,
                            ),
                            Spacer(flex: 1),
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(
                                'Reject',
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ),
                            Spacer(
                              flex: 4,
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Divider(height: 3, color: Colors.black45),
                        ),
                        _acceptButton()
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget _acceptButton() {
    return ElevatedButton(
      onPressed: () => setState((){RideRequestPage.showDetail = false;}),
      child: Text('Accept rideon_driver request'),
    );
  }
}

 void showRequestBox() async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MapPinPillComponent(
          data: _notificationData,
        ),
      ),
    );
    if (!result)
      Navigator.pop(context);
    else
      print("not navigated");
  }
 */