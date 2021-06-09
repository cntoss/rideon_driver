import 'package:flutter/material.dart';
import 'package:rideon_driver/config/constant.dart';
import 'package:rideon_driver/screens/leaderboard/leaderboardScrenn.dart';
import 'package:rideon_driver/screens/home/customNavigationButton.dart';
import 'package:rideon_driver/screens/home/homePage.dart';
import 'package:rideon_driver/screens/income/incomeDashboard.dart';
import 'package:rideon_driver/screens/notification/notification.dart';
import 'package:rideon_driver/screens/setting/settingScreen.dart';
import 'package:rideon_driver/widget/network_sensitive.dart';

class HomePageWrapper extends StatefulWidget {
  @override
  _HomePageWrapperState createState() => _HomePageWrapperState();
}

class _HomePageWrapperState extends State<HomePageWrapper> {
  late PageController _pageController;
  int currentpage = 0;
  ValueNotifier<int> op = ValueNotifier<int>(0);
  bool _isOnline = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(keepPage: true, initialPage: 0)
      ..addListener(pagePositionListner);
  }

  pagePositionListner() {
    if (op.value != (_pageController.page! + .5).toInt())
      op.value = (_pageController.page! + 0.5).toInt();

    print(currentpage);
    setState(() {
      currentpage = op.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _incomeStyle =
        TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
    return NetworkSensitive(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: cardColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(flex: 1),
                  Text(_isOnline ? 'On Duty' : 'Off Duty', style: _incomeStyle),
                  Switch(
                    activeColor: Colors.redAccent,
                    inactiveThumbColor: Colors.grey,
                    activeTrackColor: Colors.blue,
                    inactiveTrackColor: Colors.black12,
                    value: _isOnline,
                    onChanged: (value) {
                      setState(() {
                        _isOnline = value;
                      });
                    },
                  ),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.notifications_active, color: Theme.of(context).iconTheme.color),
                  onPressed: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => NotificationScreen())),
                )
              ],
            ),
            body: Stack(
              children: [
                /*  Positioned(
              top: MediaQuery.of(context).padding.top,
              width: MediaQuery.of(context).size.width,
              child: Card(
                color: cardColor,
                shape: RoundedRectangleBorder(
                    borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Spacer(flex: 1),
                    Text('On Duty', style: _incomeStyle),
                    Switch(
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.grey,
                      activeTrackColor: Colors.blue,
                      inactiveTrackColor: Colors.lightBlue[200],
                      value: _isOnline,
                      onChanged: (value) {
                        setState(() {
                          _isOnline = value;
                        });
                      },
                    ),
                    Spacer(
                      flex: 1,
                    )
                  ],
                ),
              ),
            ), */
                pageContent(),
                Positioned(
                  bottom: 0,
                  child: CustomBottomNavigation(
                    selectedItemColor: Colors.red,
                    bgColor: cardColor,
                    navItems: {
                      "Home": Icons.home,
                      "LeaderBoard": Icons.emoji_events,
                      "Earning": Icons.attach_money_rounded,
                      "Profile": Icons.person
                    },
                    onTabChange: (page) {
                      _pageController.jumpToPage(page);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget pageContent() {
    return Column(
      children: [
        Expanded(
          child: PageView(
            physics: NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: [
              HomePage(),
              LeaderboardScreen(),
              IncomeDashboard(),
              SettingScreen(),
            ],
          ),
        )
      ],
    );
  }

  double height(BuildContext context) {
    return MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;
  }
}
