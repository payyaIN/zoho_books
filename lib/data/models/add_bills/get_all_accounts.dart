class Account {
  final int accountId;
  final String accountName;

  Account({required this.accountId, required this.accountName});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['accountId'],
      accountName: json['accountName'],
    );
  }
}
