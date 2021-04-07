import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/models/user/userModel.dart';
import 'package:rideon_driver/screens/home/homePageWarper.dart';
import 'package:rideon_driver/screens/login/loginPage.dart';
import 'package:rideon_driver/screens/widgets/appButton.dart';
import 'package:rideon_driver/screens/widgets/customCard.dart';
import 'package:rideon_driver/services/login/loginManager.dart';
import 'package:intl/intl.dart';

enum Gender { male, female, other }

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController _phoneNumberCOntroller;
  TextEditingController _passwordCOntroller,
      _nameCotroler,
      _econtact,
      _emailController;
  String gender;
  final _formKey = GlobalKey<FormState>();
  FocusNode _pwFocus;
  DateTime _selectedDate;
  TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameCotroler = TextEditingController(text: "");
    _phoneNumberCOntroller = TextEditingController(text: "");
    _passwordCOntroller = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _econtact = TextEditingController(text: "");
    _dateController = TextEditingController(text: "");
    _pwFocus = FocusNode();
  }

  Gender _gender = Gender.male;

  @override
  void dispose() {
    super.dispose();
    _phoneNumberCOntroller.dispose();
    _passwordCOntroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _manager = Provider.of<LoginManger>(context);

    return Scaffold(
        appBar: AppBar(title: Text('Register on  Ride on')),
        body: Container(
          padding: EdgeInsets.all(8),
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _nameCotroler,
                          onFieldSubmitted: (v) {
                            _pwFocus.requestFocus();
                          },
                          validator: (value) {
                            if (value.isEmpty)
                              return 'Enter Full Name';
                            else if (value.length < 5 && !value.contains(' '))
                              return "Enter Valid Name";
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person_rounded,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              errorStyle: TextStyle(color: textColor),
                              /*   errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)), */
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24),
                                  borderSide: BorderSide(color: Colors.green)),
                              labelText: "Full Name"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _phoneNumberCOntroller,
                          focusNode: _pwFocus,
                          onFieldSubmitted: (v) {
                            _pwFocus.requestFocus();
                          },
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: (s) {
                            if (s.trim().length < 6)
                              return phoneValidationError;
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              errorStyle: TextStyle(color: textColor),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                              counterText: "",
                              labelText: "Phone Number"),
                        ),
                      ),
                      //date
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          focusNode: AlwaysDisabledFocusNode(),
                          onTap: () {
                            _selectDate(context);
                          },
                          controller: _dateController,
                          onFieldSubmitted: (v) {
                            _pwFocus.requestFocus();
                          },
                          validator: (s) {
                            if (s.isEmpty)
                              return 'Please select date of birth';
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.date_range_outlined,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              errorStyle: TextStyle(color: textColor),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                              labelText: "Date of Birth"),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _econtact,
                          onFieldSubmitted: (v) {
                            _pwFocus.requestFocus();
                          },
                          keyboardType: TextInputType.phone,
                          validator: (s) {
                            if (s.trim().length < 6)
                              return 'Phone number must have exactly 10 digits';
                            else
                              return null;
                          },
                          maxLength: 10,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.contact_phone,
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              errorStyle: TextStyle(color: textColor),
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12),
                              counterText: "",
                              labelText: "Emergency Contact"),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _emailController,
                          validator: (value) {
                            if (value.isNotEmpty) {
                              if (value.length < 5)
                                return "Enter Valid Name";
                              else
                                return null;
                            } else
                              return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mail_outline_outlined,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24)),
                            errorStyle: TextStyle(color: textColor),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 12),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide(color: Colors.green)),
                            labelText: "Email",
                            hintText: "Enter valid email",
                          ),
                        ),
                      ),

                      //gender
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          height: 20,
                          child: Text(
                            "Select Gender",
                            style: TextStyle(color: textColor),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Radio(
                              value: Gender.male,
                              groupValue: _gender,
                              activeColor: Colors.black,
                              onChanged: (x) {
                                setState(() {
                                  _gender = x;
                                });
                              }),
                          new Text(
                            'Male',
                            style: new TextStyle(fontSize: 16.0),
                          ),
                          new Radio(
                              value: Gender.female,
                              activeColor: Colors.black,
                              groupValue: _gender,
                              onChanged: (x) {
                                setState(() {
                                  _gender = x;
                                });
                              }),
                          new Text(
                            'Female',
                            style: new TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          new Radio(
                            value: Gender.other,
                            activeColor: Colors.black,
                            groupValue: _gender,
                            onChanged: (x) {
                              setState(() {
                                _gender = x;
                              });
                            },
                          ),
                          new Text(
                            'Others',
                            style: new TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ValueListenableBuilder<LoginStates>(
                valueListenable: _manager.currentState,
                builder: (con, val, _) {
                  if (val == LoginStates.error)
                    showLoginFailMessage(context, _manager);
                  return AnimatedSwitcher(
                    child: val == LoginStates.loading
                        ? SizedBox(
                            key: ValueKey("1"),
                            height: 50,
                            child: Center(child: CircularProgressIndicator()))
                        : SizedBox(
                            /* width:
                                      MediaQuery.of(context).size.width * .554,*/
                            key: ValueKey("2"),
                            //height: 50,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  //todo:navigation to login
                                  InkWell(
                                    onTap: () {
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ));
                                    },
                                    child: RichText(
                                      text: TextSpan(
                                          style: TextStyle(color: Colors.black),
                                          children: [
                                            TextSpan(
                                              text: 'Already account? ',
                                            ),
                                            TextSpan(
                                                text: 'login',
                                                style: TextStyle(
                                                    color: textColor))
                                          ]),
                                    ),
                                  ),
                                  AppButton().appButton(
                                    small: true,
                                    text: "Continue",
                                    onTap: () async {
                                      FocusScope.of(context).unfocus();
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        _manager.register(User(
                                            id: 1,
                                            name: _nameCotroler.text,
                                            phone: _phoneNumberCOntroller.text,
                                            email: _emailController.text,
                                            gender: 'male',
                                            paymentId: null,
                                            dob: _dateController.text)).then((value) =>  Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePageWrapper(),
                                            )));
                                       
                                      }
                                    },
                                  ),
                                ],
                              ),
                            )),
                    duration: Duration(milliseconds: 400),
                  );
                },
              ),
            ],
          ),
        ));
  }

  void showLoginFailMessage(context, manager) {
    Future.delayed(Duration(seconds: 1), () {
      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(manager.errorText ?? defaultloginError)));
    });
  }

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
        firstDate: DateTime(1910),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.tealAccent,
                onPrimary: Colors.white,
                surface: Colors.teal,
                onSurface: Colors.yellow,
              ),
              dialogBackgroundColor: Colors.green[500],
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _dateController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _dateController.text.length,
            affinity: TextAffinity.upstream));
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
