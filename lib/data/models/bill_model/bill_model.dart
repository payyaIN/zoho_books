import 'dart:convert';

class BillModel {
  final int? count;
  final int? totalCount;
  final List<BillData>? billData;

  BillModel({
    this.count,
    this.totalCount,
    this.billData,
  });

  factory BillModel.fromJson(String str) => BillModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillModel.fromMap(Map<String, dynamic> json) {
    print('BillModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    List<dynamic> billDataList = [];

    if (json.containsKey("billData")) {
      if (json["billData"] is List) {
        billDataList = json["billData"] as List;
        print('Found ${billDataList.length} bills in response');
      } else {
        print('Warning: "billData" is not a List');
      }
    } else {
      print('Warning: No "billData" key found');
    }

    return BillModel(
      count: json["count"] ?? 0,
      totalCount: json["totalCount"] ?? 0,
      billData: List<BillData>.from(billDataList.map((x) {
        if (x is Map) {
          return BillData.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Bill data item is not a Map');
          return BillData.empty();
        }
      })),
    );
  }

  Map<String, dynamic> toMap() => {
        "count": count,
        "totalCount": totalCount,
        "billData": List<dynamic>.from(billData!.map((x) => x.toMap())),
      };
}

class BillData {
  final String billCreatedBy;
  final String billInvoiceNumber;
  final int billCurrencyId;
  final DateTime billDate;
  final List<ProductDetail> productDetails;
  final bool isBillSubWithWf;
  final double billAmount;
  final DateTime billCreatedDate;
  final double billTotalAmount;
  final double billDiscountAmount;
  final int billId;
  final String billCurrency;
  final String billVenderName;
  final int billStatus;
  final String billCustomerNotes;
  final int isBillVerified;
  final String billOrderNumber;
  final DateTime billDueDate;
  final String billBranchName;
  final List<dynamic> wfList;

  BillData({
    required this.billCreatedBy,
    required this.billInvoiceNumber,
    required this.billCurrencyId,
    required this.billDate,
    required this.productDetails,
    required this.isBillSubWithWf,
    required this.billAmount,
    required this.billCreatedDate,
    required this.billTotalAmount,
    required this.billDiscountAmount,
    required this.billId,
    required this.billCurrency,
    required this.billVenderName,
    required this.billStatus,
    required this.billCustomerNotes,
    required this.isBillVerified,
    required this.billOrderNumber,
    required this.billDueDate,
    required this.billBranchName,
    required this.wfList,
  });

  // Factory method to create an empty bill as fallback
  factory BillData.empty() => BillData(
        billCreatedBy: "",
        billInvoiceNumber: "",
        billCurrencyId: 0,
        billDate: DateTime.now(),
        productDetails: [],
        isBillSubWithWf: false,
        billAmount: 0.0,
        billCreatedDate: DateTime.now(),
        billTotalAmount: 0.0,
        billDiscountAmount: 0.0,
        billId: 0,
        billCurrency: "",
        billVenderName: "",
        billStatus: 0,
        billCustomerNotes: "",
        isBillVerified: 0,
        billOrderNumber: "",
        billDueDate: DateTime.now(),
        billBranchName: "",
        wfList: [],
      );

  factory BillData.fromJson(String str) => BillData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BillData.fromMap(Map<String, dynamic> json) {
    print('BillData.fromMap - Processing bill with ID: ${json["billId"]}');

    List<dynamic> productDetailsList = [];

    if (json.containsKey("productDetails")) {
      if (json["productDetails"] is List) {
        productDetailsList = json["productDetails"] as List;
        print(
            'Found ${productDetailsList.length} product details for bill ID: ${json["billId"]}');
      } else {
        print('Warning: "productDetails" is not a List');
      }
    } else {
      print('Warning: No "productDetails" key found');
    }

    return BillData(
      billCreatedBy: json["billCreatedBy"] ?? "",
      billInvoiceNumber: json["billInvoiceNumber"] ?? "",
      billCurrencyId: json["billCurrencyId"] ?? 0,
      billDate: json["billDate"] != null
          ? DateTime.parse(json["billDate"])
          : DateTime.now(),
      productDetails: List<ProductDetail>.from(productDetailsList.map((x) {
        if (x is Map) {
          return ProductDetail.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Product detail item is not a Map');
          return ProductDetail.empty();
        }
      })),
      isBillSubWithWf: json["isBillSubWithWf"] ?? false,
      billAmount: _parseDouble(json["billAmount"]),
      billCreatedDate: json["billCreatedDate"] != null
          ? DateTime.parse(json["billCreatedDate"])
          : DateTime.now(),
      billTotalAmount: _parseDouble(json["billTotalAmount"]),
      billDiscountAmount: _parseDouble(json["billDiscountAmount"]),
      billId: json["billId"] ?? 0,
      billCurrency: json["billCurrency"] ?? "",
      billVenderName: json["billVenderName"] ?? "",
      billStatus: json["billStatus"] ?? 0,
      billCustomerNotes: json["billCustomerNotes"] ?? "",
      isBillVerified: json["isBillVerified"] ?? 0,
      billOrderNumber: json["billOrderNumber"] ?? "",
      billDueDate: json["billDueDate"] != null
          ? DateTime.parse(json["billDueDate"])
          : DateTime.now(),
      billBranchName: json["billBranchName"] ?? "",
      wfList: json["wfList"] != null ? List<dynamic>.from(json["wfList"]) : [],
    );
  }

  Map<String, dynamic> toMap() => {
        "billCreatedBy": billCreatedBy,
        "billInvoiceNumber": billInvoiceNumber,
        "billCurrencyId": billCurrencyId,
        "billDate": billDate.toIso8601String(),
        "productDetails":
            List<dynamic>.from(productDetails.map((x) => x.toMap())),
        "isBillSubWithWf": isBillSubWithWf,
        "billAmount": billAmount,
        "billCreatedDate": billCreatedDate.toIso8601String(),
        "billTotalAmount": billTotalAmount,
        "billDiscountAmount": billDiscountAmount,
        "billId": billId,
        "billCurrency": billCurrency,
        "billVenderName": billVenderName,
        "billStatus": billStatus,
        "billCustomerNotes": billCustomerNotes,
        "isBillVerified": isBillVerified,
        "billOrderNumber": billOrderNumber,
        "billDueDate": billDueDate.toIso8601String(),
        "billBranchName": billBranchName,
        "wfList": List<dynamic>.from(wfList.map((x) => x)),
      };
}

class ProductDetail {
  final double unitPrice;
  final int billDetBillId;
  final int quantity;
  final int productId;
  final double totalPrice;
  final String? taxDesc;
  final double discountAmount;
  final String productUnit;
  final String productName;
  final int billDetId;
  final int productUnitId;
  final String productDesc;
  final double? discountPercentage;
  final double taxAmount;

  ProductDetail({
    required this.unitPrice,
    required this.billDetBillId,
    required this.quantity,
    required this.productId,
    required this.totalPrice,
    this.taxDesc,
    required this.discountAmount,
    required this.productUnit,
    required this.productName,
    required this.billDetId,
    required this.productUnitId,
    required this.productDesc,
    this.discountPercentage,
    required this.taxAmount,
  });

  // Factory method to create an empty product detail as fallback
  factory ProductDetail.empty() => ProductDetail(
        unitPrice: 0.0,
        billDetBillId: 0,
        quantity: 0,
        productId: 0,
        totalPrice: 0.0,
        discountAmount: 0.0,
        productUnit: "",
        productName: "",
        billDetId: 0,
        productUnitId: 0,
        productDesc: "",
        taxAmount: 0.0,
      );

  factory ProductDetail.fromJson(String str) =>
      ProductDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductDetail.fromMap(Map<String, dynamic> json) {
    return ProductDetail(
      unitPrice: _parseDouble(json["unitPrice"]),
      billDetBillId: json["billDetBillId"] ?? 0,
      quantity: json["quantity"] ?? 0,
      productId: json["productId"] ?? 0,
      totalPrice: _parseDouble(json["totalPrice"]),
      taxDesc: json["taxDesc"],
      discountAmount: _parseDouble(json["discountAmount"]),
      productUnit: json["productUnit"] ?? "",
      productName: json["productName"] ?? "",
      billDetId: json["billDetId"] ?? 0,
      productUnitId: json["productUnitId"] ?? 0,
      productDesc: json["productDesc"] ?? "",
      discountPercentage: json["discountPercentage"] != null
          ? _parseDouble(json["discountPercentage"])
          : null,
      taxAmount: _parseDouble(json["taxAmount"]),
    );
  }

  Map<String, dynamic> toMap() => {
        "unitPrice": unitPrice,
        "billDetBillId": billDetBillId,
        "quantity": quantity,
        "productId": productId,
        "totalPrice": totalPrice,
        "taxDesc": taxDesc,
        "discountAmount": discountAmount,
        "productUnit": productUnit,
        "productName": productName,
        "billDetId": billDetId,
        "productUnitId": productUnitId,
        "productDesc": productDesc,
        "discountPercentage": discountPercentage,
        "taxAmount": taxAmount,
      };
}

// Helper function to safely parse double values
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
