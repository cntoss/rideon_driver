import 'package:firebase_core/firebase_core.dart';
import 'services/firebase/firebaseService.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:rideon_driver/common/theme.dart';
import 'package:rideon_driver/screens/home/homePageWarper.dart';
import 'package:rideon_driver/screens/login/loginwrapper.dart';
import 'package:rideon_driver/screens/splash/splash.dart';
import 'package:rideon_driver/services/helper/hiveService.dart';
import 'package:rideon_driver/services/login/loginManager.dart';
import 'package:rideon_driver/services/theme/theme_provider.dart';
import 'package:rideon_driver/services/utils/uiModifiers.dart';
import 'package:flutter/cupertino.dart';

import 'config/appConfig.dart';
import 'models/connectivity/connectivity_status.dart';
import 'services/connectivity/connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseService().initFirebase();
  await HiveService().initHive();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(
          create: (_) => LoginManger(),
        )
      ],
      child: ScrollConfiguration(behavior: NoGlow(), child: MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<ConnectivityStatus>(
      initialData: ConnectivityStatus.Offline,
      create: (context) =>
          ConnectivityService().connectionStatusController.stream,
      child: MaterialApp(
        navigatorKey: AppConfig.navigatorKey,
        title: 'Ride On',
        debugShowCheckedModeBanner: false,
        theme: appTheme,
        //home: LoginPage(),
        //home: UserService().isLogin ? HomePageWrapper() : SplashScreen(),

        // initialRoute: UserService().isWorkThrough ? '/login' : '/',
        initialRoute: '/login',
        routes: {
          // '/': (context) => SplashScreen(),
          '/slash': (context) => SplashScreen(),
          '/login': (context) => LoginWrapper(),
          '/home': (context) => HomePageWrapper(),
        },
      ),
    );
  }
}
