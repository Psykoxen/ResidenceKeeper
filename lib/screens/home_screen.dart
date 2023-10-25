import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residencekeeper/components/payment_component.dart';
import 'package:residencekeeper/main.dart';
import 'package:residencekeeper/models/home_model.dart';
import 'package:residencekeeper/models/payment_model.dart';
import 'package:residencekeeper/pages/residence_detailed_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<HomeModel>> residences;
  late Future<List<PaymentModel>> activities;

  @override
  void initState() {
    super.initState();
    // Initialisez la récupération des données dès la création de l'écran
    residences = HomeModel.getResidenceDetails(1);
    activities =
        PaymentModel.getActivities("antoine.voillot@yahoo.fr", "azerty");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Your residences',
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
              child: FutureBuilder<List<HomeModel>>(
                future: residences,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No residences found.');
                  } else {
                    final residences = snapshot.data;
                    return ListView.separated(
                      separatorBuilder: (context, index) => SizedBox(width: 25),
                      itemCount: residences!.length,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      itemBuilder: (context, index) {
                        // C'est une maison
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResidenceDetailedPage(
                                  id: residences[index].id,
                                ),
                              ),
                            );
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
                              color: d_main_light, // Couleur de la maison
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  residences[index].name,
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 12,
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
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Last activities',
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
              child: FutureBuilder<List<PaymentModel>>(
                future: activities,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No residences found.');
                  } else {
                    final activities = snapshot.data;
                    return Column(
                      children: <Widget>[
                        for (var activity in activities!.take(5))
                          Payment(payment: activity)
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
