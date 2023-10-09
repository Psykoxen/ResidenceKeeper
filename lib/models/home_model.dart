import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:residencekeeper/models/payment_model.dart';

class HomeModel {
  int id;
  String name;

  HomeModel({
    required this.id,
    required this.name,
  });
}
