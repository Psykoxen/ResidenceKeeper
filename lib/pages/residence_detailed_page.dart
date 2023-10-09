import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residencekeeper/models/payment_model.dart';
import 'package:residencekeeper/models/residence_model.dart';

class ResidenceDetailedPage extends StatefulWidget {
  final int id;
  ResidenceDetailedPage({Key? key, required this.id}) : super(key: key);

  @override
  _ResidenceDetailedPageState createState() => _ResidenceDetailedPageState();
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
                    Text(
                      residenceData.balance.balance < 0
                          ? '-\$${(-residenceData.balance.balance).toStringAsFixed(2)}'
                          : '\$${residenceData.balance.balance.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 40,
                        color: residenceData.balance.balance < 0
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    SizedBox(height: 40),
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
    );
  }
}
