import 'package:flutter/material.dart';
import 'package:rideon_driver/config/constant.dart';
class AppButton{

Widget appButton(
      {@required String text,
      @required Function() onTap,
      bool small = false,
      Color color}) {
    return MaterialButton(
      elevation: 1,
      focusElevation: 1,
      color: color  != null? color : Colors.blue,
      shape: StadiumBorder(),
      onPressed: () async {
        onTap();
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: small ? 20.0 : 60.0 , vertical: 8),
        child: Text(
          text,
          style: title.copyWith(fontSize: 20),
        ),
      ),
    );
  }
}
