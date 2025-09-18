import 'dart:convert';

class GetJournalEntriesModel {
  final bool error;
  final String message;
  final List<JournalEntry> response;
  final bool status;

  GetJournalEntriesModel({
    required this.error,
    required this.message,
    required this.response,
    required this.status,
  });

  factory GetJournalEntriesModel.fromJson(String str) =>
      GetJournalEntriesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetJournalEntriesModel.fromMap(Map<String, dynamic> json) {
    print('GetJournalEntriesModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    List<dynamic> entriesList = [];

    if (json.containsKey("response")) {
      if (json["response"] is List) {
        entriesList = json["response"] as List;
        print('Found ${entriesList.length} journal entries in response');
      } else {
        print('Warning: "response" is not a List');
      }
    } else {
      print('Warning: No "response" key found');
    }

    return GetJournalEntriesModel(
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      response: List<JournalEntry>.from(entriesList.map((x) {
        if (x is Map) {
          return JournalEntry.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Journal entry item is not a Map');
          return JournalEntry.empty();
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

  factory GetJournalEntriesModel.empty() => GetJournalEntriesModel(
        error: false,
        message: "",
        response: [],
        status: false,
      );
}

class JournalEntry {
  final int accountId;
  final String accountName;
  final int branchId;
  final String branchName;
  final double debitAmount;
  final double creditAmount;

  JournalEntry({
    required this.accountId,
    required this.accountName,
    required this.branchId,
    required this.branchName,
    required this.debitAmount,
    required this.creditAmount,
  });

  factory JournalEntry.fromJson(String str) =>
      JournalEntry.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory JournalEntry.fromMap(Map<String, dynamic> json) {
    return JournalEntry(
      accountId: json["accountId"] ?? 0,
      accountName: json["accountName"] ?? "",
      branchId: json["branchId"] ?? 0,
      branchName: json["branchName"] ?? "",
      debitAmount: _parseDouble(json["debitAmount"]),
      creditAmount: _parseDouble(json["creditAmount"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "accountId": accountId,
        "accountName": accountName,
        "branchId": branchId,
        "branchName": branchName,
        "debitAmount": debitAmount,
        "creditAmount": creditAmount,
      };

  factory JournalEntry.empty() => JournalEntry(
        accountId: 0,
        accountName: "",
        branchId: 0,
        branchName: "",
        debitAmount: 0.0,
        creditAmount: 0.0,
      );
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (_) {
      return 0.0;
    }
  }
  return 0.0;
}
