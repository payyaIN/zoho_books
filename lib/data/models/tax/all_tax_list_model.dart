import 'dart:convert';

class GetAllTaxListModel {
  final List<TaxItem> others;
  final List<dynamic> taxGroup;
  final List<dynamic> customTax;
  final List<DefaultTax> defaultTax;

  GetAllTaxListModel({
    required this.others,
    required this.taxGroup,
    required this.customTax,
    required this.defaultTax,
  });

  factory GetAllTaxListModel.fromJson(String str) =>
      GetAllTaxListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllTaxListModel.fromMap(Map<String, dynamic> json) {
    print('GetAllTaxListModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    List<dynamic> othersList = [];
    List<dynamic> taxGroupList = [];
    List<dynamic> customTaxList = [];
    List<dynamic> defaultTaxList = [];

    if (json.containsKey("Others")) {
      if (json["Others"] is List) {
        othersList = json["Others"] as List;
        print('Found ${othersList.length} Others items in response');
      } else {
        print('Warning: "Others" is not a List');
      }
    } else {
      print('Warning: No "Others" key found');
    }

    if (json.containsKey("TaxGroup")) {
      if (json["TaxGroup"] is List) {
        taxGroupList = json["TaxGroup"] as List;
        print('Found ${taxGroupList.length} TaxGroup items in response');
      } else {
        print('Warning: "TaxGroup" is not a List');
      }
    } else {
      print('Warning: No "TaxGroup" key found');
    }

    if (json.containsKey("CustomTax")) {
      if (json["CustomTax"] is List) {
        customTaxList = json["CustomTax"] as List;
        print('Found ${customTaxList.length} CustomTax items in response');
      } else {
        print('Warning: "CustomTax" is not a List');
      }
    } else {
      print('Warning: No "CustomTax" key found');
    }

    if (json.containsKey("DefaultTax")) {
      if (json["DefaultTax"] is List) {
        defaultTaxList = json["DefaultTax"] as List;
        print('Found ${defaultTaxList.length} DefaultTax items in response');
      } else {
        print('Warning: "DefaultTax" is not a List');
      }
    } else {
      print('Warning: No "DefaultTax" key found');
    }

    return GetAllTaxListModel(
      others: List<TaxItem>.from(othersList.map((x) {
        if (x is Map) {
          return TaxItem.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Others item is not a Map');
          return TaxItem.empty();
        }
      })),
      taxGroup: taxGroupList,
      customTax: customTaxList,
      defaultTax: List<DefaultTax>.from(defaultTaxList.map((x) {
        if (x is Map) {
          return DefaultTax.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: DefaultTax item is not a Map');
          return DefaultTax.empty();
        }
      })),
    );
  }

  Map<String, dynamic> toMap() => {
        "Others": List<dynamic>.from(others.map((x) => x.toMap())),
        "TaxGroup": List<dynamic>.from(taxGroup.map((x) => x)),
        "CustomTax": List<dynamic>.from(customTax.map((x) => x)),
        "DefaultTax": List<dynamic>.from(defaultTax.map((x) => x.toMap())),
      };

  factory GetAllTaxListModel.empty() => GetAllTaxListModel(
        others: [],
        taxGroup: [],
        customTax: [],
        defaultTax: [],
      );
}

class TaxItem {
  final int taxId;
  final String taxType;
  final String taxName;

  TaxItem({
    required this.taxId,
    required this.taxType,
    required this.taxName,
  });

  factory TaxItem.fromJson(String str) => TaxItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TaxItem.fromMap(Map<String, dynamic> json) {
    return TaxItem(
      taxId: json["taxId"] ?? 0,
      taxType: json["taxType"] ?? "",
      taxName: json["taxName"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "taxId": taxId,
        "taxType": taxType,
        "taxName": taxName,
      };

  factory TaxItem.empty() => TaxItem(
        taxId: 0,
        taxType: "",
        taxName: "",
      );
}

class DefaultTax {
  final int tcdAtive;
  final int tcdIsCustom;
  final double tcdTaxRate;
  final int tcdTaxId;
  final String tcdTaxName;
  final int tcdIsCountryDefault;
  final int taxId;
  final int tcdTaxType;
  final String taxName;
  final String taxType;
  final int tcdCompanyId;

  DefaultTax({
    required this.tcdAtive,
    required this.tcdIsCustom,
    required this.tcdTaxRate,
    required this.tcdTaxId,
    required this.tcdTaxName,
    required this.tcdIsCountryDefault,
    required this.taxId,
    required this.tcdTaxType,
    required this.taxName,
    required this.taxType,
    required this.tcdCompanyId,
  });

  factory DefaultTax.fromJson(String str) =>
      DefaultTax.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory DefaultTax.fromMap(Map<String, dynamic> json) {
    return DefaultTax(
      tcdAtive: json["tcdAtive"] ?? 0,
      tcdIsCustom: json["tcdIsCustom"] ?? 0,
      tcdTaxRate: _parseDouble(json["tcdTaxRate"]),
      tcdTaxId: json["tcdTaxId"] ?? 0,
      tcdTaxName: json["tcdTaxName"] ?? "",
      tcdIsCountryDefault: json["tcdIsCountryDefault"] ?? 0,
      taxId: json["taxId"] ?? 0,
      tcdTaxType: json["tcdTaxType"] ?? 0,
      taxName: json["taxName"] ?? "",
      taxType: json["taxType"] ?? "",
      tcdCompanyId: json["tcdCompanyId"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "tcdAtive": tcdAtive,
        "tcdIsCustom": tcdIsCustom,
        "tcdTaxRate": tcdTaxRate,
        "tcdTaxId": tcdTaxId,
        "tcdTaxName": tcdTaxName,
        "tcdIsCountryDefault": tcdIsCountryDefault,
        "taxId": taxId,
        "tcdTaxType": tcdTaxType,
        "taxName": taxName,
        "taxType": taxType,
        "tcdCompanyId": tcdCompanyId,
      };
  factory DefaultTax.empty() => DefaultTax(
        tcdAtive: 0,
        tcdIsCustom: 0,
        tcdTaxRate: 0.0,
        tcdTaxId: 0,
        tcdTaxName: "",
        tcdIsCountryDefault: 0,
        taxId: 0,
        tcdTaxType: 0,
        taxName: "",
        taxType: "",
        tcdCompanyId: 0,
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
