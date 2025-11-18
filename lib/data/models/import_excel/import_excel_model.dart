class ExcelExportModel {
  bool? error;
  String? message;
  ExcelExportResponse? response;
  bool? status;

  ExcelExportModel({this.error, this.message, this.response, this.status});

  ExcelExportModel.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    response = json['response'] != null
        ? new ExcelExportResponse.fromJson(json['response'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class ExcelExportResponse {
  bool? error;
  Null? message;
  ExcelExportResponse? response;
  bool? status;

  ExcelExportResponse({this.error, this.message, this.response, this.status});

  ExcelExportResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    response = json['response'] != null
        ? new ExcelExportResponse.fromJson(json['response'])
        : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['message'] = this.message;
    if (this.response != null) {
      data['response'] = this.response!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class ExcelApiResponse {
  String? excelData;
  String? excelType;
  String? excelFileName;

  ExcelApiResponse({this.excelData, this.excelType, this.excelFileName});

  ExcelApiResponse.fromJson(Map<String, dynamic> json) {
    excelData = json['excelData'];
    excelType = json['excelType'];
    excelFileName = json['excelFileName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['excelData'] = this.excelData;
    data['excelType'] = this.excelType;
    data['excelFileName'] = this.excelFileName;
    return data;
  }
}
