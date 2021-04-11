import 'package:flutter/material.dart';
import 'package:rideon_driver/config/constant.dart';

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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.red)))),
    ),
    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.black87),
      
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.black54),
      disabledBorder: Constant.inputBorder,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      enabledBorder: Constant.inputBorder,      
      // or any other color
    ));
