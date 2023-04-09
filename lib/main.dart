// import 'mqtt-flow/screens/nwarehousescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_devices/login-flow/screens/loginpage.dart';

import 'ble-flow/screens/blepage.dart';
import 'firebase-flow/screens/realtimedb.dart';
import 'firebase_options.dart';
import 'home-flow/screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Devices',
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => HomePage(),
        "login": (context) => LoginPage(),
        "ble": (context) => BlePage(),
        "realdb": (context) => RealTimeDB(),
      },
    );
  }
}
