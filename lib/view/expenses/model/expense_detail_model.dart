class ExpenseDetailModel {
  final bool? error;
  final String? message;
  final ExpenseResponse? response; // ← This is the response data
  final bool? status;

  ExpenseDetailModel({
    this.error,
    this.message,
    this.response,
    this.status,
  });

  factory ExpenseDetailModel.fromJson(Map<String, dynamic> json) {
    return ExpenseDetailModel(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      response: json['response'] != null
          ? ExpenseResponse.fromJson(json['response'] as Map<String, dynamic>)
          : null,
      status: json['status'] as bool?,
    );
  }

  factory ExpenseDetailModel.empty() {
    return ExpenseDetailModel(
      error: true,
      message: 'No data',
      response: ExpenseResponse.empty(),
      status: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'response': response?.toJson(),
      'status': status,
    };
  }
}

// ✅ THIS CLASS WAS ALREADY THERE
class ExpenseResponse {
  ExpenseResponse({
    this.date,
    this.tax,
    this.branch,
    this.transactionId,
    this.reference,
    this.exemptionReason,
    this.expenseAmount,
    this.vendor,
    this.expenseAccount,
    this.files,
    this.currency,
    this.paidThrough,
    this.customer,
    this.status,
    // ID fields
    this.branchId,
    this.currencyId,
    this.expenseAccountId,
    this.paidThroughAccountId,
    this.paidThroughAccount,
    this.vendorId,
    this.customerId,
    this.customerName,
    this.taxId,
    this.taxName,
    this.expenseDescription,
    this.expenseInfo,
  });

  String? date;
  String? tax;
  String? branch;
  num? transactionId;
  dynamic reference;
  dynamic exemptionReason;
  num? expenseAmount;
  String? vendor;
  String? expenseAccount;
  List<dynamic>? files;
  String? currency;
  String? paidThrough;
  String? customer;
  String? status;

  // ID fields
  int? branchId;
  int? currencyId;
  int? expenseAccountId;
  int? paidThroughAccountId;
  String? paidThroughAccount;
  int? vendorId;
  int? customerId;
  String? customerName;
  int? taxId;
  String? taxName;
  String? expenseDescription;
  String? expenseInfo;

  factory ExpenseResponse.empty() {
    return ExpenseResponse(
      date: '',
      tax: '',
      branch: '',
      transactionId: 0,
      reference: null,
      exemptionReason: null,
      expenseAmount: 0,
      vendor: '',
      expenseAccount: '',
      files: [],
      currency: '',
      paidThrough: '',
      customer: '',
      status: '',
      branchId: null,
      currencyId: null,
      expenseAccountId: null,
      paidThroughAccountId: null,
      paidThroughAccount: null,
      vendorId: null,
      customerId: null,
      customerName: null,
      taxId: null,
      taxName: null,
      expenseDescription: null,
      expenseInfo: null,
    );
  }

  factory ExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExpenseResponse(
      date: json['date'] as String?,
      tax: json['tax'] as String?,
      branch: json['branch'] as String?,
      transactionId: json['transactionId'] as num?,
      reference: json['reference'],
      exemptionReason: json['exemptionReason'],
      expenseAmount: json['expenseAmount'] as num?,
      vendor: json['vendor'] as String?,
      expenseAccount: json['expenseAccount'] as String?,
      files: json['files'] as List<dynamic>?,
      currency: json['currency'] as String?,
      paidThrough: json['paidThrough'] as String?,
      customer: json['customer'] as String?,
      status: json['status'] as String?,
      branchId: json['branchId'] as int?,
      currencyId: json['currencyId'] as int?,
      expenseAccountId: json['expenseAccountId'] as int?,
      paidThroughAccountId: json['paidThroughAccountId'] as int?,
      paidThroughAccount: json['paidThroughAccount'] as String?,
      vendorId: json['vendorId'] as int?,
      customerId: json['customerId'] as int?,
      customerName: json['customerName'] as String?,
      taxId: json['taxId'] as int?,
      taxName: json['taxName'] as String?,
      expenseDescription: json['expenseDescription'] as String?,
      expenseInfo: json['expenseInfo'] as String?,
    );
  }

  ExpenseResponse copyWith({
    String? date,
    String? tax,
    String? branch,
    num? transactionId,
    dynamic reference,
    dynamic exemptionReason,
    num? expenseAmount,
    String? vendor,
    String? expenseAccount,
    List<dynamic>? files,
    String? currency,
    String? paidThrough,
    String? customer,
    String? status,
    int? branchId,
    int? currencyId,
    int? expenseAccountId,
    int? paidThroughAccountId,
    String? paidThroughAccount,
    int? vendorId,
    int? customerId,
    String? customerName,
    int? taxId,
    String? taxName,
    String? expenseDescription,
    String? expenseInfo,
  }) {
    return ExpenseResponse(
      date: date ?? this.date,
      tax: tax ?? this.tax,
      branch: branch ?? this.branch,
      transactionId: transactionId ?? this.transactionId,
      reference: reference ?? this.reference,
      exemptionReason: exemptionReason ?? this.exemptionReason,
      expenseAmount: expenseAmount ?? this.expenseAmount,
      vendor: vendor ?? this.vendor,
      expenseAccount: expenseAccount ?? this.expenseAccount,
      files: files ?? this.files,
      currency: currency ?? this.currency,
      paidThrough: paidThrough ?? this.paidThrough,
      customer: customer ?? this.customer,
      status: status ?? this.status,
      branchId: branchId ?? this.branchId,
      currencyId: currencyId ?? this.currencyId,
      expenseAccountId: expenseAccountId ?? this.expenseAccountId,
      paidThroughAccountId: paidThroughAccountId ?? this.paidThroughAccountId,
      paidThroughAccount: paidThroughAccount ?? this.paidThroughAccount,
      vendorId: vendorId ?? this.vendorId,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      taxId: taxId ?? this.taxId,
      taxName: taxName ?? this.taxName,
      expenseDescription: expenseDescription ?? this.expenseDescription,
      expenseInfo: expenseInfo ?? this.expenseInfo,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'tax': tax,
      'branch': branch,
      'transactionId': transactionId,
      'reference': reference,
      'exemptionReason': exemptionReason,
      'expenseAmount': expenseAmount,
      'vendor': vendor,
      'expenseAccount': expenseAccount,
      'files': files,
      'currency': currency,
      'paidThrough': paidThrough,
      'customer': customer,
      'status': status,
      'branchId': branchId,
      'currencyId': currencyId,
      'expenseAccountId': expenseAccountId,
      'paidThroughAccountId': paidThroughAccountId,
      'paidThroughAccount': paidThroughAccount,
      'vendorId': vendorId,
      'customerId': customerId,
      'customerName': customerName,
      'taxId': taxId,
      'taxName': taxName,
      'expenseDescription': expenseDescription,
      'expenseInfo': expenseInfo,
    };
  }
}
