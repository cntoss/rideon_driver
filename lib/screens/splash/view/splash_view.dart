import 'package:flutter/material.dart';
import 'package:rideon_driver/screens/login/initialLandingPage.dart';
import 'package:rideon_driver/services/helper/userService.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
    UserService().setIsWorkThrough();
  }

  navigate() async {
    Future.delayed(
        Duration(seconds: 0),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => InitialLandingPage(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    //var height = MediaQuery.of(context).size.height;
    //var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        child: Image.asset(
          "assets/rideon.png",
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
