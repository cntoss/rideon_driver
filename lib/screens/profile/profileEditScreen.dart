import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/models/user/userModel.dart';
import 'package:rideon_driver/screens/profile/add_single_field.dart';
import 'package:rideon_driver/screens/widgets/customCard.dart';
import 'package:rideon_driver/services/utils/extension.dart';

enum FieldType { email, phone }

class ProfileEditScreen extends StatefulWidget {
  final User user;
  ProfileEditScreen({this.user, Key key}) : super(key: key);
  @override
  _ProfileEditScreenState createState() => _ProfileEditScreenState(this.user);
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  _ProfileEditScreenState(this._user);
  User _user;
  bool _enable = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _phoneNumberCOntroller,
      _econtact,
      _nameCotroler,
      _emailController;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneNumberCOntroller = TextEditingController(text: _user.phone);
    _emailController = TextEditingController(text: _user.email ?? '');
    _nameCotroler = TextEditingController(text: _user.name);
    _econtact = TextEditingController(text: "");
    _dateController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: ListView(
          children: [
            CustomCard(
              child: Stack(children: [
                CircleAvatar(
                  backgroundImage: _user.image.isNullOrEmpty()
                      ? AssetImage('assets/avatar.png')
                      : NetworkImage(_user.image),
                  radius: 50,
                ),
                /*  child: _user.image.isNullOrEmpty()
                      ? Image.asset('assets/avatar.png')
                      : NetworkImage(_user.image) */

                if (_enable)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Icon(Icons.camera_alt_outlined),
                  )
              ]),
            ),
            CustomCard(
                child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: TextFormField(
                      controller: _nameCotroler,
                      //enabled: _enable,
                      readOnly: true,
                      onTap: () => _showNotic(),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_rounded,
                          color: Colors.grey,
                        ),
                        labelText: "Full Name",
                      ),
                    ),
                  ),
                  OpenContainer(
                    closedElevation: 0,
                    openColor: Theme.of(context).scaffoldBackgroundColor,
                    closedColor: cardColor,
                    openBuilder: (BuildContext context,
                        void Function({Object returnValue}) action) {
                      return Center(child: AddSingleField(FieldType.phone));
                    },
                    closedBuilder:
                        (BuildContext context, void Function() action) {
                      return Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: TextFormField(
                          controller: _phoneNumberCOntroller,
                          enabled: _enable,
                          decoration: InputDecoration(
                            labelStyle: TextStyle(height: 0.5),
                            prefixIcon: Icon(
                              Icons.phone_iphone_rounded,
                              color: Colors.grey,
                            ),
                            labelText: "Phone Number",
                          ),
                        ),
                      );
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: TextFormField(
                      controller: _econtact,
                      //enabled: _enable,
                      readOnly: true,
                      onTap: () => _showNotic(),
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.contact_phone,
                            color: Colors.grey,
                          ),
                          labelText: "Emergency Contact"),
                    ),
                  ),

                  OpenContainer(
                    closedElevation: 0,
                    openColor: Theme.of(context).scaffoldBackgroundColor,
                    closedColor: cardColor,
                    openBuilder: (BuildContext context,
                        void Function({Object returnValue}) action) {
                      return Center(child: AddSingleField(FieldType.email));
                    },
                    closedBuilder:
                        (BuildContext context, void Function() action) {
                      return Padding(
                        padding: const EdgeInsets.only(top:8.0),
                        child: TextFormField(
                          controller: _emailController,
                          enabled: _enable,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mail_outline_outlined,
                              color: Colors.grey,
                            ),
                            labelText: "Email",
                          ),
                        ),
                      );
                    },
                  ),
                  //date
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: TextFormField(
                      //enabled: _enable,
                      readOnly: true,
                      onTap: () => _showNotic(),
                      controller: _dateController,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.date_range_outlined,
                            color: Colors.grey,
                          ),
                          labelText: "Date of Birth"),
                    ),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }

  _showNotic() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 100.0),
        content: Text('Contact support to edit this field')));
  }
}
