import 'package:flutter/material.dart';

class CircularIcon extends StatelessWidget {
  final Icon icon;
  const CircularIcon({
    this.icon,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: icon,
        ),
        shape: CircleBorder(),
        color: Colors.grey,
        elevation: 1,
      ),
    );
  }
}
