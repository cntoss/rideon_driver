import 'package:flutter/material.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/models/profile/documentModel.dart';
import 'package:rideon_driver/models/user/userModel.dart';
import 'package:rideon_driver/screens/profile/addFIle.dart';
import 'package:rideon_driver/screens/profile/changePasswordScreen.dart';
import 'package:rideon_driver/screens/profile/profileEditScreen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;
  ProfileScreen({required this.user, Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState(this.user);
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileScreenState(this._user);
  User _user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(14.0),
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            ProfileBox(user: _user),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, index) {
                return Opacity(
                  opacity: (10 - index) / 10.toDouble(),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AddFileScreen(documents[index])));
                    },
                    child: Card(
                      color: cardColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    documents[index].title,
                                    style: title.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  if (documents[index].stage ==
                                      DocumentStage.done)
                                    Text('Completed'),
                                  if (documents[index].stage ==
                                      DocumentStage.redy)
                                    Text('Ready to begin'),
                                  if (documents[index].stage ==
                                      DocumentStage.attention)
                                    Text(
                                      'Needs your attentions',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios_outlined)
                            ]),
                      ),
                    ),
                  ),
                );
              },
              itemCount: documents.length,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen()));
              },
              child: Card(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Password Change',
                          style: title.copyWith(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.arrow_forward_ios_outlined)
                      ]),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class ProfileBox extends StatelessWidget {
  const ProfileBox({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProfileEditScreen(user: user)));
      },
      child: Card(
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
                  child: user.image == null
                      ? Image.asset('assets/logo_mini.png')
                      : NetworkImage(user.image!) as Widget,//v2
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
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    border: Border(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
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
                  ],
                ),
              )
            ],
          )),
    );
  }
}
