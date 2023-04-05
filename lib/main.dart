// import 'mqtt-flow/screens/nwarehousescreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      initialRoute: "realdb",
      debugShowCheckedModeBanner: false,
      routes: {
        "/": (context) => HomePage(),
        "realdb": (context) => RealTimeDB(),
      },
    );
  }
}
