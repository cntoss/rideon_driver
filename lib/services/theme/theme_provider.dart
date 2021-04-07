import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:rideon_driver/config/appConfig.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/services/helper/hiveService.dart';

class ThemeProvider extends ChangeNotifier {
  Box _box = HiveService().getHiveBox();

  ThemeProvider() {
    checkTheme();
  }

  ThemeData theme = Constant.lightTheme;
  Key key = UniqueKey();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void setKey(value) {
    key = value;
    notifyListeners();
  }

  void setNavigatorKey(value) {
    navigatorKey = value;
    notifyListeners();
  }

  void setTheme(value, c) {
    theme = value;
    _box
        .put(
      hkTheme,
      'light',
    )
        .then((value) {
      {
        SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor:
              c == "dark" ? darkBG : lightBG,
          statusBarIconBrightness:
              c == "dark" ? Brightness.light : Brightness.dark,
        ));
      }
    });
    notifyListeners();
  }

  ThemeData getTheme(value) {
    return theme;
  }

  Future<ThemeData> checkTheme() async {
    ThemeData theme;
    String current = _box.get(
      hkTheme,
      defaultValue: 'light',
    );

    if (current == "light") {
      theme = Constant.lightTheme;
      setTheme(Constant.lightTheme, "light");
    } else {
      theme = Constant.darkTheme;
      setTheme(Constant.darkTheme, "dark");
    }

    return theme;
  }
}
