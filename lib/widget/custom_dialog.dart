import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';

class CustomDialog {
  Widget dialogButton(
      {@required String text, @required VoidCallback onPressed, Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          primary: color != null
              ? color
              : Theme.of(AppConfig.navigatorKey.currentContext).buttonColor,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Future showCustomDialog({
    String title,
    String content,
    Widget body,
    List<Widget> actions,
  }) {
    return showDialog(
      context: AppConfig.navigatorKey.currentState.context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        actionsOverflowButtonSpacing: 0,
        buttonPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Center(
          child: Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).orientation == Orientation.portrait
                    ? 10
                    : 5),
            child: Image.asset(
              'assets/logo.png',
              height: 80,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
        content: SingleChildScrollView(
            child: Column(
          children: [
            if (title != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            content != null
                ? Text(
                    content,
                    style: TextStyle(fontWeight: FontWeight.w300),
                  )
                : body,
          ],
        )),
        actions: [
          Container(
            padding: EdgeInsets.only(bottom: 30),
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: actions ??
                  [
                    dialogButton(
                      text: 'OK',
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
            ),
          )
        ],
      ),
    );
  }

  Future showCustomDialogWIthoutLogo({
    String title,
    String content,
    Widget body,
    List<Widget> actions,
  }) {
    return showDialog(
      context: AppConfig.navigatorKey.currentState.context,
      builder: (context) => AlertDialog(
        titlePadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        actionsOverflowButtonSpacing: 0,
        buttonPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: content != null
            ? Text(
                content,
                style: TextStyle(fontWeight: FontWeight.w300),
              )
            : body,
        actions: [
          Container(
            padding: EdgeInsets.only(bottom: 30),
            width: MediaQuery.of(context).size.width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: actions ??
                  [
                    dialogButton(
                      text: 'Okay',
                      onPressed: () => Navigator.pop(context, true),
                    ),
                  ],
            ),
          )
        ],
      ),
    );
  }
}
