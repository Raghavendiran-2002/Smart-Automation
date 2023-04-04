import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'home-flow/screens/homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      },
    );
  }
}
