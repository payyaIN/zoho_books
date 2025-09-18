class QuotesListModel {
  QuotesListModel({
      this.fileName, 
      this.data, 
      this.html, 
      this.type, 
      this.message, 
      this.status,});

  QuotesListModel.fromJson(dynamic json) {
    fileName = json['fileName'];
    data = json['data'];
    html = json['html'];
    type = json['type'];
    message = json['message'];
    status = json['status'];
  }
  String? fileName;
  String? data;
  String? html;
  String? type;
  String? message;
  String? status;
QuotesListModel copyWith({  String? fileName,
  String? data,
  String? html,
  String? type,
  String? message,
  String? status,
}) => QuotesListModel(  fileName: fileName ?? this.fileName,
  data: data ?? this.data,
  html: html ?? this.html,
  type: type ?? this.type,
  message: message ?? this.message,
  status: status ?? this.status,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fileName'] = fileName;
    map['data'] = data;
    map['html'] = html;
    map['type'] = type;
    map['message'] = message;
    map['status'] = status;
    return map;
  }

}