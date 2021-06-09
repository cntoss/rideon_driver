import 'package:flutter/material.dart';

class NoGlow extends ScrollBehavior{

  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}


class WidgetToSliverBuilder extends StatefulWidget
    implements PreferredSizeWidget {
  final Widget child;
  final width;

  const WidgetToSliverBuilder({Key? key, required this.child, this.width})
      : super(key: key);

  @override
  _WidgetToSliverBuilderState createState() => _WidgetToSliverBuilderState();

  @override
  Size get preferredSize => Size(width, AppBar().preferredSize.height + 24.0);
}

class _WidgetToSliverBuilderState extends State<WidgetToSliverBuilder> {
  @override
  Widget build(BuildContext context) {
    return Container(child: widget.child);
  }
}
