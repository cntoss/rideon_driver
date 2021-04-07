import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/models/pooling/counterModel.dart';

class PassengerScreen extends StatefulWidget {
  @override
  _PassengerScreenState createState() => _PassengerScreenState();
}

class _PassengerScreenState extends State<PassengerScreen> {
  

  @override
  Widget build(BuildContext context) {
    var passenger = Provider.of<PassengerCounter>(context);

    return WillPopScope(
      onWillPop: () async {
        // var passenger = context.read<PassengerCounter>();
        if (passenger.value == 0) {
          passenger.increment();
        }
        return true;
      },
      child: Scaffold(
        body: Container(
            margin: EdgeInsets.only(
                left: 50,
                top: MediaQuery.of(context).size.height / 3,
                right: 50),
            child: Column(
              children: [
                Text(
                  'Select Number of seats to book',
                  style: title.copyWith(fontSize: 22),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: passenger.value > 1
                              ? Icon(Icons.remove_circle_outline_outlined)
                              : Icon(Icons.remove_circle),
                          iconSize: 50,
                          color: passenger.value > 1
                              ? Colors.blueGrey
                              : Colors.black38,
                          onPressed: () {
                            // var passenger = context.read<PassengerCounter>();
                            if (passenger.value > 1) {
                              passenger.decrement();
                            }
                          }),
                      /* Consumer<PassengerCounter>(
                          builder: (context, passenger, child) => Text(
                                passenger.value == 0
                                    ? '1'
                                    : passenger.value.toString(),
                                style: titleWhite,
                              )), */
                      Text(
                        passenger.value == 0 ? '1' : passenger.value.toString(),
                        style: title,
                      ),
                      IconButton(
                          icon: passenger.value > 7
                              ? Icon(Icons.add_circle_rounded)
                              : Icon(Icons.add_circle_outline),
                          iconSize: 50,
                          color: passenger.value < 8
                              ? Colors.blueGrey
                              : Colors.black38,
                          onPressed: () {
                            // var passenger = context.read<PassengerCounter>();
                            if (passenger.value < 8) {
                              passenger.increment();
                            }
                          }),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (passenger.value == 0) {
                        passenger.increment();
                      }
                      Navigator.pop(context);
                    },
                    child: Text('Continue'))
              ],
            )),
      ),
    );
  }
}
