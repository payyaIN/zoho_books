import 'dart:convert';

class BankAccountsListModel {
  final bool error;
  final String message;
  final List<BankAccount> response;
  final bool status;

  BankAccountsListModel({
    required this.error,
    required this.message,
    required this.response,
    required this.status,
  });

  factory BankAccountsListModel.fromJson(String str) =>
      BankAccountsListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BankAccountsListModel.fromMap(Map<String, dynamic> json) {
    print('BankAccountsListModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    List<dynamic> accountsList = [];

    if (json.containsKey("response")) {
      if (json["response"] is List) {
        accountsList = json["response"] as List;
        print('Found ${accountsList.length} bank accounts in response');
      } else {
        print('Warning: "response" is not a List');
      }
    } else {
      print('Warning: No "response" key found');
    }

    return BankAccountsListModel(
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      response: List<BankAccount>.from(accountsList.map((x) {
        if (x is Map) {
          return BankAccount.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Bank account item is not a Map');
          return BankAccount.empty();
        }
      })),
      status: json["status"] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toMap())),
        "status": status,
      };

  factory BankAccountsListModel.empty() => BankAccountsListModel(
        error: false,
        message: "",
        response: [],
        status: false,
      );
}

class BankAccount {
  final int accountId;
  final String accountCode;
  final String accountName;
  final dynamic accountNumber;

  BankAccount({
    required this.accountId,
    required this.accountCode,
    required this.accountName,
    this.accountNumber,
  });

  factory BankAccount.fromJson(String str) =>
      BankAccount.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BankAccount.fromMap(Map<String, dynamic> json) {
    return BankAccount(
      accountId: json["accountId"] ?? 0,
      accountCode: json["accountCode"] ?? "",
      accountName: json["accountName"] ?? "",
      accountNumber: json["accountNumber"],
    );
  }

  Map<String, dynamic> toMap() => {
        "accountId": accountId,
        "accountCode": accountCode,
        "accountName": accountName,
        "accountNumber": accountNumber,
      };

  factory BankAccount.empty() => BankAccount(
        accountId: 0,
        accountCode: "",
        accountName: "",
        accountNumber: null,
      );
}
