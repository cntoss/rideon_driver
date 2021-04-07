import 'package:flutter/material.dart';

const Color stackfoldBackground = Color(0xfff5ead7);

const String passwordValidationError =
    "Password must contain at least 6 characters.";
const String phoneValidationError = "Phone number must have exactly 10 digits ";
const String defaultloginError =
    'Woopsie! Login Failed, please retry in a minute or so.';

const Color lightAccent = Color(0xffFFEE58);
const Color lightAccentComplimentary = Color(0xffFFaa58);
const Color darkAccent = Color(0xff11998e);
const Color lightBG = Color(0xffffffff);
const Color darkBG = Colors.black;
const Color textColor = Colors.black45;
const Color textFormColor = Color(0xff0acf8a);
const Color cardColor = Color(0xfffefaf0);
const TextStyle errorStyle = TextStyle(color: Colors.redAccent, fontSize: 16);
const TextStyle normalStyle = TextStyle(color: textColor, fontSize: 16);

const TextStyle title = const TextStyle(
    inherit: false,
    color: Color(0x8a000000),
    fontFamily: "Roboto",
    fontSize: 28.0,
    fontWeight: FontWeight.w400,
    decoration: TextDecoration.none);

const TextStyle bottonTextStyle =
    const TextStyle(inherit: false, color: Colors.black, fontSize: 16);
const EdgeInsetsGeometry bottonPadding = EdgeInsets.all(12.0);

class Constant {
  static ButtonStyle buttonStyle = TextButton.styleFrom(
      textStyle: TextStyle(fontSize: 14, letterSpacing: 1, wordSpacing: 1));
  static OutlineInputBorder inputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.black12),
      borderRadius: BorderRadius.circular(10));

  static List<Color> get tileGradient =>
      [lightAccent, lightAccentComplimentary];
  static ThemeData lightTheme = ThemeData(
    backgroundColor: lightBG,
    primaryColor: lightBG,
    accentColor: lightAccent,
    textSelectionTheme: TextSelectionThemeData(cursorColor: lightAccent),
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: darkBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    //fontFamily: GoogleFonts.roboto().fontFamily,
    backgroundColor: darkBG,
    primaryColor: darkBG,
    accentColor: darkAccent,
    scaffoldBackgroundColor: darkBG,
    textSelectionTheme: TextSelectionThemeData(cursorColor: darkAccent),
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
        headline6: TextStyle(
          color: lightBG,
          fontSize: 18.0,
          fontWeight: FontWeight.w800,
        ),
      ),
//      iconTheme: IconThemeData(
//        color: darkAccent,
//      ),
    ),
  );
}
