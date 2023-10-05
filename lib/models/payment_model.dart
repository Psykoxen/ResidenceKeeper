import 'dart:convert';

import 'package:http/http.dart' as http;

class PaymentModel {
  int id;
  int userId;
  int homeId;
  double amount;
  String date;
  String name;
  int categoryId;
  bool isExpense;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.homeId,
    required this.amount,
    required this.date,
    required this.name,
    required this.categoryId,
    required this.isExpense,
  });

  static Future<List<PaymentModel>> getPayments(int id) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/payment/home'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
      }),
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<PaymentModel> payments = [];

      for (var item in data) {
        payments.add(
          PaymentModel(
            id: item['id'],
            userId: item['user_id'],
            homeId: item['home_id'],
            amount: item['amount'].toDouble(),
            date: item['date'],
            name: item['name'],
            categoryId: item['category_id'],
            isExpense: item['expense'] == 'true',
          ),
        );
      }

      return payments;
    } else {
      // Gérer les erreurs de la requête ici
      throw Exception('Erreur lors de la requête API');
    }
  }
}
