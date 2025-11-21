class BillEditDetailsModel {
  final int billId;
  final int? billCustomerId;
  final int? billVendorId;
  final int? billBranchId;
  final String? billInvoiceNumber;
  final bool isTaxInclusive;
  final String? billOrderNumber;
  final DateTime? billDate;
  final DateTime? billDueDate;
  final int? billCurrencyId;
  final String? billPaymentTerms;
  final String? billCustomerNotes;
  final String? billTermsCondition;
  final double? billAmount;
  final double? billTotalAmount;
  final double? billDiscountAmount;
  final String? billDiscountMethod;
  final double? billDiscountPercentage;
  final String? billDiscountType;
  final int? billRecurringId;
  final int? isModalShown;
  final bool? hasWorkflow;
  final String? billOrgId;
  final String? billCmpCr;
  final int? billStatus;
  final int? billType;
  final bool? billAdvance;
  final bool? billDelivery;
  final String? billInfo;
  final double? exchangeRate;
  final List<BillEditProductDetail> billProductDetails;
  final List<dynamic> billAttachments;

  BillEditDetailsModel({
    required this.billId,
    this.billCustomerId,
    this.billVendorId,
    this.billBranchId,
    this.billInvoiceNumber,
    required this.isTaxInclusive,
    this.billOrderNumber,
    this.billDate,
    this.billDueDate,
    this.billCurrencyId,
    this.billPaymentTerms,
    this.billCustomerNotes,
    this.billTermsCondition,
    this.billAmount,
    this.billTotalAmount,
    this.billDiscountAmount,
    this.billDiscountMethod,
    this.billDiscountPercentage,
    this.billDiscountType,
    this.billRecurringId,
    this.isModalShown,
    this.hasWorkflow,
    this.billOrgId,
    this.billCmpCr,
    this.billStatus,
    this.billType,
    this.billAdvance,
    this.billDelivery,
    this.billInfo,
    this.exchangeRate,
    this.billProductDetails = const [],
    this.billAttachments = const [],
  });

  factory BillEditDetailsModel.fromMap(Map<String, dynamic> json) {
    return BillEditDetailsModel(
      billId: json['billId'] ?? 0,
      billCustomerId: json['billCustomerId'],
      billVendorId: json['billVendorId'],
      billBranchId: json['billBranchId'],
      billInvoiceNumber: json['billInvoiceNumber'],
      isTaxInclusive: json['isTaxInclusive'] ?? false,
      billOrderNumber: json['billOrderNumber'],
      billDate: json['billDate'] != null ? DateTime.parse(json['billDate']) : null,
      billDueDate: json['billDueDate'] != null ? DateTime.parse(json['billDueDate']) : null,
      billCurrencyId: json['billCurrencyId'],
      billPaymentTerms: json['billPaymentTerms'],
      billCustomerNotes: json['billCustomerNotes'],
      billTermsCondition: json['billTermsCondition'],
      billAmount: _parseDouble(json['billAmount']),
      billTotalAmount: _parseDouble(json['billTotalAmount']),
      billDiscountAmount: _parseDouble(json['billDiscountAmount']),
      billDiscountMethod: json['billDiscountMethod'],
      billDiscountPercentage: _parseDouble(json['billDiscountPercentage']),
      billDiscountType: json['billDiscountType'],
      billRecurringId: json['billRecurringId'],
      isModalShown: json['isModalShown'],
      hasWorkflow: json['hasWorkflow'],
      billOrgId: json['billOrgId'],
      billCmpCr: json['billCmpCr'],
      billStatus: json['billStatus'],
      billType: json['billType'],
      billAdvance: json['billAdvance'],
      billDelivery: json['billDelivery'],
      billInfo: json['billInfo'],
      exchangeRate: _parseDouble(json['exchangeRate']),
      billProductDetails: json['billProductDetails'] != null
          ? (json['billProductDetails'] as List)
              .map((e) => BillEditProductDetail.fromMap(e))
              .toList()
          : [],
      billAttachments: json['billAttachments'] ?? [],
    );
  }
}

class BillEditProductDetail {
  final int? billDetId;
  final int? billDetBillId;
  final String? billProdName;
  final int? billProdId;
  final int? billProdCatId;
  final String? billProdDesc;
  final String? billProdAccount;
  final double? billProdUnitPrice;
  final int? billProdQuantity;
  final int? billProdUnitId;
  final int? billProdCustomerId;
  final double? billProdDiscountAmount;
  final double? billProdDiscountPercentage;
  final double? billProdOthersAmount;
  final String? billProdOthersDesc;
  final double? billProdTaxAmount;
  final String? billProdTaxDesc;
  final double? billProdTotalAmount;
  final int? billProdCurId;
  final BillProdTax? billProdTax;
  final String? billProdTaxExmptionReason;
  final double? billPercentage;
  final String? billProdDiscountType;

  BillEditProductDetail({
    this.billDetId,
    this.billDetBillId,
    this.billProdName,
    this.billProdId,
    this.billProdCatId,
    this.billProdDesc,
    this.billProdAccount,
    this.billProdUnitPrice,
    this.billProdQuantity,
    this.billProdUnitId,
    this.billProdCustomerId,
    this.billProdDiscountAmount,
    this.billProdDiscountPercentage,
    this.billProdOthersAmount,
    this.billProdOthersDesc,
    this.billProdTaxAmount,
    this.billProdTaxDesc,
    this.billProdTotalAmount,
    this.billProdCurId,
    this.billProdTax,
    this.billProdTaxExmptionReason,
    this.billPercentage,
    this.billProdDiscountType,
  });

  factory BillEditProductDetail.fromMap(Map<String, dynamic> json) {
    return BillEditProductDetail(
      billDetId: json['billDetId'],
      billDetBillId: json['billDetBillId'],
      billProdName: json['billProdName'],
      billProdId: json['billProdId'],
      billProdCatId: json['billProdCatId'],
      billProdDesc: json['billProdDesc'],
      billProdAccount: json['billProdAccount']?.toString(),
      billProdUnitPrice: _parseDouble(json['billProdUnitPrice']),
      billProdQuantity: json['billProdQuantity'],
      billProdUnitId: json['billProdUnitId'],
      billProdCustomerId: json['billProdCustomerId'],
      billProdDiscountAmount: _parseDouble(json['billProdDiscountAmount']),
      billProdDiscountPercentage: _parseDouble(json['billProdDiscountPercentage']),
      billProdOthersAmount: _parseDouble(json['billProdOthersAmount']),
      billProdOthersDesc: json['billProdOthersDesc'],
      billProdTaxAmount: _parseDouble(json['billProdTaxAmount']),
      billProdTaxDesc: json['billProdTaxDesc'],
      billProdTotalAmount: _parseDouble(json['billProdTotalAmount']),
      billProdCurId: json['billProdCurId'],
      billProdTax: json['billProdTax'] != null ? BillProdTax.fromMap(json['billProdTax']) : null,
      billProdTaxExmptionReason: json['billProdTaxExmptionReason'],
      billPercentage: _parseDouble(json['billPercentage']),
      billProdDiscountType: json['billProdDiscountType'],
    );
  }
}

class BillProdTax {
  final int? taxId;
  final String? taxType;

  BillProdTax({this.taxId, this.taxType});

  factory BillProdTax.fromMap(Map<String, dynamic> json) {
    return BillProdTax(
      taxId: json['taxId'],
      taxType: json['taxType'],
    );
  }
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}
