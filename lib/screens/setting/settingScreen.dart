import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/models/user/userModel.dart';
import 'package:rideon_driver/screens/profile/profileScreen.dart';
import 'package:rideon_driver/services/helper/userService.dart';
import 'package:rideon_driver/services/login/loginManager.dart';
import 'package:rideon_driver/services/utils/extension.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  User _user = UserService().getUser();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            ProfileBox(
              user: _user,
            ),
            customCard(
                child: customRow(
              icon: Icon(Icons.language),
              title: 'Language',
            )),
            customCard(
                child: customRow(
              icon: Icon(Icons.security),
              title: 'Permission',
            )),
            customCard(
                child: customRow(
              icon: Icon(Icons.attach_money),
              title: 'Add Payment',
            )),
            customCard(
                child: customRow(
              icon: Icon(Icons.money),
              title: 'Refer And Earn',
            )),
            customCard(
                child: customRow(
              icon: Icon(Icons.help),
              title: 'Help',
            )),
            customCard(
                child: customRow(
              icon: Icon(Icons.privacy_tip),
              title: 'Privacy Policy',
            )),
            customCard(
                child: InkWell(
              onTap: () {
                Provider.of<LoginManger>(context, listen: false)
                    .logout(() => print("error logout"));
              },
              child: customRow(
                icon: Icon(Icons.logout),
                title: 'Logout',
              ),
            ))
          ],
        ),
      ),
    );
  }

  customRow({Icon icon, String title, String subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                // Text(subtitle ?? '')
              ],
            ),
          )
        ],
      ),
    );
  }

  customCard({Widget child}) {
    return Card(
        color: cardColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: child);
  }
}

class ProfileBox extends StatelessWidget {
  const ProfileBox({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: cardColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 3.5,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: user.image.isNullOrEmpty()
                    ? Image.asset('assets/logo_mini.png')
                    : NetworkImage(user.image),
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                      child: Text(
                        user.name ?? '',
                        style: Theme.of(context).textTheme.headline5,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
                        Text(user.phone ?? ''),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            color: Colors.black54,
                            height: 20,
                            width: 2,
                          ),
                        ),
                        Text('Lalitpur'),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[350],
                                  border: Border(),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Row(
                                  children: [
                                    Text('0.0'),
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow,
                                    )
                                  ],
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            border: Border(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text('unverified'),
                        )),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          textStyle: TextStyle(fontSize: 16)),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(user: user))),
                      child: Text('Update My Profile'))
                ],
              ),
            )
          ],
        ));
  }
}
