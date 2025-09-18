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
    print('ProductModel.fromMap - Parsing response: ${json.keys}');

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
}

class ProductResponse {
  final List<ProductData> data;
  final int totalRecord;

  ProductResponse({
    required this.data,
    required this.totalRecord,
  });

  factory ProductResponse.fromMap(Map<String, dynamic> json) {
    print(
        'ProductResponse.fromMap - Parsing data array of length: ${json["data"] != null ? (json["data"] as List).length : 0}');

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

class ProductData {
  final dynamic salesAccountId;
  final String costRate;
  final int taxable;
  final int? preferedVendor;
  final String hsnOrSac;
  final String salesRate;
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

  ProductData({
    required this.salesAccountId,
    required this.costRate,
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
  });

  factory ProductData.empty() => ProductData(
        salesAccountId: 0,
        costRate: "0.00",
        taxable: 0,
        hsnOrSac: "",
        salesRate: "0.00",
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
      );

  factory ProductData.fromMap(Map<String, dynamic> json) {
    print('ProductData.fromMap - Parsing item: ${json["itemName"]}');

    return ProductData(
      salesAccountId: json["salesAccountId"],
      costRate: json["costRate"].toString(),
      taxable: json["taxable"] ?? 0,
      preferedVendor: json["preferedVendor"],
      hsnOrSac: json["hsnOrSac"] ?? "",
      salesRate: json["salesRate"].toString(),
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
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "salesAccountId": salesAccountId,
      "costRate": costRate,
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
    };
  }
}
