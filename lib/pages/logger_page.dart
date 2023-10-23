import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residencekeeper/animations/delayed_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:residencekeeper/main.dart';
import 'package:residencekeeper/pages/login_page.dart';
import 'package:residencekeeper/pages/register_page.dart';

class LoggerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          DelayedAnimation(
            delay: 300,
            child: Container(
              height: 200,
              child: SvgPicture.asset('assets/images/residencekeeper.svg'),
            ),
          ),
          SizedBox(height: 10),
          DelayedAnimation(
            delay: 600,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(children: [
                Text("Follow you expenses and join the community !",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: d_main,
                    )),
              ]),
            ),
          ),
          DelayedAnimation(
              delay: 1000,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                child: Column(children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: d_main,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(13),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      },
                      child: Row(children: [
                        Icon(Icons.person_add_alt),
                        SizedBox(width: 10),
                        Text('Join the team',
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      ])),
                  SizedBox(height: 20),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(13),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                      child: Row(children: [
                        Icon(Icons.login, color: d_main),
                        SizedBox(width: 10),
                        Text('Welcome back',
                            style: GoogleFonts.poppins(
                                color: d_main, fontWeight: FontWeight.w500)),
                      ])),
                ]),
              )),
        ]),
      ),
    );
  }
}
