class BankAccount {
  final int? accountId;
  final String? accountCode;
  final String? accountName;
  final String? accountNumber;

  BankAccount({
    this.accountId,
    this.accountCode,
    this.accountName,
    this.accountNumber,
  });

  factory BankAccount.fromJson(Map<String, dynamic> json) {
    return BankAccount(
      accountId: json['accountId'],
      accountCode: json['accountCode'],
      accountName: json['accountName'],
      accountNumber: json['accountNumber'],
    );
  }
}
