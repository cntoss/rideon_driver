import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/maps/google_maps_place_picker.dart';
import 'package:rideon_driver/models/googleModel/GeocodingModel.dart';
import 'package:rideon_driver/screens/maps/routeScreen.dart';
import 'package:rideon_driver/widget/animatedPin.dart';
import 'package:rideon_driver/services/google/placeService.dart';
import 'package:rideon_driver/config/constant.dart';

enum CurrentLocation { fromLocation, toLocation }

class LocationSetScreen extends StatefulWidget {
  LocationSetScreen(this.locationDetail);
  final LocationDetail locationDetail;

  @override
  _LocationSetScreenState createState() =>
      _LocationSetScreenState(this.locationDetail);
}

class _LocationSetScreenState extends State<LocationSetScreen> {
  _LocationSetScreenState(this.fromLocationModel);
   late TextEditingController _fromController;
  TextEditingController _toController = TextEditingController();
  LocationDetail fromLocationModel = LocationDetail();
  LocationDetail toLocationModel = LocationDetail();
  late PlaceApiProvider apiClient;
  String query = '';
  CurrentLocation? currentLocation;
  bool _fromCLear = false;
  bool _toClear = false;
  @override
  void initState() {
    super.initState();
    _fromController =
        TextEditingController(text: fromLocationModel.formattedAddress ?? '');
    apiClient = PlaceApiProvider(UniqueKey());
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.pop(context)),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 55),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.location_on, color: Colors.grey),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                            color: cardColor,
                            border: Border.all(color: cardColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          controller: _fromController,
                          onChanged: (x) async {
                            setState(() {
                              query = x;
                            });
                            if (!_fromCLear &&
                                _fromController.text.trim().length > 1)
                              setState(() {
                                _fromCLear = true;
                              });
                            currentLocation = CurrentLocation.fromLocation;
                          },
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          minLines: 1,
                          decoration: InputDecoration(
                              hintText: "From Address",
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                icon:
                                    _fromCLear ? Icon(Icons.clear) : Icon(null),
                                onPressed: () => setState(() {
                                  query = '';
                                  _fromController.clear();
                                  _fromCLear = false;
                                }),
                              ),
                              contentPadding: EdgeInsets.all(8)
                              /*  focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.green)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.green)), */
                              ),
                        ),
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        height: 30,
                        width: 2,
                        decoration: BoxDecoration(color: Colors.black54),
                        child: SizedBox(width: 2),
                        //child: //your widget code
                      ),
                    ),
                    Row(children: [
                      Icon(Icons.location_on, color: Colors.black38),
                      Container(
                        decoration: BoxDecoration(
                          color: cardColor,
                          border: Border.all(color: cardColor),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextField(
                          controller: _toController,
                          onChanged: (x) {
                            setState(() {
                              query = x;
                            });
                            if (!_toClear && x.trim().length > 1)
                              setState(() {
                                _toClear = true;
                              });
                            currentLocation = CurrentLocation.toLocation;
                          },
                          maxLines: 3,
                          minLines: 1,
                          decoration: InputDecoration(
                            hintText: "Your destination?",
                            suffixIcon: IconButton(
                              icon: _fromCLear ? Icon(Icons.clear) : Icon(null),
                              onPressed: () => setState(() {
                                query = '';
                                _toController.clear();
                                _toClear = false;
                              }),
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(8.0),
                          ),
                        ),
                      ),
                    ]),
                    FutureBuilder(
                      future: query == ""
                          ? null
                          : apiClient.fetchSuggestions(query,
                              Localizations.localeOf(context).languageCode),
                      builder: (context, AsyncSnapshot<List<Suggestion>> snapshot) => query == ''
                          ? Container()
                          : snapshot.hasData
                              ? ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return Divider();
                                  },
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => ListTile(
                                    contentPadding: EdgeInsets.all(0),
                                    leading: Material(
                                      color: Colors.grey,
                                      child: Icon(
                                        Icons.location_on,
                                        size: 20,
                                      ),
                                      shape: CircleBorder(),
                                    ),
                                    title: Transform.translate(
                                      offset: Offset(-25, 0),
                                      child: Text(
                                          (snapshot.data![index])
                                              .description),
                                    ),
                                    onTap: () async {
                                      if (snapshot.data![index] != null) {
                                        var result =
                                            snapshot.data![index];
                                        final placeDetails =
                                            await PlaceApiProvider(UniqueKey())
                                                .getPlaceDetailFromId(
                                                    result.placeId);
                                        if (currentLocation ==
                                            CurrentLocation.toLocation) {
                                          setState(() {
                                            _toController.text =
                                                result.description;
                                            toLocationModel = placeDetails;
                                            query = '';
                                          });
                                        } else {
                                          setState(() {
                                            _fromController.text =
                                                result.description;
                                            fromLocationModel = placeDetails;
                                            query = '';
                                          });
                                        }
                                      }
                                      _navigateToProceed();
                                    },
                                  ),
                                  itemCount: snapshot.data!.length,
                                )
                              : Container(child: Text('Loading...')),
                    ),
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      leading: Material(
                        color: Colors.grey,
                        shape:
                            CircleBorder(side: BorderSide(color: Colors.grey)),
                        child: Icon(
                          Icons.push_pin,
                          size: 20,
                        ),
                      ),
                      title: Transform.translate(
                          offset: Offset(-25, 0), child: Text('Set on map')),
                      onTap: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlacePicker(
                                apiKey: googleAPIKey,
                                //searchBarHeight: 0,
                                usePlaceDetailSearch: true,
                                initialPosition: SOURCE_LOCATION,
                                useCurrentLocation: true,
                                pinBuilder: (context, state) {
                                  if (state == PinState.Idle) {
                                    return Stack(
                                      children: <Widget>[
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.push_pin,
                                                  size: 36,
                                                  color: Colors.green),
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
                                  } else {
                                    return Stack(
                                      children: <Widget>[
                                        Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              AnimatedPin(
                                                  child: Icon(Icons.push_pin,
                                                      size: 36,
                                                      color: Colors.green)),
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
                                },
                                selectedPlaceWidgetBuilder: (_, selectedPlace,
                                    state, isSearchBarFocused) {
                                  return isSearchBarFocused
                                      ? Container()
                                      // Use FloatingCard or just create your own Widget.
                                      : FloatingCard(
                                          bottomPosition:
                                              0.0, // MediaQuery.of(context) will cause rebuild. See MediaQuery document for the information.
                                          leftPosition: 10.0,
                                          rightPosition: 10.0,
                                          width: 500,
                                          borderRadius:
                                              BorderRadius.circular(12.0),
                                          child: state ==
                                                  SearchingState.Searching
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : Column(
                                                  children: [
                                                    ElevatedButton(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                              '${selectedPlace!.name} ${selectedPlace.formattedAddress}'),
                                                        ),
                                                        onPressed: () {}),
                                                    ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(cardColor)),
                                                      child: Container(
                                                        //padding: const EdgeInsets.all(8.0),
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        child: Center(
                                                            child:
                                                                Text('Select')),
                                                      ),
                                                      onPressed: () {
                                                        if (currentLocation ==
                                                                    null &&
                                                                fromLocationModel
                                                                        .formattedAddress ==
                                                                    null ||
                                                            currentLocation ==
                                                                CurrentLocation
                                                                    .fromLocation)
                                                          setState(() {
                                                            _fromController
                                                                    .text =
                                                                selectedPlace
                                                                    .formattedAddress as String;
                                                            fromLocationModel =
                                                                LocationDetail
                                                                    .fromPickResult(
                                                                        selectedPlace);

                                                            query = '';
                                                          });
                                                        else
                                                          setState(() {
                                                            _toController.text =
                                                                selectedPlace
                                                                    .name!;
                                                            toLocationModel =
                                                                LocationDetail
                                                                    .fromPickResult(
                                                                        selectedPlace);

                                                            query = '';
                                                          });

                                                        Navigator.pop(context);
                                                        _navigateToProceed();
                                                      },
                                                    )
                                                  ],
                                                ),
                                        );
                                },
                              ),
                            ));
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _navigateToProceed() {
    if (fromLocationModel.geometry != null && toLocationModel.geometry != null)
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => RouteScreen(
                  sourceDetail: fromLocationModel,
                  destinationDetail: toLocationModel)));
  }
}
