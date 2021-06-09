import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rideon_driver/config/constant.dart';
import 'resetPasswordManager.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListView(
                  children: [
                    SizedBox(
                        height: MediaQuery.of(context).size.height * .3,
                        child: Center(child: Image.asset("assets/forgot.png"))),
                    Center(
                        child: Text(
                      "Forgot Password",
                      style: title,
                    )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "To recover your password, you'll need to confirm your phone number.",
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    _RecoveryNumberWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecoveryNumberWidget extends StatefulWidget {
  _RecoveryNumberWidget({
    Key? key,
  }) : super(key: key);

  @override
  __RecoveryNumberWidgetState createState() => __RecoveryNumberWidgetState();
}

class __RecoveryNumberWidgetState extends State<_RecoveryNumberWidget> {
  bool isShowingSend = false;
  final ResetPasswordManger manager = ResetPasswordManger();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 80,
      ),
      color: Colors.grey.withOpacity(.26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                maxLength: 10,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
                keyboardType: TextInputType.phone,
                onChanged: (s) {
                  if (s.trim().length == 10 && !isShowingSend) {
                    setState(() {
                      isShowingSend = true;
                    });
                  } else if (isShowingSend && s.trim().length != 10) {
                    setState(() {
                      isShowingSend = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  helperMaxLines: 2,
                  helperText: "You'll be informed after verification.",
                  hintStyle: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: textColor),
                  border: InputBorder.none,
                  hintText: "Enter your Phone no.",
                ),
              ),
            ),
          ),
          if (isShowingSend)
            ValueListenableBuilder<ResetStates>(
                valueListenable: manager.currentStates,
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      child: value == ResetStates.loading
                          ? box(child: CircularProgressIndicator())
                          : value == ResetStates.success
                              ? box(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      size: 25,
                                      color: lightAccent,
                                    ),
                                    Text(
                                      "Sent",
                                      style: TextStyle(
                                        color: lightAccent,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ))
                              : box(
                                  child: SizedBox.expand(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: TextButton(
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                          manager.requestResetCode();
                                        },
                                        child: Text(
                                          "Send",
                                          style: title,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                    ),
                  );
                }),
        ],
      ),
    );
  }

  Widget box({Widget? child}) {
    return SizedBox(
      key: UniqueKey(),
      width: 90,
      height: 90,
      child: Center(child: child),
    );
  }
}
