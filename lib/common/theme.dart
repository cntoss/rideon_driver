import 'package:flutter/material.dart';

final appTheme = ThemeData(
 primarySwatch: Colors.red,
  primaryColor: Color(0xfffafbf8),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  scaffoldBackgroundColor: Color(0xfffafbf8),
  focusColor: Colors.white60,
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          primary: Colors.black,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          textStyle:
              TextStyle(fontSize: 20, wordSpacing: 2, letterSpacing: 2))),
  /* textTheme: TextTheme(
          bodyText2:TextStyle(color: Colors.white)
        ) */
);
