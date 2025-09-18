class AccountItem {
  final String? code;
  final String? label;
  final int? value;

  AccountItem({this.code, this.label, this.value});

  factory AccountItem.fromJson(Map<String, dynamic> json) {
    return AccountItem(
      code: json['code'],
      label: json['label'],
      value: json['value'],
    );
  }
}

class AccountGroup {
  final String? label; // for tradeAccounts
  final String? subaccount; // for other types
  final List<AccountItem> items;

  AccountGroup({this.label, this.subaccount, required this.items});

  factory AccountGroup.fromJson(Map<String, dynamic> json, String type) {
    return AccountGroup(
      label: json['label'],
      subaccount: json['subaccount'],
      items: (json[type == 'tradeAccounts' ? 'items' : 'accounts'] as List)
          .map((e) => AccountItem.fromJson(e))
          .toList(),
    );
  }
}

class ProductAccountResponse {
  final List<AccountGroup> tradeAccounts;
  final List<AccountGroup> assetsAccounts;
  final List<AccountGroup> salesAccounts;
  final List<AccountGroup> expenseAccounts;

  ProductAccountResponse({
    required this.tradeAccounts,
    required this.assetsAccounts,
    required this.salesAccounts,
    required this.expenseAccounts,
  });

  factory ProductAccountResponse.fromJson(Map<String, dynamic> json) {
    final res = json['response'];

    List<AccountGroup> parseGroups(String key) =>
        (res[key] as List).map((e) => AccountGroup.fromJson(e, key)).toList();

    return ProductAccountResponse(
      tradeAccounts: parseGroups('tradeAccounts'),
      assetsAccounts: parseGroups('assetsAccounts'),
      salesAccounts: parseGroups('salesAccounts'),
      expenseAccounts: parseGroups('expenseAccounts'),
    );
  }
}
