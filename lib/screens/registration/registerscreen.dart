import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/models/user/userModel.dart';
import 'package:rideon_driver/screens/registration/documents_process.dart';
import 'package:rideon_driver/widget/appButton.dart';
import 'package:rideon_driver/widget/customCard.dart';
import 'package:rideon_driver/services/login/loginManager.dart';
import 'package:rideon_driver/services/utils/extension.dart';

import 'package:intl/intl.dart';

enum Gender { male, female, other }

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  late TextEditingController _phoneController,
      _nameCotroler,
      _emergencyPhoneController,
      _dateController,
      _emailController;
  String? gender;
  final _formKey = GlobalKey<FormState>();
  late FocusNode _phoneFocus, _emergencyFocus, _emailFocus;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameCotroler = TextEditingController(text: "");
    _phoneController = TextEditingController(text: "");
    _emailController = TextEditingController(text: "");
    _emergencyPhoneController = TextEditingController(text: "");
    _dateController = TextEditingController(text: "");
    _phoneFocus = FocusNode();
    _emergencyFocus = FocusNode();
    _emailFocus = FocusNode();
  }

  Gender _gender = Gender.male;

  @override
  void dispose() {
    _nameCotroler.dispose();
    _phoneController.dispose();
    _dateController.dispose();
    _emergencyPhoneController.dispose();
    _emailController.dispose();
    _phoneFocus.unfocus();
    _emergencyFocus.unfocus();
    _emailFocus.unfocus();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _manager = Provider.of<LoginManger>(context);

    return Scaffold(
        appBar: AppBar(title: Text('Personal Details')),
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
                            _phoneFocus.requestFocus();
                          },
                          validator: (value) {
                            if (value == null)
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
                              hintText: 'Full Legal Name',
                              labelText: "Name"),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          onFieldSubmitted: (v) {
                            _phoneFocus.unfocus();
                            _selectDate(context);
                          },
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          validator: (s) {
                            if(s == null) return 'Please enter valid phone number';
                            return s.isValidPhone()
                                ? null
                                : "${s.trim().length > 0 ? s + " is not a" : "Please enter a"} valid phone number.";
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: Colors.grey,
                              ),
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
                          validator: (s) {
                            if (s == null)
                              return 'Please select date of birth';
                            else
                              return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.date_range_outlined,
                                color: Colors.grey,
                              ),
                              labelText: "Date of Birth"),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _emergencyPhoneController,
                          onFieldSubmitted: (v) {
                            _emailFocus.requestFocus();
                          },
                          keyboardType: TextInputType.phone,
                          validator: (s) {
                            if(s == null) return 'Please enter valid phone';
                            return s.isValidPhone()
                                ? null
                                : "${s.trim().length > 0 ? s + " is not a" : "Please enter a"} valid phone number.";
                          },
                          maxLength: 10,
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.contact_phone,
                                color: Colors.grey,
                              ),
                              counterText: "",
                              labelText: "Emergency Contact"),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _emailController,
                          onFieldSubmitted: (v) {
                            _emailFocus.unfocus();
                          },
                          validator: (s) {
                            if(s== null) return 'Please enter valid email';
                            return s.isValidEmail()
                                ? null
                                : "${s.trim().length > 0 ? s + " is not a" : "Please enter a"} valid email address.";
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.mail_outline_outlined,
                              color: Colors.grey,
                            ),
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
                                  _gender = x as Gender;
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
                                  _gender = x as Gender;
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
                                _gender = x as Gender;
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
                              child: AppButton().appButton(
                                small: false,
                                color: Colors.redAccent,
                                text: "Continue",
                                onpressed: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    _manager
                                        .register(User(
                                            id: 1,
                                            name: _nameCotroler.text,
                                            phone: _phoneController.text,
                                            email: _emailController.text,
                                            gender: 'male',
                                            paymentId: null,
                                            dob: _dateController.text))
                                        .then((value) => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DocumentProcessScreen(),
                                            )));
                                  }
                                },
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
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(manager.errorText ?? defaultloginError)));
    });
  }

  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate as DateTime : DateTime.now(),
        firstDate: DateTime(1910),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                //primary: Colors.tealAccent,
                onPrimary: Colors.white,
                surface: Colors.redAccent,
                onSurface: Colors.black45,
              ),
              textTheme: TextTheme(bodyText2: TextStyle(color: Colors.blue)),
              dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _dateController
        ..text = DateFormat.yMMMd().format(_selectedDate!)
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
