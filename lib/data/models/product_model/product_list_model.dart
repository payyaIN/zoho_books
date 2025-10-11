// class ProductModel {
//   final bool error;
//   final String errorMsg;
//   final dynamic successMsg;
//   final ProductResponse response;
//   final bool status;
//   final String transactionId;

//   ProductModel({
//     required this.error,
//     required this.errorMsg,
//     required this.successMsg,
//     required this.response,
//     required this.status,
//     required this.transactionId,
//   });

//   factory ProductModel.fromMap(Map<String, dynamic> json) {
//     print('ProductModel.fromMap - Parsing response: ${json.keys}');

//     final response = json["response"] != null
//         ? ProductResponse.fromMap(json["response"] as Map<String, dynamic>)
//         : ProductResponse(data: [], totalRecord: 0);

//     return ProductModel(
//       error: json["error"] ?? false,
//       errorMsg: json["errorMsg"] ?? "",
//       successMsg: json["successMsg"],
//       response: response,
//       status: json["status"] ?? false,
//       transactionId: json["transactionId"] ?? "",
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "error": error,
//       "errorMsg": errorMsg,
//       "successMsg": successMsg,
//       "response": response.toMap(),
//       "status": status,
//       "transactionId": transactionId,
//     };
//   }
// }

// class ProductResponse {
//   final List<ProductData> data;
//   final int totalRecord;

//   ProductResponse({
//     required this.data,
//     required this.totalRecord,
//   });

//   factory ProductResponse.fromMap(Map<String, dynamic> json) {
//     print(
//         'ProductResponse.fromMap - Parsing data array of length: ${json["data"] != null ? (json["data"] as List).length : 0}');

//     final List<dynamic> dataList =
//         json["data"] != null ? (json["data"] as List) : [];

//     return ProductResponse(
//       data: List<ProductData>.from(
//           dataList.map((x) => ProductData.fromMap(x as Map<String, dynamic>))),
//       totalRecord: json["totalRecord"] ?? 0,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "data": List<dynamic>.from(data.map((x) => x.toMap())),
//       "totalRecord": totalRecord,
//     };
//   }
// }

// class ProductData {
//   final dynamic salesAccountId;
//   final String costRate;
//   final int taxable;
//   final int? preferedVendor;
//   final String hsnOrSac;
//   final String salesRate;
//   final String salesDescription;
//   final bool stockable;
//   final String salesAccountName;
//   final String costAccountName;
//   final int itemId;
//   final String costDescription;
//   final dynamic createdAt;
//   final String itemName;
//   final int unitId;
//   final bool fixedAsset;
//   final dynamic salesCurrency;
//   final dynamic costAccountId;
//   final int itemUsageType;
//   final dynamic sku;
//   final dynamic taxExceptionReason;
//   final dynamic costCurrency;
//   final int status;
//   final dynamic updatedAt;

//   ProductData({
//     required this.salesAccountId,
//     required this.costRate,
//     required this.taxable,
//     this.preferedVendor,
//     required this.hsnOrSac,
//     required this.salesRate,
//     required this.salesDescription,
//     required this.stockable,
//     required this.salesAccountName,
//     required this.costAccountName,
//     required this.itemId,
//     required this.costDescription,
//     this.createdAt,
//     required this.itemName,
//     required this.unitId,
//     required this.fixedAsset,
//     required this.salesCurrency,
//     required this.costAccountId,
//     required this.itemUsageType,
//     this.sku,
//     this.taxExceptionReason,
//     required this.costCurrency,
//     required this.status,
//     this.updatedAt,
//   });

//   factory ProductData.empty() => ProductData(
//         salesAccountId: 0,
//         costRate: "0.00",
//         taxable: 0,
//         hsnOrSac: "",
//         salesRate: "0.00",
//         salesDescription: "",
//         stockable: false,
//         salesAccountName: "",
//         costAccountName: "",
//         itemId: 0,
//         costDescription: "",
//         itemName: "",
//         unitId: 0,
//         fixedAsset: false,
//         salesCurrency: 0,
//         costAccountId: 0,
//         itemUsageType: 0,
//         costCurrency: 0,
//         status: 0,
//       );

//   factory ProductData.fromMap(Map<String, dynamic> json) {
//     print('ProductData.fromMap - Parsing item: ${json["itemName"]}');

//     return ProductData(
//       salesAccountId: json["salesAccountId"],
//       costRate: json["costRate"].toString(),
//       taxable: json["taxable"] ?? 0,
//       preferedVendor: json["preferedVendor"],
//       hsnOrSac: json["hsnOrSac"] ?? "",
//       salesRate: json["salesRate"].toString(),
//       salesDescription: json["salesDescription"] ?? "",
//       stockable: json["stockable"] ?? false,
//       salesAccountName: json["salesAccountName"] ?? "",
//       costAccountName: json["costAccountName"] ?? "",
//       itemId: json["itemId"] ?? 0,
//       costDescription: json["costDescription"] ?? "",
//       createdAt: json["createdAt"],
//       itemName: json["itemName"] ?? "",
//       unitId: json["unitId"] ?? 0,
//       fixedAsset: json["fixedAsset"] ?? false,
//       salesCurrency: json["salesCurrency"],
//       costAccountId: json["costAccountId"],
//       itemUsageType: json["itemUsageType"] ?? 0,
//       sku: json["sku"],
//       taxExceptionReason: json["taxExceptionReason"],
//       costCurrency: json["costCurrency"],
//       status: json["status"] ?? 0,
//       updatedAt: json["updatedAt"],
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       "salesAccountId": salesAccountId,
//       "costRate": costRate,
//       "taxable": taxable,
//       "preferedVendor": preferedVendor,
//       "hsnOrSac": hsnOrSac,
//       "salesRate": salesRate,
//       "salesDescription": salesDescription,
//       "stockable": stockable,
//       "salesAccountName": salesAccountName,
//       "costAccountName": costAccountName,
//       "itemId": itemId,
//       "costDescription": costDescription,
//       "createdAt": createdAt,
//       "itemName": itemName,
//       "unitId": unitId,
//       "fixedAsset": fixedAsset,
//       "salesCurrency": salesCurrency,
//       "costAccountId": costAccountId,
//       "itemUsageType": itemUsageType,
//       "sku": sku,
//       "taxExceptionReason": taxExceptionReason,
//       "costCurrency": costCurrency,
//       "status": status,
//       "updatedAt": updatedAt,
//     };
//   }
// }

import 'package:flutter/foundation.dart';

// Helper function to parse double values safely
double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    final parsed = double.tryParse(value);
    return parsed ?? 0.0;
  }
  return 0.0;
}

/// Main Product Model containing the full API response
class ProductModel {
  final bool error;
  final String errorMsg;
  final dynamic successMsg;
  final ProductResponse response;
  final bool status;
  final String transactionId;

  ProductModel({
    required this.error,
    required this.errorMsg,
    required this.successMsg,
    required this.response,
    required this.status,
    required this.transactionId,
  });

  factory ProductModel.fromMap(Map<String, dynamic> json) {
    if (kDebugMode) {
      print('ProductModel.fromMap - Parsing response: ${json.keys}');
    }

    final response = json["response"] != null
        ? ProductResponse.fromMap(json["response"] as Map<String, dynamic>)
        : ProductResponse(data: [], totalRecord: 0);

    return ProductModel(
      error: json["error"] ?? false,
      errorMsg: json["errorMsg"] ?? "",
      successMsg: json["successMsg"],
      response: response,
      status: json["status"] ?? false,
      transactionId: json["transactionId"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "error": error,
      "errorMsg": errorMsg,
      "successMsg": successMsg,
      "response": response.toMap(),
      "status": status,
      "transactionId": transactionId,
    };
  }

  factory ProductModel.empty() => ProductModel(
        error: false,
        errorMsg: "",
        successMsg: null,
        response: ProductResponse(data: [], totalRecord: 0),
        status: false,
        transactionId: "",
      );
}

/// Product Response containing list of products
class ProductResponse {
  final List<ProductData> data;
  final int totalRecord;

  ProductResponse({
    required this.data,
    required this.totalRecord,
  });

  factory ProductResponse.fromMap(Map<String, dynamic> json) {
    if (kDebugMode) {
      print(
          'ProductResponse.fromMap - Parsing data array of length: ${json["data"] != null ? (json["data"] as List).length : 0}');
    }

    final List<dynamic> dataList =
        json["data"] != null ? (json["data"] as List) : [];

    return ProductResponse(
      data: List<ProductData>.from(
          dataList.map((x) => ProductData.fromMap(x as Map<String, dynamic>))),
      totalRecord: json["totalRecord"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "data": List<dynamic>.from(data.map((x) => x.toMap())),
      "totalRecord": totalRecord,
    };
  }
}

/// Individual Product Data
class ProductData {
  final dynamic salesAccountId;
  final int taxable;
  final int? preferedVendor;
  final String hsnOrSac;
  final double salesRate;
  final String salesDescription;
  final bool stockable;
  final String salesAccountName;
  final String costAccountName;
  final int itemId;
  final String costDescription;
  final dynamic createdAt;
  final String itemName;
  final int unitId;
  final bool fixedAsset;
  final dynamic salesCurrency;
  final dynamic costAccountId;
  final int itemUsageType;
  final dynamic sku;
  final dynamic taxExceptionReason;
  final dynamic costCurrency;
  final int status;
  final dynamic updatedAt;
  final double costRate;

  // ✅ NEW FIELDS from API response that were missing
  final bool itemType;
  final String itemCategory;

  // ✅ NEW FORMATTED FIELDS from API response
  final String? salesRateFormatted;
  final String? salesRateFormattedCur;
  final String? costRateFormatted;
  final String? costRateFormattedCur;

  ProductData({
    required this.salesAccountId,
    required this.taxable,
    this.preferedVendor,
    required this.hsnOrSac,
    required this.salesRate,
    required this.salesDescription,
    required this.stockable,
    required this.salesAccountName,
    required this.costAccountName,
    required this.itemId,
    required this.costDescription,
    this.createdAt,
    required this.itemName,
    required this.unitId,
    required this.fixedAsset,
    required this.salesCurrency,
    required this.costAccountId,
    required this.itemUsageType,
    this.sku,
    this.taxExceptionReason,
    required this.costCurrency,
    required this.status,
    this.updatedAt,
    required this.costRate,
    required this.itemType,
    required this.itemCategory,
    this.salesRateFormatted,
    this.salesRateFormattedCur,
    this.costRateFormatted,
    this.costRateFormattedCur,
  });

  factory ProductData.empty() => ProductData(
        salesAccountId: 0,
        taxable: 0,
        hsnOrSac: "",
        salesRate: 0.0,
        salesDescription: "",
        stockable: false,
        salesAccountName: "",
        costAccountName: "",
        itemId: 0,
        costDescription: "",
        itemName: "",
        unitId: 0,
        fixedAsset: false,
        salesCurrency: 0,
        costAccountId: 0,
        itemUsageType: 0,
        costCurrency: 0,
        status: 0,
        costRate: 0.0,
        itemType: true,
        itemCategory: "EXPENSE",
      );

  factory ProductData.fromMap(Map<String, dynamic> json) {
    if (kDebugMode) {
      print('ProductData.fromMap - Parsing item: ${json["itemName"]}');
    }

    return ProductData(
      salesAccountId: json["salesAccountId"],
      taxable: json["taxable"] ?? 0,
      preferedVendor: json["preferedVendor"],
      hsnOrSac: json["hsnOrSac"] ?? "",
      // ✅ Parse salesRate as double instead of string
      salesRate: _parseDouble(json["salesRate"]),
      salesDescription: json["salesDescription"] ?? "",
      stockable: json["stockable"] ?? false,
      salesAccountName: json["salesAccountName"] ?? "",
      costAccountName: json["costAccountName"] ?? "",
      itemId: json["itemId"] ?? 0,
      costDescription: json["costDescription"] ?? "",
      createdAt: json["createdAt"],
      itemName: json["itemName"] ?? "",
      unitId: json["unitId"] ?? 0,
      fixedAsset: json["fixedAsset"] ?? false,
      salesCurrency: json["salesCurrency"],
      costAccountId: json["costAccountId"],
      itemUsageType: json["itemUsageType"] ?? 0,
      sku: json["sku"],
      taxExceptionReason: json["taxExceptionReason"],
      costCurrency: json["costCurrency"],
      status: json["status"] ?? 0,
      updatedAt: json["updatedAt"],
      // ✅ Parse costRate as double instead of string
      costRate: _parseDouble(json["costRate"]),
      // ✅ NEW FIELDS
      itemType: json["itemType"] ?? true,
      itemCategory: json["itemCategory"] ?? "EXPENSE",
      // ✅ NEW FORMATTED FIELDS
      salesRateFormatted: json["salesRate_formatted"],
      salesRateFormattedCur: json["salesRate_formatted_cur"],
      costRateFormatted: json["costRate_formatted"],
      costRateFormattedCur: json["costRate_formatted_cur"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "salesAccountId": salesAccountId,
      "taxable": taxable,
      "preferedVendor": preferedVendor,
      "hsnOrSac": hsnOrSac,
      "salesRate": salesRate,
      "salesDescription": salesDescription,
      "stockable": stockable,
      "salesAccountName": salesAccountName,
      "costAccountName": costAccountName,
      "itemId": itemId,
      "costDescription": costDescription,
      "createdAt": createdAt,
      "itemName": itemName,
      "unitId": unitId,
      "fixedAsset": fixedAsset,
      "salesCurrency": salesCurrency,
      "costAccountId": costAccountId,
      "itemUsageType": itemUsageType,
      "sku": sku,
      "taxExceptionReason": taxExceptionReason,
      "costCurrency": costCurrency,
      "status": status,
      "updatedAt": updatedAt,
      "costRate": costRate,
      "itemType": itemType,
      "itemCategory": itemCategory,
      "salesRate_formatted": salesRateFormatted,
      "salesRate_formatted_cur": salesRateFormattedCur,
      "costRate_formatted": costRateFormatted,
      "costRate_formatted_cur": costRateFormattedCur,
    };
  }

  /// Convenience getter to check if item is taxable
  bool get isTaxable => taxable == 1;

  /// Convenience getter to check if item is active
  bool get isActive => status == 1;

  /// Get display name for item category
  String get categoryDisplayName {
    switch (itemCategory) {
      case "EXPENSE":
        return "Expense";
      case "TRADE":
        return "Trade";
      default:
        return itemCategory;
    }
  }

  /// Copy with method for easy updates
  ProductData copyWith({
    dynamic salesAccountId,
    int? taxable,
    int? preferedVendor,
    String? hsnOrSac,
    double? salesRate,
    String? salesDescription,
    bool? stockable,
    String? salesAccountName,
    String? costAccountName,
    int? itemId,
    String? costDescription,
    dynamic createdAt,
    String? itemName,
    int? unitId,
    bool? fixedAsset,
    dynamic salesCurrency,
    dynamic costAccountId,
    int? itemUsageType,
    dynamic sku,
    dynamic taxExceptionReason,
    dynamic costCurrency,
    int? status,
    dynamic updatedAt,
    double? costRate,
    bool? itemType,
    String? itemCategory,
    String? salesRateFormatted,
    String? salesRateFormattedCur,
    String? costRateFormatted,
    String? costRateFormattedCur,
  }) {
    return ProductData(
      salesAccountId: salesAccountId ?? this.salesAccountId,
      taxable: taxable ?? this.taxable,
      preferedVendor: preferedVendor ?? this.preferedVendor,
      hsnOrSac: hsnOrSac ?? this.hsnOrSac,
      salesRate: salesRate ?? this.salesRate,
      salesDescription: salesDescription ?? this.salesDescription,
      stockable: stockable ?? this.stockable,
      salesAccountName: salesAccountName ?? this.salesAccountName,
      costAccountName: costAccountName ?? this.costAccountName,
      itemId: itemId ?? this.itemId,
      costDescription: costDescription ?? this.costDescription,
      createdAt: createdAt ?? this.createdAt,
      itemName: itemName ?? this.itemName,
      unitId: unitId ?? this.unitId,
      fixedAsset: fixedAsset ?? this.fixedAsset,
      salesCurrency: salesCurrency ?? this.salesCurrency,
      costAccountId: costAccountId ?? this.costAccountId,
      itemUsageType: itemUsageType ?? this.itemUsageType,
      sku: sku ?? this.sku,
      taxExceptionReason: taxExceptionReason ?? this.taxExceptionReason,
      costCurrency: costCurrency ?? this.costCurrency,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
      costRate: costRate ?? this.costRate,
      itemType: itemType ?? this.itemType,
      itemCategory: itemCategory ?? this.itemCategory,
      salesRateFormatted: salesRateFormatted ?? this.salesRateFormatted,
      salesRateFormattedCur:
          salesRateFormattedCur ?? this.salesRateFormattedCur,
      costRateFormatted: costRateFormatted ?? this.costRateFormatted,
      costRateFormattedCur: costRateFormattedCur ?? this.costRateFormattedCur,
    );
  }
}
