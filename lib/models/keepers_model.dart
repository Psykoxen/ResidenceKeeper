class KeepersModel {
  int id;
  String name;

  KeepersModel({
    required this.id,
    required this.name,
  });

  static List<KeepersModel> getKeepers() {
    List<KeepersModel> keepers = [];
    keepers.add(KeepersModel(id: 1, name: 'Keeper 1'));
    keepers.add(KeepersModel(id: 2, name: 'Keeper 2'));
    keepers.add(KeepersModel(id: 3, name: 'Keeper 3'));
    return keepers;
  }
}
