import 'dart:convert';

class GetItemModel {
  final List<Item> data;
  final int count;
  final String message;
  final String status;

  GetItemModel({
    required this.data,
    required this.count,
    required this.message,
    required this.status,
  });

  factory GetItemModel.fromJson(String str) =>
      GetItemModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetItemModel.fromMap(Map<String, dynamic> json) {
    print('GetItemModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    List<dynamic> itemsList = [];

    if (json.containsKey("data")) {
      if (json["data"] is List) {
        itemsList = json["data"] as List;
        print('Found ${itemsList.length} items in response');
      } else {
        print('Warning: "data" is not a List');
      }
    } else {
      print('Warning: No "data" key found');
    }

    return GetItemModel(
      data: List<Item>.from(itemsList.map((x) {
        if (x is Map) {
          return Item.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Item is not a Map');
          return Item.empty();
        }
      })),
      count: json["count"] ?? 0,
      message: json["message"] ?? "",
      status: json["status"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "count": count,
        "message": message,
        "status": status,
      };

  factory GetItemModel.empty() => GetItemModel(
        data: [],
        count: 0,
        message: "",
        status: "",
      );
}

class Item {
  final int? salesAccountId;
  final int? preferedVendor;
  final String hsnOrSac;
  final dynamic description;
  final double? salesRate;
  final String? salesDescription;
  final String? costDescription;
  final dynamic createdAt;
  final String itemName;
  final int unitId;
  final int? costAccountId;
  final dynamic sku;
  final String? taxExceptionReason;
  final dynamic updatedAt;
  final double? costRate;
  final int taxable;
  final bool stockable;
  final String? salesAccountName;
  final String? costAccountName;
  final int itemId;
  final bool fixedAsset;
  final int? salesCurrency;
  final int itemUsageType;
  final int? costCurrency;
  final int status;

  Item({
    this.salesAccountId,
    this.preferedVendor,
    required this.hsnOrSac,
    this.description,
    this.salesRate,
    this.salesDescription,
    this.costDescription,
    this.createdAt,
    required this.itemName,
    required this.unitId,
    this.costAccountId,
    this.sku,
    this.taxExceptionReason,
    this.updatedAt,
    this.costRate,
    required this.taxable,
    required this.stockable,
    this.salesAccountName,
    this.costAccountName,
    required this.itemId,
    required this.fixedAsset,
    this.salesCurrency,
    required this.itemUsageType,
    this.costCurrency,
    required this.status,
  });

  factory Item.fromJson(String str) => Item.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Item.fromMap(Map<String, dynamic> json) {
    return Item(
      salesAccountId: json["salesAccountId"],
      preferedVendor: json["preferedVendor"],
      hsnOrSac: json["hsnOrSac"] ?? "",
      description: json["description"],
      salesRate: _parseDouble(json["salesRate"]),
      salesDescription: json["salesDescription"],
      costDescription: json["costDescription"],
      createdAt: json["createdAt"],
      itemName: json["itemName"] ?? "",
      unitId: json["unitId"] ?? 0,
      costAccountId: json["costAccountId"],
      sku: json["sku"],
      taxExceptionReason: json["taxExceptionReason"],
      updatedAt: json["updatedAt"],
      costRate: _parseDouble(json["costRate"]),
      taxable: json["taxable"] ?? 0,
      stockable: json["stockable"] ?? false,
      salesAccountName: json["salesAccountName"],
      costAccountName: json["costAccountName"],
      itemId: json["itemId"] ?? 0,
      fixedAsset: json["fixedAsset"] ?? false,
      salesCurrency: json["salesCurrency"],
      itemUsageType: json["itemUsageType"] ?? 0,
      costCurrency: json["costCurrency"],
      status: json["status"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "salesAccountId": salesAccountId,
        "preferedVendor": preferedVendor,
        "hsnOrSac": hsnOrSac,
        "description": description,
        "salesRate": salesRate,
        "salesDescription": salesDescription,
        "costDescription": costDescription,
        "createdAt": createdAt,
        "itemName": itemName,
        "unitId": unitId,
        "costAccountId": costAccountId,
        "sku": sku,
        "taxExceptionReason": taxExceptionReason,
        "updatedAt": updatedAt,
        "costRate": costRate,
        "taxable": taxable,
        "stockable": stockable,
        "salesAccountName": salesAccountName,
        "costAccountName": costAccountName,
        "itemId": itemId,
        "fixedAsset": fixedAsset,
        "salesCurrency": salesCurrency,
        "itemUsageType": itemUsageType,
        "costCurrency": costCurrency,
        "status": status,
      };

  factory Item.empty() => Item(
        hsnOrSac: "",
        itemName: "",
        unitId: 0,
        taxable: 0,
        stockable: false,
        itemId: 0,
        fixedAsset: false,
        itemUsageType: 0,
        status: 0,
      );
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}
