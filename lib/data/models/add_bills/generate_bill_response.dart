class BillResponse {
  final String code;
  final String message;
  final List<BillDetail> details;

  BillResponse({
    required this.code,
    required this.message,
    required this.details,
  });

  factory BillResponse.fromJson(Map<String, dynamic> json) {
    return BillResponse(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => BillDetail.fromJson(e))
          .toList() ?? [], // ✅ If null, fallback to empty list
    );
  }
}

class BillDetail {
  final String billInvoiceNumber;
  final int billId;

  BillDetail({
    required this.billInvoiceNumber,
    required this.billId,
  });

  factory BillDetail.fromJson(Map<String, dynamic> json) {
    return BillDetail(
      billInvoiceNumber: json['billInvoiceNumber'] ?? '',
      billId: json['billId'] ?? 0,
    );
  }
}