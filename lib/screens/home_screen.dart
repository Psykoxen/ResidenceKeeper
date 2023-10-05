import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residencekeeper/main.dart';
import 'package:residencekeeper/models/keepers_model.dart';
import 'package:residencekeeper/pages/residence_detailed_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<KeepersModel> keepers = [];

  void _getInitialInfo() {
    keepers = KeepersModel.getKeepers();
  }

  @override
  Widget build(BuildContext context) {
    _getInitialInfo();
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 20),
            child: Text(
              'Welcome back keeper!',
              style: GoogleFonts.poppins(
                color: d_main,
                fontSize: 21,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
            ),
            child: Text(
              'Your keepers',
              style: GoogleFonts.poppins(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 120,
            child: ListView.separated(
              separatorBuilder: (context, index) => SizedBox(width: 25),
              itemCount: keepers.length + 1, // Ajoutez 1 pour le bouton
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20, right: 20),
              itemBuilder: (context, index) {
                if (index == keepers.length) {
                  // C'est la position du bouton
                  return GestureDetector(
                    onTap: () {
                      // Action à effectuer lorsque le bouton est cliqué
                    },
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.blueGrey, // Couleur du bouton
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Colors.white, // Couleur de l'icône
                          size: 40,
                        ),
                      ),
                    ),
                  );
                } else {
                  // C'est une maison
                  return GestureDetector(
                    onTap: () {
                      log('tapped ' + keepers[index].name);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResidenceDetailedPage(
                                  id: keepers[index].id)));
                    },
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 16,
                            offset: Offset(0, 3),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(16),
                        color: d_main,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            keepers[index].name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 90,
                            height: 70,
                            child: SvgPicture.asset(
                              'assets/images/residencekeeper.svg',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}