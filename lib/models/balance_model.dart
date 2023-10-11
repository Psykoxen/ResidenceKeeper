class BalanceModel {
  double balance;
  List<BalanceUserModel> users;

  BalanceModel({
    required this.balance,
    required this.users,
  });
}

class BalanceUserModel {
  int userId;
  double balance;

  BalanceUserModel({
    required this.userId,
    required this.balance,
  });
}
