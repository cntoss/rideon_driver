import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/screens/registration/registration_select.dart';
import 'package:rideon_driver/widget/appButton.dart';
import 'package:rideon_driver/widget/customCard.dart';
import 'package:rideon_driver/services/utils/extension.dart';
import 'package:rideon_driver/services/login/loginManager.dart';

class LoginPage extends StatefulWidget {
  final bool fromRegistration;
  LoginPage({this.fromRegistration = false});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _phoneController;
  late TextEditingController _passwordCOntroller;
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _showLoading = false;
  bool _showOtp = false;
  String? _otpValue;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;
  late TextEditingController otp1, otp2, otp3, otp4, otp5, otp6;
  List<TextEditingController> _otp =
      List.generate(6, (i) => TextEditingController());
  List<FocusNode> _focus = List.generate(6, (i) => FocusNode());

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController(text: "");
    _passwordCOntroller = TextEditingController(text: "");
    _otpValue = '';
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _passwordCOntroller.dispose();
  }

  void _changefieldFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential, LoginManger _manager) async {
    setState(() {
      _showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _showLoading = false;
      });
      if (authCredential.user != null) {
        _manager.login(
            phone: _phoneController.text, password: _phoneController.text);
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _showLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message!)));
    }
  }

  verification(context) async {
    setState(() {
      _showLoading = true;
    });
    await _auth.verifyPhoneNumber(
      phoneNumber: ['+977', _phoneController.text].join('').trim(),
      //phoneNumber: '+9779829326110',

      verificationCompleted: (phoneAuthCredential) async {
        setState(() {
          _showLoading = false;
        });
        //signInWithPhoneAuthCredential(phoneAuthCredential);
      },
      verificationFailed: (verificationFailed) async {
        setState(() {
          _showLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(verificationFailed.message!)));
      },
      codeSent: (verificationId, resendingToken) async {
        setState(() {
          _showLoading = false;
          _showOtp = true;
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/logo_mini.png',
                height: MediaQuery.of(context).size.height / 3,
                width: MediaQuery.of(context).size.height,
              ),
              CustomCard(
                  child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.0),
                      child: !_showOtp
                          ? _showPhoneField(context)
                          : _showOtpField(context)))
              // if(_showLoading) Center(child: CircularProgressIndicator())
            ],
          ),
        ),
      ),
    );
  }

  Widget _showPhoneField(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              controller: _phoneController,
              onFieldSubmitted: (v) {
                FocusScope.of(context).unfocus();
              },
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (s) {
                if(s== null) return 'Enter valid phone number';
                return s.isValidPhone()
                                ? null
                                : "${s.trim().length > 0 ? s + " is not a" : "Please enter a"} valid phone number.";
                        
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.phone_iphone_rounded,
                  color: Colors.grey,
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                errorStyle: errorStyle,
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide(color: Colors.green)),
                counterText: '',
                hintText: "Phone Number",
              ),
            ),
          ),
          !widget.fromRegistration
              ? AnimatedSwitcher(
                  child: _showLoading
                      ? SizedBox(
                          key: ValueKey("1"),
                          height: 50,
                          child: Center(child: CircularProgressIndicator()))
                      : SizedBox(
                          /* width:
                                          MediaQuery.of(context).size.width * .554,*/
                          key: ValueKey("2"),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationSelectVehicle(),
                                      ));
                                },
                                child: RichText(
                                  text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      children: [
                                        TextSpan(
                                          text: 'Not account? ',
                                        ),
                                        TextSpan(
                                            text: 'sign up',
                                            style: TextStyle(color: textColor))
                                      ]),
                                ),
                              ),
                              AppButton().appButton(
                                small: true,
                                text: "Continue",
                                color: Colors.redAccent,
                                onpressed: () async {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    verification(context);
                                  }
                                },
                              ),
                            ],
                          )),
                  duration: Duration(milliseconds: 400),
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: AnimatedSwitcher(
                    child: _showLoading
                        ? SizedBox(
                            key: ValueKey("1"),
                            height: 50,
                            child: Center(child: CircularProgressIndicator()))
                        : SizedBox(
                            //width: MediaQuery.of(context).size.width * .554,
                            key: ValueKey("2"),
                            height: 50,
                            child: AppButton().appButton(
                              small: false,
                              text: "Continue",
                              color: Colors.redAccent,
                              onpressed: () async {
                                FocusScope.of(context).unfocus();
                                if (_formKey.currentState!.validate()) {
                                  verification(context);
                                }
                              },
                            )),
                    duration: Duration(milliseconds: 400),
                  ),
                )
        ],
      ),
    );
  }

  Widget _showOtpField(BuildContext context) {
    var _manager = Provider.of<LoginManger>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text('Enter 6 digit OTP From Your Message'),
        ),
        _boxBuilder(),
        SizedBox(
          height: 16,
        ),
        ValueListenableBuilder<LoginStates>(
          valueListenable: _manager.currentState,
          builder: (con, val, _) {
            if (val == LoginStates.error)
              showLoginFailMessage(context, _manager.errorText);
            return AnimatedSwitcher(
              child: val == LoginStates.loading
                  ? SizedBox(
                      key: ValueKey("1"),
                      height: 50,
                      child: Center(child: CircularProgressIndicator()))
                  : SizedBox(
                      key: ValueKey("2"),
                      height: 50,
                      child: AppButton().appButton(
                        small: true,
                        text: "Verify",
                        color: Colors.redAccent,
                        onpressed: () async {
                          List _finalOtp = [];
                          FocusScope.of(context).unfocus();
                          for (int i = 0; i < _otp.length; i++) {
                            if (_otp[i].text.isNotEmpty)
                              _finalOtp.add(_otp[i].text.trim());
                          }
                          _otpValue = _finalOtp.join('').trim();
                          print(_otpValue);
                          if (_otpValue!.length == 6) {
                            PhoneAuthCredential phoneAuthCredential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId as String,
                                    smsCode: _otpValue as String);
                            signInWithPhoneAuthCredential(
                                phoneAuthCredential, _manager);
                          } else {
                            showLoginFailMessage(context, otpEmptyError);
                          }
                        },
                      )),
              duration: Duration(milliseconds: 400),
            );
          },
        ),
      ],
    );
  }

  Widget _boxBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (int i = 0; i < _otp.length; i++)
          _box(_otp[i], _focus[i], i < 5 ? _focus[i + 1] : null),
      ],
    );
  }

  Widget _box(TextEditingController otpController, FocusNode currentFocus,
      FocusNode? nextFocus) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      alignment: Alignment.center,
      height: 50,
      width: 40,
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: otpController,
        maxLength: 1,
        focusNode: currentFocus,
        onChanged: (_) {
          setState(() {
            otpController.text = _;
          });
          if (nextFocus != null)
            _changefieldFocus(context, currentFocus, nextFocus);
          else
            currentFocus.unfocus();
        },
        decoration: InputDecoration(
            border: InputBorder.none,
            counterText: '',
            hintText: '*',
            contentPadding: EdgeInsets.symmetric(horizontal: 14)),
      ),
      //decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
    );
  }

  void showLoginFailMessage(context, errorMessage) {
    Future.delayed(Duration(seconds: 1), () {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage ?? defaultloginError)));
    });
  }
}
