import 'package:flutter/material.dart';
import 'package:rideon_driver/config/constant.dart';

class CustomBottomNavigation extends StatefulWidget {
  final Map<String, IconData> navItems;
  final double height = 70;
  final Color bgColor;
  final Color selectorColor;
  final Color selectedItemColor;
  final Color unselectedItemColor;
  final int animationDurationMilliseconds;
  final Curve curve;
  final Null Function(int)? onTabChange;//Null Function(int) v2 chnaged

  const CustomBottomNavigation(
      {Key? key,
      required this.navItems,
      this.bgColor = Colors.white54,
      this.selectorColor = Colors.white,
      this.selectedItemColor = Colors.green,
      this.unselectedItemColor = Colors.grey,
      this.animationDurationMilliseconds = 200,
      this.curve = Curves.easeInCubic,
      this.onTabChange})
      : super(key: key);

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return createIcons(context);
  }

  Widget createIcons(
    context,
  ) {
    final len = widget.navItems.keys.length;
    List<Widget> buttons = [];
    double width = MediaQuery.of(context).size.width / len;
    for (int i = 0; i < len; i++) {
      var box = GestureDetector(
          onTap: () {
            setState(() {
              selected = i;
              widget.onTabChange!(i);
            });
          },
          child: Container(
            color: Colors.transparent,
            width: width,
            height: widget.height / 1.4,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.bottomCenter,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 4.0),
                  child: Text(widget.navItems.keys.toList()[i]),
                ),
                AnimatedPositioned(
                    curve: widget.curve,
                    duration: Duration(
                        milliseconds: widget.animationDurationMilliseconds),
                    child: Icon(
                      widget.navItems.values.toList()[i],
                      color: selected == i
                          ? widget.selectedItemColor
                          : widget.unselectedItemColor,
                    ),
                    bottom: selected == i
                        ? widget.height / 1.8
                        : widget.height / 3),
              ],
            ),
          ));
      buttons.add(box);
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        Container(
            decoration: BoxDecoration(color: widget.bgColor, boxShadow: [
              BoxShadow(
                  offset: Offset(0, -3), blurRadius: 6, color: Colors.black12)
            ]),
            width: MediaQuery.of(context).size.width,
            height: widget.height / 1.4),
        AnimatedPositioned(
          curve: widget.curve,
          top: widget.height * (1 - 1.3),
          duration:
              Duration(milliseconds: widget.animationDurationMilliseconds),
          left: selected * width + width / 2 - 20,
          child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 2,
              child: applyShade(
                child: CircleAvatar(
                  backgroundColor: widget.selectorColor,
                  radius: 20,
                ),
              )),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: buttons),
      ],
    );
  }

  Widget applyShade({Widget? child}) {
    return ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: Constant.tileGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(bounds);
        },
        child: child);
  }
}
