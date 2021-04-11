import 'package:flutter/material.dart';
import 'package:rideon_driver/screens/login/loginPage.dart';
import 'package:rideon_driver/screens/registration/registerscreen.dart';

class RegistrationSelectVehicle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Choose the vehicle you have'),
            ),
            _optionWidget(context, Icons.bike_scooter, 'Bike'),
            _optionWidget(context, Icons.local_taxi_rounded, 'Car'),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 12,
        //color: Color(0xfff2ffc7),
        decoration: BoxDecoration(
          color: Color(0xfff2ffc7),
        ),
        // color: Colors.yellowAccent,
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ));
            },
            child: RichText(
              text: TextSpan(style: TextStyle(color: Colors.black), children: [
                TextSpan(
                  text: 'Already have an account? ',
                ),
                TextSpan(text: 'Login', style: TextStyle(color: Colors.blue))
              ]),
            ),
          ),
        ),
      )),
    );
  }

  Container _optionWidget(BuildContext context, IconData icon, title) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12),
      child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Registration(),
                ));
          },
          child: Row(
            children: [
              Icon(icon),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios)
            ],
          )),
    );
  }
}
