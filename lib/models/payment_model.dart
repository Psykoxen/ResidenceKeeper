import 'dart:convert';

import 'package:http/http.dart' as http;

class PaymentModel {
  int? id;
  int userId;
  int homeId;
  double amount;
  String date;
  String name;
  int categoryId;
  bool isExpense;

  PaymentModel({
    this.id,
    required this.userId,
    required this.homeId,
    required this.amount,
    required this.date,
    required this.name,
    required this.categoryId,
    required this.isExpense,
  });

  static void newPayment(PaymentModel payment) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/payment/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'user_id': payment.userId,
        'home_id': payment.homeId,
        'amount': payment.amount,
        'date': payment.date,
        'name': payment.name,
        'category_id': payment.categoryId,
        'expense': payment.isExpense,
      }),
    );

    if (response.statusCode == 200) {
    } else {
      // Gérer les erreurs de la requête ici
      throw Exception('Erreur lors de la requête API');
    }
  }
}
