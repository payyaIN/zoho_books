import 'dart:convert';

class GetAllRptEveryTypeModel {
  final List<RepeatTypeItem> items;

  GetAllRptEveryTypeModel({
    required this.items,
  });

  factory GetAllRptEveryTypeModel.fromJson(String str) =>
      GetAllRptEveryTypeModel.fromList(json.decode(str));

  String toJson() => json.encode(toList());

  factory GetAllRptEveryTypeModel.fromList(List<dynamic> list) {
    print(
        'GetAllRptEveryTypeModel.fromList - Processing response with ${list.length} repeat type items');

    return GetAllRptEveryTypeModel(
      items: List<RepeatTypeItem>.from(list.map((x) {
        if (x is Map) {
          return RepeatTypeItem.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Repeat type item is not a Map');
          return RepeatTypeItem.empty();
        }
      })),
    );
  }

  List<dynamic> toList() => List<dynamic>.from(items.map((x) => x.toMap()));

  factory GetAllRptEveryTypeModel.empty() => GetAllRptEveryTypeModel(
        items: [],
      );
}

class RepeatTypeItem {
  final String label;
  final int value;

  RepeatTypeItem({
    required this.label,
    required this.value,
  });

  factory RepeatTypeItem.fromJson(String str) =>
      RepeatTypeItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RepeatTypeItem.fromMap(Map<String, dynamic> json) {
    return RepeatTypeItem(
      label: json["label"] ?? "",
      value: json["value"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "label": label,
        "value": value,
      };

  factory RepeatTypeItem.empty() => RepeatTypeItem(
        label: "",
        value: 0,
      );
}
