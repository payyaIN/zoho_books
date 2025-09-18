class AddInvoiceModel {
  AddInvoiceModel({
      this.code, 
      this.message, 
      this.details,});

  AddInvoiceModel.fromJson(dynamic json) {
    code = json['code'];
    message = json['message'];
    if (json['details'] != null) {
      details = [];
      json['details'].forEach((v) {
        details?.add(Details.fromJson(v));
      });
    }
  }
  String? code;
  String? message;
  List<Details>? details;
AddInvoiceModel copyWith({  String? code,
  String? message,
  List<Details>? details,
}) => AddInvoiceModel(  code: code ?? this.code,
  message: message ?? this.message,
  details: details ?? this.details,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['message'] = message;
    if (details != null) {
      map['details'] = details?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Details {
  Details({
      this.invoiceOrderNumber, 
      this.invoiceNumber, 
      this.invoiceId,});

  Details.fromJson(dynamic json) {
    invoiceOrderNumber = json['invoiceOrderNumber'];
    invoiceNumber = json['invoiceNumber'];
    invoiceId = json['invoiceId'];
  }
  dynamic invoiceOrderNumber;
  String? invoiceNumber;
  num? invoiceId;
Details copyWith({  dynamic invoiceOrderNumber,
  String? invoiceNumber,
  num? invoiceId,
}) => Details(  invoiceOrderNumber: invoiceOrderNumber ?? this.invoiceOrderNumber,
  invoiceNumber: invoiceNumber ?? this.invoiceNumber,
  invoiceId: invoiceId ?? this.invoiceId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['invoiceOrderNumber'] = invoiceOrderNumber;
    map['invoiceNumber'] = invoiceNumber;
    map['invoiceId'] = invoiceId;
    return map;
  }

}