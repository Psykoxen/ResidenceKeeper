import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residencekeeper/animations/delayed_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:residencekeeper/main.dart';
import 'package:residencekeeper/pages/logger_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDECF2),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DelayedAnimation(
              delay: 800,
              child: Text(
                "ResidenceKeeper",
                style: GoogleFonts.raleway(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: d_blue,
                ),
              ),
            ),
            DelayedAnimation(
              delay: 1000,
              child: Container(
                height: 170,
                child: SvgPicture.asset('assets/images/residencekeeper.svg'),
              ),
            ),
            DelayedAnimation(
              delay: 1200,
              child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: d_blue,
                    shape: StadiumBorder(),
                    padding: EdgeInsets.all(13),
                  ),
                  child: Text('Get Started'),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoggerPage()));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
