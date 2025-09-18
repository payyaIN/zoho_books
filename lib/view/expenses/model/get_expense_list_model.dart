class GetExpenseListModel {
  GetExpenseListModel({
      this.error, 
      this.message, 
      this.response, 
      this.status,});

  GetExpenseListModel.fromJson(dynamic json) {
    error = json['error'];
    message = json['message'];
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
    status = json['status'];
  }
  bool? error;
  String? message;
  Response? response;
  bool? status;
GetExpenseListModel copyWith({  bool? error,
  String? message,
  Response? response,
  bool? status,
}) => GetExpenseListModel(  error: error ?? this.error,
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

class Response {
  Response({
      this.data, 
      this.totalRecord,});

  Response.fromJson(dynamic json) {
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }
    totalRecord = json['totalRecord'];
  }
  List<Data>? data;
  num? totalRecord;
Response copyWith({  List<Data>? data,
  num? totalRecord,
}) => Response(  data: data ?? this.data,
  totalRecord: totalRecord ?? this.totalRecord,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['totalRecord'] = totalRecord;
    return map;
  }

}

class Data {
  Data({
      this.date, 
      this.reference, 
      this.expenseAmount, 
      this.vendor, 
      this.expenseId, 
      this.expenseAccount, 
      this.currency, 
      this.branch, 
      this.paidThrough, 
      this.customer, 
      this.status,});

  Data.fromJson(dynamic json) {
    date = json['date'];
    reference = json['reference'];
    expenseAmount = json['expenseAmount'];
    vendor = json['vendor'];
    expenseId = json['expenseId'];
    expenseAccount = json['expenseAccount'];
    currency = json['currency'];
    branch = json['branch'];
    paidThrough = json['paidThrough'];
    customer = json['customer'];
    status = json['status'];
  }
  String? date;
  dynamic reference;
  num? expenseAmount;
  String? vendor;
  num? expenseId;
  String? expenseAccount;
  String? currency;
  String? branch;
  String? paidThrough;
  String? customer;
  String? status;
Data copyWith({  String? date,
  dynamic reference,
  num? expenseAmount,
  String? vendor,
  num? expenseId,
  String? expenseAccount,
  String? currency,
  String? branch,
  String? paidThrough,
  String? customer,
  String? status,
}) => Data(  date: date ?? this.date,
  reference: reference ?? this.reference,
  expenseAmount: expenseAmount ?? this.expenseAmount,
  vendor: vendor ?? this.vendor,
  expenseId: expenseId ?? this.expenseId,
  expenseAccount: expenseAccount ?? this.expenseAccount,
  currency: currency ?? this.currency,
  branch: branch ?? this.branch,
  paidThrough: paidThrough ?? this.paidThrough,
  customer: customer ?? this.customer,
  status: status ?? this.status,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['date'] = date;
    map['reference'] = reference;
    map['expenseAmount'] = expenseAmount;
    map['vendor'] = vendor;
    map['expenseId'] = expenseId;
    map['expenseAccount'] = expenseAccount;
    map['currency'] = currency;
    map['branch'] = branch;
    map['paidThrough'] = paidThrough;
    map['customer'] = customer;
    map['status'] = status;
    return map;
  }

}