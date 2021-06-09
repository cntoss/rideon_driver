import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/maps/google_maps_place_picker.dart';
import 'package:rideon_driver/maps/providers/place_provider.dart';
import 'package:rideon_driver/maps/src/components/animated_pin.dart';
import 'package:rideon_driver/maps/src/components/floating_card.dart';
import 'package:rideon_driver/maps/src/place_picker.dart';
import 'package:rideon_driver/maps/web_service/geocoding.dart';
import 'package:rideon_driver/maps/web_service/places.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
 

 typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  PickResult? selectedPlace,
  SearchingState state,
  bool isSearchBarFocused,
);

typedef PinBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

class GoogleMapPlacePicker extends StatelessWidget {
  const GoogleMapPlacePicker({
    Key? key,
    required this.initialTarget,
    required this.appBarKey,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.onSearchFailed,
    this.onMoveStart,
    this.onMapCreated,
    this.debounceMilliseconds,
    this.enableMapTypeButton,
    this.enableMyLocationButton,
    this.onToggleMapType,
    this.onMyLocation,
    this.onPlacePicked,
    this.usePinPointingSearch,
    this.usePlaceDetailSearch,
    this.selectInitialPosition,
    this.language,
    this.forceSearchOnZoomChanged,
    this.hidePlaceDetailsWhenDraggingPin,
  }) : super(key: key);

  final LatLng initialTarget;
  final GlobalKey appBarKey;

  final SelectedPlaceWidgetBuilder? selectedPlaceWidgetBuilder;
  final PinBuilder? pinBuilder;

  final ValueChanged<String>? onSearchFailed;
  final VoidCallback? onMoveStart;
  final MapCreatedCallback? onMapCreated;
  final VoidCallback? onToggleMapType;
  final VoidCallback? onMyLocation;
  final ValueChanged<PickResult>? onPlacePicked;

  final int? debounceMilliseconds;
  final bool? enableMapTypeButton;
  final bool? enableMyLocationButton;

  final bool? usePinPointingSearch;
  final bool? usePlaceDetailSearch;

  final bool? selectInitialPosition;

  final String? language;

  final bool? forceSearchOnZoomChanged;
  final bool? hidePlaceDetailsWhenDraggingPin;

  _searchByCameraLocation(PlaceProvider provider) async {
    // We don't want to search location again if camera location is changed by zooming in/out.
    bool hasZoomChanged = provider.cameraPosition != null &&
        provider.prevCameraPosition != null &&
        provider.cameraPosition!.zoom != provider.prevCameraPosition!.zoom;

    if (forceSearchOnZoomChanged == false && hasZoomChanged) {
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    provider.placeSearchingState = SearchingState.Searching;

    final GeocodingResponse response =
        await provider.geocoding.searchByLocation(
      Location(
          lat: provider.cameraPosition!.target.latitude,
          lng: provider.cameraPosition!.target.longitude),
      language: language,
    );

    if (response.errorMessage?.isNotEmpty == true ||
        response.status == "REQUEST_DENIED") {
      print("Camera Location Search Error: " + response.errorMessage!);
      if (onSearchFailed != null) {
        onSearchFailed!(response.status);
      }
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    if (usePlaceDetailSearch!) {
      final PlacesDetailsResponse detailResponse =
          await provider.places.getDetailsByPlaceId(
        response.results[0].placeId,
        language: language,
      );

      if (detailResponse.errorMessage?.isNotEmpty == true ||
          detailResponse.status == "REQUEST_DENIED") {
        print("Fetching details by placeId Error: " +
            detailResponse.errorMessage!);
        if (onSearchFailed != null) {
          onSearchFailed!(detailResponse.status);
        }
        provider.placeSearchingState = SearchingState.Idle;
        return;
      }

      provider.selectedPlace =
          PickResult.fromPlaceDetailResult(detailResponse.result);
    } else {
      provider.selectedPlace =
          PickResult.fromGeocodingResult(response.results[0]);
    }

    provider.placeSearchingState = SearchingState.Idle;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildGoogleMap(context),
        _buildPin(),
        _buildFloatingCard(),
        _buildMapIcons(context),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Selector<PlaceProvider, MapType>(
        selector: (_, provider) => provider.mapType,
        builder: (_, data, __) {
          PlaceProvider provider = PlaceProvider.of(context, listen: false);
          CameraPosition initialCameraPosition =
              CameraPosition(target: initialTarget, zoom: 15);

          return GoogleMap(
            myLocationButtonEnabled: false,
            compassEnabled: false,
            mapToolbarEnabled: false,
            initialCameraPosition: initialCameraPosition,
            mapType: data,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              provider.mapController = controller;
              provider.setCameraPosition(null);
              provider.pinState = PinState.Idle;
              /*  controller.animateCamera(CameraUpdate.newLatLngBounds(
                  LatLngBounds(
                      southwest: LatLng(26, 79.5), northeast: LatLng(31, 88.5)),
                  15));
              Future.delayed(
                Duration(seconds: 10),
                () async => print(
                  await controller.getVisibleRegion(),
                ),
              ); */
              // When select initialPosition set to true.
              if (selectInitialPosition!) {
                provider.setCameraPosition(initialCameraPosition);
                _searchByCameraLocation(provider);
              }
            },
            onCameraIdle: () {
              if (provider.isAutoCompleteSearching) {
                provider.isAutoCompleteSearching = false;
                provider.pinState = PinState.Idle;
                return;
              }

              // Perform search only if the setting is to true.
              if (usePinPointingSearch!) {
                // Search current camera location only if camera has moved (dragged) before.
                if (provider.pinState == PinState.Dragging) {
                  // Cancel previous timer.
                  if (provider.debounceTimer?.isActive ?? false) {
                    provider.debounceTimer!.cancel();
                  }
                  provider.debounceTimer =
                      Timer(Duration(milliseconds: debounceMilliseconds!), () {
                    _searchByCameraLocation(provider);
                  });
                }
              }

              provider.pinState = PinState.Idle;
            },
            onCameraMoveStarted: () {
              provider.setPrevCameraPosition(provider.cameraPosition);

              // Cancel any other timer.
              provider.debounceTimer?.cancel();

              // Update state, dismiss keyboard and clear text.
              provider.pinState = PinState.Dragging;

              // Begins the search state if the hide details is enabled
              if (this.hidePlaceDetailsWhenDraggingPin!) {
                provider.placeSearchingState = SearchingState.Searching;
              }

              onMoveStart!();
            },
            onCameraMove: (CameraPosition position) {
              provider.setCameraPosition(position);
            },
            gestureRecognizers: Set()
              ..add(Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer())),
          );
        });
  }

  Widget _buildPin() {
    return Center(
      child: Selector<PlaceProvider, PinState>(
        selector: (_, provider) => provider.pinState,
        builder: (context, state, __) {
          if (pinBuilder == null) {
            return _defaultPinBuilder(context, state);
          } else {
            return Builder(
                builder: (builderContext) =>
                    pinBuilder!(builderContext, state));
          }
        },
      ),
    );
  }

  Widget _defaultPinBuilder(BuildContext context, PinState state) {
    if (state == PinState.Preparing) {
      return Container();
    } else if (state == PinState.Idle) {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.push_pin, size: 36, color: Colors.redAccent),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedPin(
                    child: Icon(Icons.push_pin, size: 36, color: Colors.green)),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildFloatingCard() {
    return Selector<PlaceProvider,
        Tuple4<PickResult?, SearchingState, bool, PinState>>(
      selector: (_, provider) => Tuple4(
          provider.selectedPlace,
          provider.placeSearchingState,
          provider.isSearchBarFocused,
          provider.pinState),
      builder: (context, data, __) {
        if ((data.item1 == null && data.item2 == SearchingState.Idle) ||
            data.item3 == true ||
            data.item4 == PinState.Dragging &&
                this.hidePlaceDetailsWhenDraggingPin!) {
          return Container();
        } else {
          if (selectedPlaceWidgetBuilder == null) {
            return _defaultPlaceWidgetBuilder(context, data.item1, data.item2);
          } else {
            return Builder(
                builder: (builderContext) => selectedPlaceWidgetBuilder!(
                    builderContext, data.item1, data.item2, data.item3));
          }
        }
      },
    );
  }

  Widget _defaultPlaceWidgetBuilder(
      BuildContext context, PickResult? data, SearchingState state) {
    return FloatingCard(
      bottomPosition: MediaQuery.of(context).size.height * 0.05,
      leftPosition: MediaQuery.of(context).size.width * 0.025,
      rightPosition: MediaQuery.of(context).size.width * 0.025,
      width: MediaQuery.of(context).size.width * 0.9,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 4.0,
      color: Theme.of(context).cardColor,
      child: state == SearchingState.Searching
          ? _buildLoadingIndicator()
          : _buildSelectionDetails(context, data!),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 48,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildSelectionDetails(BuildContext context, PickResult result) {
    return Container(
      //margin: EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getName(result),

                ///todo:use formated address instead
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          //SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width / 1.3,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(cardColor)),
              child: Container(
                //padding: const EdgeInsets.all(8.0),
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text(
                  'Select',
                  style: TextStyle(color: Colors.black54),
                )),
              ),
              onPressed: () {
                onPlacePicked!(result);
              },
            ),
          ),
        ],
      ),
    );
  }

  //TODO: v2 changed test need
  String getName(PickResult locationDetail) {
    List locationNames = [];
    for (int i = 0; i < 4; i++) {
      if (i == 3) {
        if (locationDetail.addressComponents![3].types[0] == 'locality') {
          locationNames.add(locationDetail.addressComponents![i].longName);
        }
      } else if (locationDetail.addressComponents![i].longName !=
              'Unnamed Road' &&
          locationDetail.addressComponents![i].types[0] != 'country')
        locationNames.add(locationDetail.addressComponents![i].longName);
    }
    return locationNames.toSet().toList().join(', ');
  }

  Widget _buildMapIcons(BuildContext context) {
    return Positioned(
      bottom: 150, //appBarRenderBox.size.height,
      right: 15,
      child: Container(
        width: 35,
        height: 35,
        child: RawMaterialButton(
          shape: CircleBorder(),
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.black54
              : Colors.white,
          elevation: 8.0,
          onPressed: onMyLocation,
          child: Icon(Icons.my_location),
        ),
      ),
    );

    //  final RenderBox appBarRenderBox = appBarKey.currentContext.findRenderObject();
    //always disable satellite mode
    /*  return Positioned(
      bottom: 150, //appBarRenderBox.size.height,
      right: 15,
      child: Column(
        children: <Widget>[
          enableMapTypeButton
              ? Container(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                    elevation: 8.0,
                    onPressed: onToggleMapType,
                    child: Icon(Icons.layers),
                  ),
                )
              : Container(),
          SizedBox(height: 10),
          enableMyLocationButton
              ? Container(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                    elevation: 8.0,
                    onPressed: onMyLocation,
                    child: Icon(Icons.my_location),
                  ),
                )
              : Container(),
        ],
      ),
    );
 */
  }
}
