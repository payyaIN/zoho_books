class ShippingMethodModel {
  final int? shpmId;
  final String? shpmName;
  final String? shpmDescription;
  final String? shpmIsActive;
  final String? shpmCreatedDate;
  final dynamic shpmSupportCountries;

  ShippingMethodModel({
    this.shpmId,
    this.shpmName,
    this.shpmDescription,
    this.shpmIsActive,
    this.shpmCreatedDate,
    this.shpmSupportCountries,
  });

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) {
    return ShippingMethodModel(
      shpmId: json['shpmId'],
      shpmName: json['shpmName'],
      shpmDescription: json['shpmDescription'],
      shpmIsActive: json['shpmIsActive'],
      shpmCreatedDate: json['shpmCreatedDate'],
      shpmSupportCountries: json['shpmSupportCountries'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'shpmId': shpmId,
      'shpmName': shpmName,
      'shpmDescription': shpmDescription,
      'shpmIsActive': shpmIsActive,
      'shpmCreatedDate': shpmCreatedDate,
      'shpmSupportCountries': shpmSupportCountries,
    };
  }
}
