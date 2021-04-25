import 'package:flutter/material.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/widget/customCard.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChnagePasswordScreenState createState() => _ChnagePasswordScreenState();
}

class _ChnagePasswordScreenState extends State<ChangePasswordScreen> {
  bool _isLoading = false;
  TextEditingController _oldPinController = TextEditingController(),
      _newPinController = TextEditingController(),
      _confirmPinController = TextEditingController();
  FocusNode _oldPinFocusNode = FocusNode(),
      _newPinFocusNode = FocusNode(),
      _confirmPinFocusNode = FocusNode();
  bool _isOldPinObscure = true;
  bool _isNewPinObscure = true;
  bool _isConfirmObscure = true;

  GlobalKey<FormState> _pinChangeFormKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    _newPinFocusNode.dispose();
    _oldPinFocusNode.dispose();
    _confirmPinFocusNode.dispose();
    super.dispose();
  }

  void _changefieldFocus(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  String _validatePin(String value, {bool isConfirmPin}) {
    if (value.length < 6 || value.isEmpty) {
      return 'Enter at least 6 character password';
    } else if (_oldPinController.text == _newPinController.text) {
      return 'Old password and New password must be different';
    } else if (isConfirmPin ?? false) {
      if (_newPinController.text != _confirmPinController.text) {
        return "New password and confirm password must be same";
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  String _validateOldPin(String value) {
    if (value.length < 6 || value.isEmpty) {
      return 'Enter at least 6 character password';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('Change Password')),
        body: Padding(
          padding: const EdgeInsets.only(top: 60.0, left: 10, right: 10),
          child: ListView(
            children: [
              CustomCard(
                color: null,
                child: Column(
                  children: [
                    Form(
                      key: _pinChangeFormKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: TextFormField(
                              enabled: !_isLoading,
                              focusNode: _oldPinFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                _changefieldFocus(context, _oldPinFocusNode,
                                    _newPinFocusNode);
                              },
                              controller: _oldPinController,
                              obscureText: _isOldPinObscure,
                              validator: _validateOldPin,
                              decoration: InputDecoration(
                                  labelText: 'Old password',
                                  counterText: "",
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isOldPinObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isOldPinObscure = !_isOldPinObscure;
                                      });
                                    },
                                  )),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 15),
                            child: TextFormField(
                              enabled: !_isLoading,
                              focusNode: _newPinFocusNode,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (term) {
                                _changefieldFocus(context, _newPinFocusNode,
                                    _confirmPinFocusNode);
                              },
                              controller: _newPinController,
                              obscureText: _isNewPinObscure,
                              validator: (value) {
                                return _validatePin(value);
                              },
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Icon(
                                    Icons.lock,
                                    color: Colors.grey,
                                  ),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isNewPinObscure
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isNewPinObscure = !_isNewPinObscure;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Container(
                              margin: EdgeInsets.only(top: 15),
                              child: TextFormField(
                                enabled: !_isLoading,
                                focusNode: _confirmPinFocusNode,
                                textInputAction: TextInputAction.done,
                                controller: _confirmPinController,
                                obscureText: _isConfirmObscure,
                                validator: (value) {
                                  return _validatePin(value,
                                      isConfirmPin: true);
                                },
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12),
                                  border: InputBorder.none,
                                  labelText: 'Confirm password',
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(0.0),
                                    child: Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isConfirmObscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isConfirmObscure = !_isConfirmObscure;
                                      });
                                    },
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 15),
                      child: ElevatedButton(
                        child: Padding(
                          padding: bottonPadding,
                          child: Text(
                            'Change Password',
                            style: bottonTextStyle.copyWith(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_pinChangeFormKey.currentState.validate()) {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _isLoading = true;
                                  });
                                }
                              },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  clear() {
    _oldPinController.clear();
    _newPinController.clear();
    _confirmPinController.clear();
    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }
}
