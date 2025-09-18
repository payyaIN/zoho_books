import 'dart:convert';

class GetAllRecurringInvoiceModel {
  final int count;
  final int totalCount;
  final List<RecurringInvoiceData> recInvoiceData;

  GetAllRecurringInvoiceModel({
    required this.count,
    required this.totalCount,
    required this.recInvoiceData,
  });

  factory GetAllRecurringInvoiceModel.fromJson(String str) =>
      GetAllRecurringInvoiceModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllRecurringInvoiceModel.fromMap(Map<String, dynamic> json) {
    print('GetAllRecurringInvoiceModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    List<dynamic> invoicesList = [];

    if (json.containsKey("recInvoiceData")) {
      if (json["recInvoiceData"] is List) {
        invoicesList = json["recInvoiceData"] as List;
        print('Found ${invoicesList.length} recurring invoices in response');
      } else {
        print('Warning: "recInvoiceData" is not a List');
      }
    } else {
      print('Warning: No "recInvoiceData" key found');
    }

    return GetAllRecurringInvoiceModel(
      count: json["count"] ?? 0,
      totalCount: json["totalCount"] ?? 0,
      recInvoiceData: List<RecurringInvoiceData>.from(invoicesList.map((x) {
        if (x is Map) {
          return RecurringInvoiceData.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Recurring invoice item is not a Map');
          return RecurringInvoiceData.empty();
        }
      })),
    );
  }

  Map<String, dynamic> toMap() => {
        "count": count,
        "totalCount": totalCount,
        "recInvoiceData":
            List<dynamic>.from(recInvoiceData.map((x) => x.toMap())),
      };

  factory GetAllRecurringInvoiceModel.empty() => GetAllRecurringInvoiceModel(
        count: 0,
        totalCount: 0,
        recInvoiceData: [],
      );
}

class RecurringInvoiceData {
  RecurringInvoiceData();

  factory RecurringInvoiceData.fromJson(String str) =>
      RecurringInvoiceData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RecurringInvoiceData.fromMap(Map<String, dynamic> json) {
    return RecurringInvoiceData();
  }

  Map<String, dynamic> toMap() => {};

  factory RecurringInvoiceData.empty() => RecurringInvoiceData();
}
