class ExpenseDetailModel {
  ExpenseDetailModel({
    this.error,
    this.message,
    this.response,
    this.status,
  });

  bool? error;
  String? message;
  ExpenseResponse? response;
  bool? status;

  factory ExpenseDetailModel.empty() {
    return ExpenseDetailModel(
      error: true,
      message: "Empty",
      response: ExpenseResponse.empty(),
      status: false,
    );
  }

  ExpenseDetailModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    response = json['response'] != null
        ? ExpenseResponse.fromJson(json['response'])
        : null;
    status = json['status'];
  }

  ExpenseDetailModel copyWith({
    bool? error,
    String? message,
    ExpenseResponse? response,
    bool? status,
  }) =>
      ExpenseDetailModel(
        error: error ?? this.error,
        message: message ?? this.message,
        response: response ?? this.response,
        status: status ?? this.status,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.toJson();
    }
    map['status'] = status;
    return map;
  }
}

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
    );
  }

  ExpenseResponse.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    tax = json['tax'];
    branch = json['branch'];
    transactionId = json['transactionId'];
    reference = json['reference'];
    exemptionReason = json['exemptionReason'];
    expenseAmount = json['expenseAmount'];
    vendor = json['vendor'];
    expenseAccount = json['expenseAccount'];
    files = json['files'];
    currency = json['currency'];
    paidThrough = json['paidThrough'];
    customer = json['customer'];
    status = json['status'];
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
  }) =>
      ExpenseResponse(
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
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['tax'] = tax;
    map['branch'] = branch;
    map['transactionId'] = transactionId;
    map['reference'] = reference;
    map['exemptionReason'] = exemptionReason;
    map['expenseAmount'] = expenseAmount;
    map['vendor'] = vendor;
    map['expenseAccount'] = expenseAccount;
    map['files'] = files;
    map['currency'] = currency;
    map['paidThrough'] = paidThrough;
    map['customer'] = customer;
    map['status'] = status;
    return map;
  }
}
