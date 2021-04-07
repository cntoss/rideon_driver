import 'package:flutter/material.dart';
import 'package:rideon_driver/config/appConfig.dart';

class CustomDialog {
  Widget dialogButton(
      {@required String text, @required VoidCallback onPressed, Color color}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: RaisedButton(
        onPressed: onPressed,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
