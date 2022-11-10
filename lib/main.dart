
import 'package:flutter/material.dart';

import 'splashscreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flow Meter',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home:  const SplashScreen(),
    );
  }
}
