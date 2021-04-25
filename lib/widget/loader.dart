import 'package:flutter/material.dart';

import 'chasing_dots.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.6,
          child: Container(
            color: Colors.black,
            height: MediaQuery.of(context).size.height,
          ),
        ),
        Center(
          child: SpinKitChasingDots(
            size: 50.0,
            color: Colors.white           
          ),
        ),
      ],
    );
  }
}
