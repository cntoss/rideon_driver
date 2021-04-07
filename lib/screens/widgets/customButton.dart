import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';

class CustomDialog {
  Widget dialogButton(
      {@required String text, @required VoidCallback onPressed, Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton(
      onPressed: onPressed,
        color: color != null
            ? color
            : Theme.of(AppConfig.navigatorKey.currentContext)
                .buttonTheme
                .colorScheme,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}