import 'package:flutter/material.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/models/user/userModel.dart';
import 'package:rideon_driver/screens/login/loginPage.dart';
import 'package:rideon_driver/screens/registration/documents_process.dart';
import 'package:rideon_driver/widget/appButton.dart';
import 'package:rideon_driver/services/firebase/firebaseService.dart';
import 'package:rideon_driver/services/helper/locationServiceEnable.dart';

class InitialLandingPage extends StatefulWidget {
  @override
  _InitialLandingPageState createState() => _InitialLandingPageState();
}

class _InitialLandingPageState extends State<InitialLandingPage> {
  @override
  void initState() {
    super.initState();
    LocationService().getLocation();
    FirebaseService().getFirebaseToken();
  }

  getss() async {
    var token = await FirebaseService().getFirebaseToken();
    print(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Image.asset(
            'assets/rideon.png',
            height: MediaQuery.of(context).size.height / 2,
            width: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
            //color: Theme.of(context).scaffoldBackgroundColor,
          ),
          Container(
            decoration: BoxDecoration(
                gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xffffffff),
                Color(0xfffffbff),
                Color(0xfffffbfa),
                Color(0xfffafbf8),
                Theme.of(context).scaffoldBackgroundColor,
              ],
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Welcome to Rideon Driver', style: title),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 4,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppButton().appButton(
                      text: 'Get Started',
                      color: Colors.red,
                      onpressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DocumentProcessScreen(user: User()),
                            ));
                      },
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginPage(),
                              ));
                        },
                        child: Text('Login'))
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
