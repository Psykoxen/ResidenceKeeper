import 'package:flutter/material.dart';
import 'package:residencekeeper/pages/welcome_page.dart';

const d_blue = const Color(0xFFA6CFD5);

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
      home: WelcomePage(),
    );
  }
}
