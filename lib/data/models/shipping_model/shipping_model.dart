import 'dart:convert';

class ShippingMethodModel {
  final List<ShippingMethod> methods;

  ShippingMethodModel({
    required this.methods,
  });

  factory ShippingMethodModel.fromJson(String str) =>
      ShippingMethodModel.fromList(json.decode(str));

  String toJson() => json.encode(toList());

  factory ShippingMethodModel.fromList(List<dynamic> list) {
    print(
        'ShippingMethodModel.fromList - Processing response with ${list.length} shipping methods');

    return ShippingMethodModel(
      methods: List<ShippingMethod>.from(list.map((x) {
        if (x is Map) {
          return ShippingMethod.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Shipping method item is not a Map');
          return ShippingMethod.empty();
        }
      })),
    );
  }

  List<dynamic> toList() => List<dynamic>.from(methods.map((x) => x.toMap()));

  factory ShippingMethodModel.empty() => ShippingMethodModel(
        methods: [],
      );
}

class ShippingMethod {
  final int shpmId;
  final String shpmName;
  final String shpmDescription;
  final String shpmIsActive;
  final DateTime shpmCreatedDate;
  final dynamic shpmSupportCountries;

  ShippingMethod({
    required this.shpmId,
    required this.shpmName,
    required this.shpmDescription,
    required this.shpmIsActive,
    required this.shpmCreatedDate,
    this.shpmSupportCountries,
  });

  factory ShippingMethod.fromJson(String str) =>
      ShippingMethod.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ShippingMethod.fromMap(Map<String, dynamic> json) {
    return ShippingMethod(
      shpmId: json["shpmId"] ?? 0,
      shpmName: json["shpmName"] ?? "",
      shpmDescription: json["shpmDescription"] ?? "",
      shpmIsActive: json["shpmIsActive"] ?? "",
      shpmCreatedDate: json["shpmCreatedDate"] != null
          ? DateTime.parse(json["shpmCreatedDate"])
          : DateTime.now(),
      shpmSupportCountries: json["shpmSupportCountries"],
    );
  }

  Map<String, dynamic> toMap() => {
        "shpmId": shpmId,
        "shpmName": shpmName,
        "shpmDescription": shpmDescription,
        "shpmIsActive": shpmIsActive,
        "shpmCreatedDate": shpmCreatedDate.toIso8601String(),
        "shpmSupportCountries": shpmSupportCountries,
      };

  factory ShippingMethod.empty() => ShippingMethod(
        shpmId: 0,
        shpmName: "",
        shpmDescription: "",
        shpmIsActive: "",
        shpmCreatedDate: DateTime.now(),
        shpmSupportCountries: null,
      );
}
