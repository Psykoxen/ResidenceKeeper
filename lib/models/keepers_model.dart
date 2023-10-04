import 'package:flutter/material.dart';

class KeepersModel {
  String name;

  KeepersModel({
    required this.name,
  });

  static List<KeepersModel> getKeepers() {
    List<KeepersModel> keepers = [];
    keepers.add(KeepersModel(name: 'Keeper 1'));
    keepers.add(KeepersModel(name: 'Keeper 2'));
    keepers.add(KeepersModel(name: 'Keeper 3'));
    return keepers;
  }
}
