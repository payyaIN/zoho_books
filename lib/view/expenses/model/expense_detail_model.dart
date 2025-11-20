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
    // New ID fields
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

  // New ID fields
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

    // Parse new ID fields
    branchId = json['branchId'];
    currencyId = json['currencyId'];
    expenseAccountId = json['expenseAccountId'];
    paidThroughAccountId = json['paidThroughAccountId'];
    paidThroughAccount = json['paidThroughAccount'];
    vendorId = json['vendorId'];
    customerId = json['customerId'];
    customerName = json['customerName'];
    taxId = json['taxId'];
    taxName = json['taxName'];
    expenseDescription = json['expenseDescription'];
    expenseInfo = json['expenseInfo'];
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
    map['branchId'] = branchId;
    map['currencyId'] = currencyId;
    map['expenseAccountId'] = expenseAccountId;
    map['paidThroughAccountId'] = paidThroughAccountId;
    map['paidThroughAccount'] = paidThroughAccount;
    map['vendorId'] = vendorId;
    map['customerId'] = customerId;
    map['customerName'] = customerName;
    map['taxId'] = taxId;
    map['taxName'] = taxName;
    map['expenseDescription'] = expenseDescription;
    map['expenseInfo'] = expenseInfo;
    return map;
  }
}
