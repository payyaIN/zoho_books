class ExportExpenseResponse {
  final bool? error;
  final String? message;
  final ExportData? response;
  final bool? status;

  ExportExpenseResponse({
    this.error,
    this.message,
    this.response,
    this.status,
  });

  factory ExportExpenseResponse.fromJson(Map<String, dynamic> json) {
    return ExportExpenseResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      response: json['response'] != null
          ? ExportData.fromJson(
              json['response']['response'] as Map<String, dynamic>)
          : null,
      status: json['status'] as bool?,
    );
  }
}

class ExportData {
  final String? excelData;
  final String? excelType;
  final String? excelFileName;

  ExportData({
    this.excelData,
    this.excelType,
    this.excelFileName,
  });

  factory ExportData.fromJson(Map<String, dynamic> json) {
    return ExportData(
      excelData: json['excelData'] as String?,
      excelType: json['excelType'] as String?,
      excelFileName: json['excelFileName'] as String?,
    );
  }
}
