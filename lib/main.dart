import 'package:flutter/material.dart';
import 'package:residencekeeper/pages/main_page.dart';
import 'package:residencekeeper/pages/welcome_page.dart';

// const d_main = const Color(0xFFA6CFD5);
const d_main = const Color(0xFFED6C31);
const d_main_light = const Color(0xFFffb08c);
const d_main_dark = const Color(0xFF85a4a8);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ResidenceKeeper',
      debugShowCheckedModeBanner: false,
      // home: WelcomePage(),
      home: HomePage(),
    );
  }
}
