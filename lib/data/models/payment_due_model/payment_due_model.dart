import 'dart:convert';

class PaymentDueModel {
  final List<PaymentDueItem> items;

  PaymentDueModel({
    required this.items,
  });

  factory PaymentDueModel.fromJson(String str) =>
      PaymentDueModel.fromList(json.decode(str));

  String toJson() => json.encode(toList());

  factory PaymentDueModel.fromList(List<dynamic> list) {
    print(
        'PaymentDueModel.fromList - Processing response with ${list.length} payment due items');

    return PaymentDueModel(
      items: List<PaymentDueItem>.from(list.map((x) {
        if (x is Map) {
          return PaymentDueItem.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Payment due item is not a Map');
          return PaymentDueItem.empty();
        }
      })),
    );
  }

  List<dynamic> toList() => List<dynamic>.from(items.map((x) => x.toMap()));

  factory PaymentDueModel.empty() => PaymentDueModel(
        items: [],
      );
}

class PaymentDueItem {
  final int days;
  final String label;
  final int value;

  PaymentDueItem({
    required this.days,
    required this.label,
    required this.value,
  });

  factory PaymentDueItem.fromJson(String str) =>
      PaymentDueItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PaymentDueItem.fromMap(Map<String, dynamic> json) {
    return PaymentDueItem(
      days: json["days"] ?? 0,
      label: json["label"] ?? "",
      value: json["value"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "days": days,
        "label": label,
        "value": value,
      };

  factory PaymentDueItem.empty() => PaymentDueItem(
        days: 0,
        label: "",
        value: 0,
      );
}
