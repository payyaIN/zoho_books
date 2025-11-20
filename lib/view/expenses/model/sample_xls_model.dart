class DownloadSampleResponse {
  final bool? error;
  final String? message;
  final SampleFileData? response;
  final bool? status;

  DownloadSampleResponse({
    this.error,
    this.message,
    this.response,
    this.status,
  });

  factory DownloadSampleResponse.fromJson(Map<String, dynamic> json) {
    return DownloadSampleResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      response: json['response'] != null
          ? SampleFileData.fromJson(
              json['response']['response'] as Map<String, dynamic>)
          : null,
      status: json['status'] as bool?,
    );
  }
}

class SampleFileData {
  final String? excelData;
  final String? excelType;
  final String? excelFileName;

  SampleFileData({
    this.excelData,
    this.excelType,
    this.excelFileName,
  });

  factory SampleFileData.fromJson(Map<String, dynamic> json) {
    return SampleFileData(
      excelData: json['excelData'] as String?,
      excelType: json['excelType'] as String?,
      excelFileName: json['excelFileName'] as String?,
    );
  }
}
