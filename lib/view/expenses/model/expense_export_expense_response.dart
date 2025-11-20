// class ExportExpenseResponse {
//   final bool? error;
//   final String? message;
//   final ExportData? response;
//   final bool? status;

//   ExportExpenseResponse({
//     this.error,
//     this.message,
//     this.response,
//     this.status,
//   });

//   factory ExportExpenseResponse.fromJson(Map<String, dynamic> json) {
//     return ExportExpenseResponse(
//       error: json['error'] as bool?,
//       message: json['message'] as String?,
//       response: json['response'] != null
//           ? ExportData.fromJson(
//               json['response']['response'] as Map<String, dynamic>)
//           : null,
//       status: json['status'] as bool?,
//     );
//   }
// }

// class ExportData {
//   final String? excelData;
//   final String? excelType;
//   final String? excelFileName;

//   ExportData({
//     this.excelData,
//     this.excelType,
//     this.excelFileName,
//   });

//   factory ExportData.fromJson(Map<String, dynamic> json) {
//     return ExportData(
//       excelData: json['excelData'] as String?,
//       excelType: json['excelType'] as String?,
//       excelFileName: json['excelFileName'] as String?,
//     );
//   }
// }

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
    print('🔍 Export Response JSON: $json');

    return ExportExpenseResponse(
      error: json['error'] as bool?,
      message: json['message'] as String?,
      response: _parseResponse(json['response']),
      status: json['status'] as bool?,
    );
  }

  static ExportData? _parseResponse(dynamic responseData) {
    if (responseData == null) return null;

    print('🔍 Response data type: ${responseData.runtimeType}');
    print('🔍 Response data: $responseData');

    if (responseData is Map<String, dynamic>) {
      // Check if double nested: {response: {response: {excelData: ...}}}
      if (responseData.containsKey('response')) {
        final innerResponse = responseData['response'];
        if (innerResponse is Map<String, dynamic> &&
            innerResponse.containsKey('excelData')) {
          print('✅ Found double nested response');
          return ExportData.fromJson(innerResponse);
        }
      }

      // Check if single nested: {response: {excelData: ...}}
      if (responseData.containsKey('excelData')) {
        print('✅ Found single nested response');
        return ExportData.fromJson(responseData);
      }
    }

    print('❌ Could not parse export data structure');
    return null;
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
