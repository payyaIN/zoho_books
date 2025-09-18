import 'dart:convert';

class UnitListModel {
  final List<UnitItem> units;

  UnitListModel({
    required this.units,
  });

  factory UnitListModel.fromJson(String str) =>
      UnitListModel.fromList(json.decode(str));

  String toJson() => json.encode(toList());

  factory UnitListModel.fromList(List<dynamic> list) {
    print(
        'UnitListModel.fromList - Processing response with ${list.length} units');

    return UnitListModel(
      units: List<UnitItem>.from(list.map((x) {
        if (x is Map) {
          return UnitItem.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Unit item is not a Map');
          return UnitItem.empty();
        }
      })),
    );
  }

  List<dynamic> toList() => List<dynamic>.from(units.map((x) => x.toMap()));

  factory UnitListModel.empty() => UnitListModel(
        units: [],
      );
}

class UnitItem {
  final String? groupName;
  final int unitId;
  final String displayUnit;

  UnitItem({
    this.groupName,
    required this.unitId,
    required this.displayUnit,
  });

  factory UnitItem.fromJson(String str) => UnitItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UnitItem.fromMap(Map<String, dynamic> json) {
    return UnitItem(
      groupName: json["groupName"],
      unitId: json["unitId"] ?? 0,
      displayUnit: json["displayUnit"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "groupName": groupName,
        "unitId": unitId,
        "displayUnit": displayUnit,
      };

  factory UnitItem.empty() => UnitItem(
        groupName: null,
        unitId: 0,
        displayUnit: "",
      );
}
