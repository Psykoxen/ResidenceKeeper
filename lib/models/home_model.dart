import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeModel {
  int id;
  String name;

  HomeModel({
    required this.id,
    required this.name,
  });

  static Future<List<HomeModel>> getResidenceDetails(int id) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/api/home/gethomesresident'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'userId': id,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // Convertir les données JSON en une liste d'objets HomeModel
      List<HomeModel> residences = data.map((item) {
        return HomeModel(
          id: item['id'],
          name: item['name'],
        );
      }).toList();

      return residences;
    } else {
      // Gérer les erreurs de la requête ici
      throw Exception('Erreur lors de la requête API');
    }
  }
}
