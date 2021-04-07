import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/maps/google_maps_place_picker.dart';
import 'package:rideon_driver/models/googleModel/GeocodingModel.dart';
import 'package:rideon_driver/models/pooling/counterModel.dart';
import 'package:rideon_driver/models/pooling/sharingModel.dart';
import 'package:rideon_driver/screens/pooling/passengerScreen.dart';
import 'package:rideon_driver/screens/pooling/shareSearching.dart';

class CarPoolingFirst extends StatefulWidget {
  @override
  _CarPoolingFirstState createState() => _CarPoolingFirstState();
}

class _CarPoolingFirstState extends State<CarPoolingFirst> {
  LocationDetail _fromAddress = LocationDetail();
  LocationDetail _toAddress = LocationDetail();
  TextEditingController _fromController;
  TextEditingController _toController;

  DateTime _selectedDate;
  TextEditingController _dateController = TextEditingController();

  List<bool> _isFilled = [true, true, false];

  @override
  void initState() {
    super.initState();
    var passenger = context.read<PassengerCounter>();
    passenger.value = 0;
    _fromController =
        TextEditingController(text: _fromAddress.formattedAddress ?? '');
    _toController =
        TextEditingController(text: _toAddress.formattedAddress ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
          child: Column(children: [
            Text('Share a ride', style: TextStyle(fontSize: 30)),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlacePicker(
                                usePlaceDetailSearch: true,
                                initialPosition: SOURCE_LOCATION,
                                useCurrentLocation: true,
                                onPlacePicked: (r) {
                                  Navigator.pop(context);
                                  setState(() {
                                    _fromController.text = r.formattedAddress;
                                    _fromAddress =
                                        LocationDetail.fromPickResult(r);
                                  });
                                })));
                  },
                  child: TextFormField(
                    enabled: false,
                    maxLines: 3,
                    minLines: 1,
                    keyboardType: TextInputType.streetAddress,
                    controller: _fromController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        hintText: "Leaving Form",
                        labelStyle: normalStyle),
                  ),
                ),
              ),
            ),
            IconButton(
                padding: EdgeInsets.only(bottom: 5),
                icon: Icon(
                  Icons.swap_vert_sharp,
                  size: 40,
                ),
                onPressed: () {
                  LocationDetail _temp = _toAddress;
                  _toAddress = _fromAddress;
                  _fromAddress = _temp;
                  setState(() {
                    _fromController.text = _fromAddress.formattedAddress;
                    _toController.text = _toAddress.formattedAddress;
                  });
                }),
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlacePicker(
                                usePlaceDetailSearch: true,
                                initialPosition: SOURCE_LOCATION,
                                useCurrentLocation: true,
                                onPlacePicked: (r) {
                                  Navigator.pop(context);
                                  setState(() {
                                    _toController.text = r.formattedAddress;
                                    _toAddress =
                                        LocationDetail.fromPickResult(r);
                                  });
                                })));
                  },
                  child: TextFormField(
                    enabled: false,
                    maxLines: 3,
                    minLines: 1,
                    controller: _toController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        hintText: "Going to",
                        labelStyle: normalStyle),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text(_dateController.text == ''
                      ? 'Today'
                      : _dateController.text),
                  onPressed: () => _selectDate(context),
                ),
                OpenContainer(
                    closedElevation: 0,
                    openColor: Theme.of(context).scaffoldBackgroundColor,
                    closedColor: Theme.of(context).scaffoldBackgroundColor,
                    openBuilder: (BuildContext context,
                        void Function({Object returnValue}) action) {
                      return Center(child: PassengerScreen());
                    },
                    closedBuilder:
                        (BuildContext context, void Function() action) {
                      return Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: Consumer<PassengerCounter>(
                            builder: (context, passenger, child) => Text(
                              passenger.value == 0
                                  ? 'Passenger'
                                  : passenger.value.toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  wordSpacing: 2,
                                  color: Colors.white,
                                  letterSpacing: 2),
                            ),
                          ));
                    }),
              ],
            ),
            Consumer<PassengerCounter>(
                builder: (context, passenger, child) => !_isFilled
                            .contains(false) &&
                        passenger.value != 0
                    ? ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 8),
                          child: Text('Search'),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CarShareSearching(
                                      SharingModel(
                                          fromLocation: "HatKhola, Biratnagar",
                                          toLocation: "DarbarMargh Kathmandu",
                                          passenger: passenger.value,
                                          date: _selectedDate))));
                        },
                      )
                    : Container())
          ]),
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2022),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.tealAccent,
                onPrimary: Colors.white,
                surface: Colors.teal,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.green[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      setState(() {
        _dateController
          ..text = DateFormat.yMMMd().format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: _dateController.text.length,
              affinity: TextAffinity.upstream));
        _isFilled[2] = true;
      });
    }
  }
}
