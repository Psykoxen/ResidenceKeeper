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
}
