import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residencekeeper/main.dart';
import 'package:residencekeeper/models/payment_model.dart';
import 'package:residencekeeper/models/residence_model.dart';
import 'package:residencekeeper/pages/settings_residence_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ResidenceDetailedPage extends StatefulWidget {
  final int id;
  ResidenceDetailedPage({Key? key, required this.id}) : super(key: key);

  @override
  _ResidenceDetailedPageState createState() => _ResidenceDetailedPageState();
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}

class _ResidenceDetailedPageState extends State<ResidenceDetailedPage> {
  late Future<ResidenceModel> residence;

  @override
  void initState() {
    super.initState();
    print(widget.id);
    residence = ResidenceModel.getResidenceDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert, // Icône de trois points
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(residence: residence),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<ResidenceModel>(
        future: residence,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else {
            // Afficher les données récupérées ici
            final residenceData = snapshot.data;
            if (residenceData != null) {
              final paymentList = residenceData.payments;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Text("Your Balance",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(height: 20),
                    for (var user in residenceData.balance.users)
                      if (user.userId == 1)
                        Text(
                          user.balance < 0
                              ? '-\$${(-user.balance).toStringAsFixed(2)}'
                              : '\$${user.balance.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 40,
                            color: residenceData.balance.balance < 0
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),

                    Text(
                      residenceData.balance.balance < 0
                          ? '-\$${(-residenceData.balance.balance).toStringAsFixed(2)}'
                          : '\$${residenceData.balance.balance.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                        color: residenceData.balance.balance < 0
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    SizedBox(height: 40),
                    // SfCircularChart(series: <CircularSeries>[
                    //   // Render pie chart
                    //   RadialBarSeries<ChartData, String>(
                    //       dataSource: [
                    //         // Bind data source
                    //         ChartData('Jan', 35),
                    //         ChartData('Feb', 28),
                    //         ChartData('Mar', 34),
                    //         ChartData('Apr', 32),
                    //         ChartData('May', 40)
                    //       ],
                    //       xValueMapper: (ChartData data, _) => data.x,
                    //       yValueMapper: (ChartData data, _) => data.y)
                    // ]),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: paymentList.length,
                      itemBuilder: (context, index) {
                        final payment = paymentList[index];
                        return Card(
                          elevation: 5.0,
                          margin:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            title: Text(payment.name,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                )),
                            subtitle: Align(
                              alignment: Alignment.centerLeft,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(payment.categoryId.toString()),
                                  Text(payment.date,
                                      style: GoogleFonts.poppins()),
                                ],
                              ),
                            ),
                            trailing: Text(
                              payment.isExpense
                                  ? '-\$${payment.amount.toStringAsFixed(2)}'
                                  : '+\$${payment.amount.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: payment.isExpense
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Aucun paiement trouvé.'));
            }
          }
        },
      ),
      floatingActionButton: Container(
          margin: EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: d_main, // Couleur de fond du bouton flottant
            shape: BoxShape.circle, // Forme du bouton
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddingExepnse(residence: residence),
                ),
              );
            },
            child: Icon(Icons.add),
            backgroundColor: d_main, // Icône du bouton flottant
          )),
    );
  }
}
