import 'dart:convert';

class InvoiceModel {
  final int? count;
  final int? totalCount;
  final List<InvoiceData>? invoiceData;

  InvoiceModel({
    this.count,
    this.totalCount,
    this.invoiceData,
  });

  factory InvoiceModel.fromJson(String str) =>
      InvoiceModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InvoiceModel.fromMap(Map<String, dynamic> json) {
    print('InvoiceModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    List<dynamic> invoiceDataList = [];

    if (json.containsKey("invoiceData")) {
      if (json["invoiceData"] is List) {
        invoiceDataList = json["invoiceData"] as List;
        print('Found ${invoiceDataList.length} invoices in response');
      } else {
        print('Warning: "invoiceData" is not a List');
      }
    } else {
      print('Warning: No "invoiceData" key found');
    }

    return InvoiceModel(
      count: json["count"] ?? 0,
      totalCount: json["totalCount"] ?? 0,
      invoiceData: List<InvoiceData>.from(invoiceDataList.map((x) {
        if (x is Map) {
          return InvoiceData.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Invoice data item is not a Map');
          return InvoiceData.empty();
        }
      })),
    );
  }

  Map<String, dynamic> toMap() => {
        "count": count,
        "totalCount": totalCount,
        "invoiceData": List<dynamic>.from(invoiceData!.map((x) => x.toMap())),
      };
}

class InvoiceData {
  final String invoiceOrganizationId;
  final int invoiceCustomerId;
  final String invoiceOrderNumber;
  final dynamic invoiceTransType;
  final dynamic invoiceSalesPerson;
  final String invoiceCustomerNotes;
  final int invoiceShippingType;
  final double invoiceAmount;
  final List<ProductDetail> productDetails;
  final String invoiceCurrency;
  final String invoiceCustomerName;
  final String invoiceBranchName;
  final DateTime invoiceCreatedDate;
  final String invoiceNumber;
  final dynamic invoiceVendorId;
  final dynamic invoiceSubject;
  final List<dynamic> wfList;
  final String invoiceCompanyId;
  final int invoiceBranchId;
  final String invoiceDate;
  final double invoiceTotalAmount;
  final int invoiceCurrencyId;
  final String invoiceDueDate;
  final String invoiceSupplyDate;
  final String invoicePaymentTerms;
  final bool isInvoiceSubWithWf;
  final String invoiceCreatedBy;
  final int invoiceId;
  final int isInvoiceverified;
  final int invoiceStatus;
  final String invoiceTermsAndConditions;

  InvoiceData({
    required this.invoiceOrganizationId,
    required this.invoiceCustomerId,
    required this.invoiceOrderNumber,
    this.invoiceTransType,
    this.invoiceSalesPerson,
    required this.invoiceCustomerNotes,
    required this.invoiceShippingType,
    required this.invoiceAmount,
    required this.productDetails,
    required this.invoiceCurrency,
    required this.invoiceCustomerName,
    required this.invoiceBranchName,
    required this.invoiceCreatedDate,
    required this.invoiceNumber,
    this.invoiceVendorId,
    this.invoiceSubject,
    required this.wfList,
    required this.invoiceCompanyId,
    required this.invoiceBranchId,
    required this.invoiceDate,
    required this.invoiceTotalAmount,
    required this.invoiceCurrencyId,
    required this.invoiceDueDate,
    required this.invoiceSupplyDate,
    required this.invoicePaymentTerms,
    required this.isInvoiceSubWithWf,
    required this.invoiceCreatedBy,
    required this.invoiceId,
    required this.isInvoiceverified,
    required this.invoiceStatus,
    required this.invoiceTermsAndConditions,
  });

  factory InvoiceData.empty() => InvoiceData(
        invoiceOrganizationId: "",
        invoiceCustomerId: 0,
        invoiceOrderNumber: "",
        invoiceCustomerNotes: "",
        invoiceShippingType: 0,
        invoiceAmount: 0.0,
        productDetails: [],
        invoiceCurrency: "",
        invoiceCustomerName: "",
        invoiceBranchName: "",
        invoiceCreatedDate: DateTime.now(),
        invoiceNumber: "",
        wfList: [],
        invoiceCompanyId: "",
        invoiceBranchId: 0,
        invoiceDate: "",
        invoiceTotalAmount: 0.0,
        invoiceCurrencyId: 0,
        invoiceDueDate: "",
        invoiceSupplyDate: "",
        invoicePaymentTerms: "",
        isInvoiceSubWithWf: false,
        invoiceCreatedBy: "",
        invoiceId: 0,
        isInvoiceverified: 0,
        invoiceStatus: 0,
        invoiceTermsAndConditions: "",
      );

  factory InvoiceData.fromJson(String str) =>
      InvoiceData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory InvoiceData.fromMap(Map<String, dynamic> json) {
    print(
        'InvoiceData.fromMap - Processing invoice with ID: ${json["invoiceId"]}');

    List<dynamic> productDetailsList = [];

    if (json.containsKey("productDetails")) {
      if (json["productDetails"] is List) {
        productDetailsList = json["productDetails"] as List;
        print(
            'Found ${productDetailsList.length} product details for invoice ID: ${json["invoiceId"]}');
      } else {
        print('Warning: "productDetails" is not a List');
      }
    } else {
      print('Warning: No "productDetails" key found');
    }

    return InvoiceData(
      invoiceOrganizationId: json["invoiceOrganizationId"] ?? "",
      invoiceCustomerId: json["invoiceCustomerId"] ?? 0,
      invoiceOrderNumber: json["invoiceOrderNumber"] ?? "",
      invoiceTransType: json["invoiceTransType"],
      invoiceSalesPerson: json["invoiceSalesPerson"],
      invoiceCustomerNotes: json["invoiceCustomerNotes"] ?? "",
      invoiceShippingType: json["invoiceShippingType"] ?? 0,
      invoiceAmount: _parseDouble(json["invoiceAmount"]),
      productDetails: List<ProductDetail>.from(productDetailsList.map((x) {
        if (x is Map) {
          return ProductDetail.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Product detail item is not a Map');
          return ProductDetail.empty();
        }
      })),
      invoiceCurrency: json["invoiceCurrency"] ?? "",
      invoiceCustomerName: json["invoiceCustomerName"] ?? "",
      invoiceBranchName: json["invoiceBranchName"] ?? "",
      invoiceCreatedDate: json["invoiceCreatedDate"] != null
          ? DateTime.parse(json["invoiceCreatedDate"])
          : DateTime.now(),
      invoiceNumber: json["invoiceNumber"] ?? "",
      invoiceVendorId: json["invoiceVendorId"],
      invoiceSubject: json["invoiceSubject"],
      wfList: json["wfList"] != null ? List<dynamic>.from(json["wfList"]) : [],
      invoiceCompanyId: json["invoiceCompanyId"] ?? "",
      invoiceBranchId: json["invoiceBranchId"] ?? 0,
      invoiceDate: json["invoiceDate"] ?? "",
      invoiceTotalAmount: _parseDouble(json["invoiceTotalAmount"]),
      invoiceCurrencyId: json["invoiceCurrencyId"] ?? 0,
      invoiceDueDate: json["invoiceDueDate"] ?? "",
      invoiceSupplyDate: json["invoiceSupplyDate"] ?? "",
      invoicePaymentTerms: json["invoicePaymentTerms"] ?? "",
      isInvoiceSubWithWf: json["isInvoiceSubWithWf"] ?? false,
      invoiceCreatedBy: json["invoiceCreatedBy"] ?? "",
      invoiceId: json["invoiceId"] ?? 0,
      isInvoiceverified: json["isInvoiceverified"] ?? 0,
      invoiceStatus: json["invoiceStatus"] ?? 0,
      invoiceTermsAndConditions: json["invoiceTermsAndConditions"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "invoiceOrganizationId": invoiceOrganizationId,
        "invoiceCustomerId": invoiceCustomerId,
        "invoiceOrderNumber": invoiceOrderNumber,
        "invoiceTransType": invoiceTransType,
        "invoiceSalesPerson": invoiceSalesPerson,
        "invoiceCustomerNotes": invoiceCustomerNotes,
        "invoiceShippingType": invoiceShippingType,
        "invoiceAmount": invoiceAmount,
        "productDetails":
            List<dynamic>.from(productDetails.map((x) => x.toMap())),
        "invoiceCurrency": invoiceCurrency,
        "invoiceCustomerName": invoiceCustomerName,
        "invoiceBranchName": invoiceBranchName,
        "invoiceCreatedDate": invoiceCreatedDate.toIso8601String(),
        "invoiceNumber": invoiceNumber,
        "invoiceVendorId": invoiceVendorId,
        "invoiceSubject": invoiceSubject,
        "wfList": List<dynamic>.from(wfList.map((x) => x)),
        "invoiceCompanyId": invoiceCompanyId,
        "invoiceBranchId": invoiceBranchId,
        "invoiceDate": invoiceDate,
        "invoiceTotalAmount": invoiceTotalAmount,
        "invoiceCurrencyId": invoiceCurrencyId,
        "invoiceDueDate": invoiceDueDate,
        "invoiceSupplyDate": invoiceSupplyDate,
        "invoicePaymentTerms": invoicePaymentTerms,
        "isInvoiceSubWithWf": isInvoiceSubWithWf,
        "invoiceCreatedBy": invoiceCreatedBy,
        "invoiceId": invoiceId,
        "isInvoiceverified": isInvoiceverified,
        "invoiceStatus": invoiceStatus,
        "invoiceTermsAndConditions": invoiceTermsAndConditions,
      };
}

class ProductDetail {
  final int invDetInvoiceId;
  final double unitPrice;
  final int quantity;
  final int productId;
  final dynamic taxDesc;
  final double discountAmount;
  final String productName;
  final double productTotal;
  final int invDetId;
  final dynamic discountPercentage;
  final dynamic productCategoryId;
  final dynamic othersDesc;
  final double othersAmount;
  final double taxAmount;
  final int currencyId;
  final String productDescription;
  final String taxType;

  ProductDetail({
    required this.invDetInvoiceId,
    required this.unitPrice,
    required this.quantity,
    required this.productId,
    this.taxDesc,
    required this.discountAmount,
    required this.productName,
    required this.productTotal,
    required this.invDetId,
    this.discountPercentage,
    this.productCategoryId,
    this.othersDesc,
    required this.othersAmount,
    required this.taxAmount,
    required this.currencyId,
    required this.productDescription,
    required this.taxType,
  });

  factory ProductDetail.empty() => ProductDetail(
        invDetInvoiceId: 0,
        unitPrice: 0.0,
        quantity: 0,
        productId: 0,
        discountAmount: 0.0,
        productName: "",
        productTotal: 0.0,
        invDetId: 0,
        othersAmount: 0.0,
        taxAmount: 0.0,
        currencyId: 0,
        productDescription: "",
        taxType: "",
      );

  factory ProductDetail.fromJson(String str) =>
      ProductDetail.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ProductDetail.fromMap(Map<String, dynamic> json) {
    return ProductDetail(
      invDetInvoiceId: json["invDetInvoiceId"] ?? 0,
      unitPrice: _parseDouble(json["unitPrice"]),
      quantity: json["quantity"] ?? 0,
      productId: json["productId"] ?? 0,
      taxDesc: json["taxDesc"],
      discountAmount: _parseDouble(json["discountAmount"]),
      productName: json["productName"] ?? "",
      productTotal: _parseDouble(json["productTotal"]),
      invDetId: json["invDetId"] ?? 0,
      discountPercentage: json["discountPercentage"],
      productCategoryId: json["productCategoryId"],
      othersDesc: json["othersDesc"],
      othersAmount: _parseDouble(json["othersAmount"]),
      taxAmount: _parseDouble(json["taxAmount"]),
      currencyId: json["currencyId"] ?? 0,
      productDescription: json["productDescription"] ?? "",
      taxType: json["taxType"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "invDetInvoiceId": invDetInvoiceId,
        "unitPrice": unitPrice,
        "quantity": quantity,
        "productId": productId,
        "taxDesc": taxDesc,
        "discountAmount": discountAmount,
        "productName": productName,
        "productTotal": productTotal,
        "invDetId": invDetId,
        "discountPercentage": discountPercentage,
        "productCategoryId": productCategoryId,
        "othersDesc": othersDesc,
        "othersAmount": othersAmount,
        "taxAmount": taxAmount,
        "currencyId": currencyId,
        "productDescription": productDescription,
        "taxType": taxType,
      };
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
