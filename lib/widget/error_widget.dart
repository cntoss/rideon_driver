import 'package:flutter/material.dart';
class ErrorEmptyWidget extends StatelessWidget {
  final String message;
  final VoidCallback onPressed;
  ErrorEmptyWidget({@required this.message, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top:90.0),
          child: Center(
            child: Stack(
              children: [
                Opacity(
                  opacity: 0.9,
                  child: Container(
                    height: 180,
                    width: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xfffcdbd9),
                    ),
                  ),
                ),
                Container(
                  height: 180,
                  width: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/error.png'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column( children: [
            Text(
              message,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            if (onPressed != null)
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 4,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                      onPressed: onPressed,
                      child: Text('Retry')),
                ),
              ),
          ]),
        ),
      ],
    );
  }
}
