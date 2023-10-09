import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:residencekeeper/models/balance_model.dart';
import 'package:residencekeeper/models/home_model.dart';
import 'package:residencekeeper/models/payment_model.dart';

class ResidenceModel {
  HomeModel home;
  List<PaymentModel> payments;
  BalanceModel balance;

  ResidenceModel({
    required this.home,
    required this.payments,
    required this.balance,
  });

  static Future<ResidenceModel> getResidenceDetails(int id) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/home/getresidence'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'homeId': id,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);

      // Accédez directement aux données de paiement
      List<dynamic> paymentsData = data['payments'];

      ResidenceModel residence = ResidenceModel(
        home: HomeModel(
          id: data['home']['id'],
          name: data['home']['name'],
        ),
        payments: paymentsData.map((payment) {
          return PaymentModel(
            id: payment['id'],
            userId: payment['user_id'],
            homeId: payment['home_id'],
            amount: payment['amount'].toDouble(),
            date: payment['date'],
            name: payment['name'],
            categoryId: payment['category_id'],
            isExpense: payment['expense'] == "true",
          );
        }).toList(),
        balance: BalanceModel(
          balance: data['balance']['balance'].toDouble(),
          users: (data['balance']['users'] as List<dynamic>).map((user) {
            return BalanceUserModel(
              userId: user['userId'],
              balance: user['balance'].toDouble(),
            );
          }).toList(),
        ),
      );

      return residence;
    } else {
      // Gérer les erreurs de la requête ici
      throw Exception('Erreur lors de la requête API');
    }
  }
}
