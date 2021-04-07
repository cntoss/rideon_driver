import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'package:rideon_driver/models/connectivity/connectivity_status.dart';

class NetworkSensitive extends StatelessWidget {
  final Widget child;

  NetworkSensitive({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Get our connection status from the provider
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    if (connectionStatus == ConnectivityStatus.WiFi) {
      return child;
    }

    if (connectionStatus == ConnectivityStatus.Cellular) {
      return child;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('No Internet'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey[300],
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.network_check, size: 80, color: Colors.blueGrey),
                    Text(
                      "You're offline..!!! No Internet Connection.",
                      style: GoogleFonts.lato(color: Colors.red, fontSize: 20),
                    )
                  ]),
            )));
    // }
  }
}
