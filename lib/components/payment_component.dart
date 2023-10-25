import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:residencekeeper/models/payment_model.dart';

class Payment extends StatelessWidget {
  const Payment({
    super.key,
    required this.payment,
  });

  final PaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
              Text(payment.date, style: GoogleFonts.poppins()),
            ],
          ),
        ),
        trailing: Text(
          payment.isExpense
              ? '-\$${payment.amount.toStringAsFixed(2)}'
              : '+\$${payment.amount.toStringAsFixed(2)}',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: payment.isExpense ? Colors.red : Colors.green,
          ),
        ),
      ),
    );
  }
}
