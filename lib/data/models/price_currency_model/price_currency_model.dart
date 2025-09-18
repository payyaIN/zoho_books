import 'dart:convert';

class PriceCurrencyModel {
  final List<CurrencyItem> currencies;

  PriceCurrencyModel({
    required this.currencies,
  });

  factory PriceCurrencyModel.fromJson(String str) =>
      PriceCurrencyModel.fromList(json.decode(str));

  String toJson() => json.encode(toList());

  factory PriceCurrencyModel.fromList(List<dynamic> list) {
    print(
        'PriceCurrencyModel.fromList - Processing response with ${list.length} currencies');

    return PriceCurrencyModel(
      currencies: List<CurrencyItem>.from(list.map((x) {
        if (x is Map) {
          return CurrencyItem.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Currency item is not a Map');
          return CurrencyItem.empty();
        }
      })),
    );
  }

  List<dynamic> toList() =>
      List<dynamic>.from(currencies.map((x) => x.toMap()));

  factory PriceCurrencyModel.empty() => PriceCurrencyModel(
        currencies: [],
      );
}

class CurrencyItem {
  final String currencyValue;
  final int currencyId;
  final int countryId;

  CurrencyItem({
    required this.currencyValue,
    required this.currencyId,
    required this.countryId,
  });

  factory CurrencyItem.fromJson(String str) =>
      CurrencyItem.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CurrencyItem.fromMap(Map<String, dynamic> json) {
    return CurrencyItem(
      currencyValue: json["currencyValue"] ?? "",
      currencyId: json["currencyId"] ?? 0,
      countryId: json["countryId"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "currencyValue": currencyValue,
        "currencyId": currencyId,
        "countryId": countryId,
      };

  factory CurrencyItem.empty() => CurrencyItem(
        currencyValue: "",
        currencyId: 0,
        countryId: 0,
      );
}
