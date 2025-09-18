import 'dart:convert';

class GetAssociateTaxModel {
  final bool error;
  final String message;
  final AssociateTaxResponse response;
  final bool status;

  GetAssociateTaxModel({
    required this.error,
    required this.message,
    required this.response,
    required this.status,
  });

  factory GetAssociateTaxModel.fromJson(String str) =>
      GetAssociateTaxModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAssociateTaxModel.fromMap(Map<String, dynamic> json) {
    print('GetAssociateTaxModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    return GetAssociateTaxModel(
      error: json["error"] ?? false,
      message: json["message"] ?? "",
      response: json["response"] != null && json["response"] is Map
          ? AssociateTaxResponse.fromMap(
              Map<String, dynamic>.from(json["response"]))
          : AssociateTaxResponse.empty(),
      status: json["status"] ?? false,
    );
  }

  Map<String, dynamic> toMap() => {
        "error": error,
        "message": message,
        "response": response.toMap(),
        "status": status,
      };

  factory GetAssociateTaxModel.empty() => GetAssociateTaxModel(
        error: false,
        message: "",
        response: AssociateTaxResponse.empty(),
        status: false,
      );
}

class AssociateTaxResponse {
  final List<AssociateTax> taxes;

  AssociateTaxResponse({
    required this.taxes,
  });

  factory AssociateTaxResponse.fromJson(String str) =>
      AssociateTaxResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AssociateTaxResponse.fromMap(Map<String, dynamic> json) {
    print('AssociateTaxResponse.fromMap - Processing response data');

    List<dynamic> taxesList = [];

    if (json.containsKey("taxes")) {
      if (json["taxes"] is List) {
        taxesList = json["taxes"] as List;
        print('Found ${taxesList.length} taxes items in response');
      } else {
        print('Warning: "taxes" is not a List');
      }
    } else {
      print('Warning: No "taxes" key found');
    }

    return AssociateTaxResponse(
      taxes: List<AssociateTax>.from(taxesList.map((x) {
        if (x is Map) {
          return AssociateTax.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Tax item is not a Map');
          return AssociateTax.empty();
        }
      })),
    );
  }

  Map<String, dynamic> toMap() => {
        "taxes": List<dynamic>.from(taxes.map((x) => x.toMap())),
      };

  factory AssociateTaxResponse.empty() => AssociateTaxResponse(
        taxes: [],
      );
}

class AssociateTax {
  final int tcdTaxId;
  final String tcdTaxName;
  final int tcdTaxType;
  final double tcdTaxRate;
  final int tcdAtive;
  final int tcdCompanyId;
  final int tcdIsCustom;
  final int tcdIsCountryDefault;

  AssociateTax({
    required this.tcdTaxId,
    required this.tcdTaxName,
    required this.tcdTaxType,
    required this.tcdTaxRate,
    required this.tcdAtive,
    required this.tcdCompanyId,
    required this.tcdIsCustom,
    required this.tcdIsCountryDefault,
  });

  factory AssociateTax.fromJson(String str) =>
      AssociateTax.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AssociateTax.fromMap(Map<String, dynamic> json) {
    return AssociateTax(
      tcdTaxId: json["tcdTaxId"] ?? 0,
      tcdTaxName: json["tcdTaxName"] ?? "",
      tcdTaxType: json["tcdTaxType"] ?? 0,
      tcdTaxRate: _parseDouble(json["tcdTaxRate"]),
      tcdAtive: json["tcdAtive"] ?? 0,
      tcdCompanyId: json["tcdCompanyId"] ?? 0,
      tcdIsCustom: json["tcdIsCustom"] ?? 0,
      tcdIsCountryDefault: json["tcdIsCountryDefault"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "tcdTaxId": tcdTaxId,
        "tcdTaxName": tcdTaxName,
        "tcdTaxType": tcdTaxType,
        "tcdTaxRate": tcdTaxRate,
        "tcdAtive": tcdAtive,
        "tcdCompanyId": tcdCompanyId,
        "tcdIsCustom": tcdIsCustom,
        "tcdIsCountryDefault": tcdIsCountryDefault,
      };

  factory AssociateTax.empty() => AssociateTax(
        tcdTaxId: 0,
        tcdTaxName: "",
        tcdTaxType: 0,
        tcdTaxRate: 0.0,
        tcdAtive: 0,
        tcdCompanyId: 0,
        tcdIsCustom: 0,
        tcdIsCountryDefault: 0,
      );
}

double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (_) {
      return 0.0;
    }
  }
  return 0.0;
}
