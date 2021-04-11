import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon_driver/screens/home/homePageWarper.dart';
import 'package:rideon_driver/screens/login/loginPage.dart';
import 'package:rideon_driver/screens/splashScreen.dart';
import 'package:rideon_driver/services/login/loginManager.dart';

class LoginWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var loginManager =Provider.of<LoginManger>(context);
    return ValueListenableBuilder(
      valueListenable: loginManager.currentState,
      builder: (BuildContext context,LoginStates currentState, Widget child) {
      return  currentState==LoginStates.loggedIn ? HomePageWrapper(): SplashScreen() ;
      },
    );
  }

}

