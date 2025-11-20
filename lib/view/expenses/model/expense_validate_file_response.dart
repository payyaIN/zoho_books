class ValidateFileResponse {
  final bool? error;
  final String? message;
  final ValidationData? response;
  final bool? status;

  ValidateFileResponse({
    this.error,
    this.message,
    this.response,
    this.status,
  });

  factory ValidateFileResponse.fromJson(Map<String, dynamic> json) {
    return ValidateFileResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      response: json['response'] != null
          ? ValidationData.fromJson(json['response'] as Map<String, dynamic>)
          : null,
      status: json['status'] as bool?,
    );
  }
}

class ValidationData {
  final int? failedRowCount;
  final int? validRowCount;
  final Map<String, dynamic>? validationMessage;
  final int? unmappedFieldCount;

  ValidationData({
    this.failedRowCount,
    this.validRowCount,
    this.validationMessage,
    this.unmappedFieldCount,
  });

  factory ValidationData.fromJson(Map<String, dynamic> json) {
    return ValidationData(
      failedRowCount: json['failedRowCount'] as int?,
      validRowCount: json['validRowCount'] as int?,
      validationMessage: json['validationMessage'] as Map<String, dynamic>?,
      unmappedFieldCount: json['unmappedFieldCount'] as int?,
    );
  }
}
