import 'package:flutter/material.dart';
import 'package:residencekeeper/models/payment_model.dart';

class ResidenceDetailedPage extends StatefulWidget {
  final int id;
  ResidenceDetailedPage({super.key, required this.id});

  @override
  _ResidenceDetailedPageState createState() => _ResidenceDetailedPageState();
}

class _ResidenceDetailedPageState extends State<ResidenceDetailedPage> {
  late Future<List<PaymentModel>> payments;

  @override
  void initState() {
    super.initState();
    payments = PaymentModel.getPayments(widget.id);
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
      body: FutureBuilder<List<PaymentModel>>(
        future: payments,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Erreur: ${snapshot.error}');
          } else {
            // Afficher les données récupérées ici
            final paymentList = snapshot.data;
            if (paymentList != null && paymentList.isNotEmpty) {
              return ListView.builder(
                itemCount: paymentList.length,
                itemBuilder: (context, index) {
                  final payment = paymentList[index];
                  return ListTile(
                    title: Text(payment.name),
                    subtitle: Text(payment.date),
                    trailing: Text('\$${payment.amount.toStringAsFixed(2)}'),
                  );
                },
              );
            } else {
              return Text('Aucun paiement trouvé.');
            }
          }
        },
      ),
    );
  }
}
