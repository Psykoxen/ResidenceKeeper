import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:residencekeeper/models/balance_model.dart';
import 'package:residencekeeper/models/home_model.dart';
import 'package:residencekeeper/models/payment_model.dart';

class CategoryModel {
  int id;
  String name;

  CategoryModel({
    required this.id,
    required this.name,
  });

  static Future<List<CategoryModel>> getCategories() async {
    final response = await http.get(
      Uri.parse('http://localhost:8080/api/category'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);

      List<CategoryModel> categories = data.map((category) {
        return CategoryModel(
          id: category['id'],
          name: category['name'],
        );
      }).toList();

      return categories;
    } else {
      // Gérer les erreurs de la requête ici
      throw Exception('Erreur lors de la requête API');
    }
  }
}
