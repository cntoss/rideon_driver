import 'package:flutter/material.dart';
import 'package:rideon_driver/config/constant.dart';

class AppButton {
  Widget appButton(
      {required String text,
      required VoidCallback onpressed,
      bool small = false,
      Color textColor = Colors.white,
      Color color = Colors.blue}) {
    return MaterialButton(
      elevation: 1,
      focusElevation: 1,
      color: color,    
      shape: StadiumBorder(),
      onPressed: onpressed,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: small ? 20.0 : 60.0, vertical: 8),
        child: Text(
          text,
          style: title.copyWith(fontSize: 20, color: textColor),
        ),
      ),
    );
  }
}
