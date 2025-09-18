class AddProductModel {
  final String itemName;
  final String itemNameArabic;
  final String unit;
  final String type;
  final String hsnCode;
  final bool taxable;
  final bool hasSalesInfo;
  final String sellingPrice;
  final String salesAccount;
  final String salesDescription;
  final String salesDescriptionArabic;
  final bool hasPurchaseInfo;
  final String purchaseType;
  final String costPrice;
  final String preferredVendor;
  final String purchaseAccount;
  final String purchaseDescription;
  final String purchaseDescriptionArabic;
  final String account;
  final String taxPreference;
  final bool typeBool;
  final String name;
  final int unitId;
  final String code;
  final TaxPreference taxPrefObj;
  final String exemptionReason;
  final bool salesFlag;
  final bool purchaseFlag;
  final PurchaseInformation purchaseInformation;
  final SaleInformation saleInformation;
  final dynamic categoryType;
  final InventoryDto inventoryDto;
  final bool inventoryFlag;
  final Map<String, String>? errors;

  const AddProductModel({
    this.itemName = '',
    this.itemNameArabic = '',
    this.unit = '',
    this.type = 'goods',
    this.hsnCode = '',
    this.taxable = false,
    this.hasSalesInfo = true,
    this.sellingPrice = '0.00',
    this.salesAccount = 'Sales',
    this.salesDescription = '',
    this.salesDescriptionArabic = '',
    this.hasPurchaseInfo = true,
    this.purchaseType = 'Trade',
    this.costPrice = '0.00',
    this.preferredVendor = 'Malabar',
    this.purchaseAccount = 'Cost Of Goods Sold',
    this.purchaseDescription = '',
    this.purchaseDescriptionArabic = '',
    this.account = '',
    this.taxPreference = '',
    this.typeBool = false,
    this.name = '',
    this.unitId = 0,
    this.code = '',
    this.taxPrefObj = const TaxPreference(taxId: 0, taxType: ''),
    this.exemptionReason = '',
    this.salesFlag = true,
    this.purchaseFlag = true,
    this.purchaseInformation = const PurchaseInformation(),
    this.saleInformation = const SaleInformation(),
    this.categoryType,
    this.inventoryDto = const InventoryDto(),
    this.inventoryFlag = false,
    this.errors,
  });

  AddProductModel copyWith({
    String? itemName,
    String? itemNameArabic,
    String? unit,
    String? type,
    String? hsnCode,
    bool? taxable,
    bool? hasSalesInfo,
    String? sellingPrice,
    String? salesAccount,
    String? salesDescription,
    String? salesDescriptionArabic,
    bool? hasPurchaseInfo,
    String? purchaseType,
    String? costPrice,
    String? preferredVendor,
    String? purchaseAccount,
    String? purchaseDescription,
    String? purchaseDescriptionArabic,
    String? account,
    String? taxPreference,
    bool? typeBool,
    String? name,
    int? unitId,
    String? code,
    TaxPreference? taxPrefObj,
    String? exemptionReason,
    bool? salesFlag,
    bool? purchaseFlag,
    PurchaseInformation? purchaseInformation,
    SaleInformation? saleInformation,
    dynamic categoryType,
    InventoryDto? inventoryDto,
    bool? inventoryFlag,
    Map<String, String>? errors,
  }) {
    return AddProductModel(
      itemName: itemName ?? this.itemName,
      itemNameArabic: itemNameArabic ?? this.itemNameArabic,
      unit: unit ?? this.unit,
      type: type ?? this.type,
      hsnCode: hsnCode ?? this.hsnCode,
      taxable: taxable ?? this.taxable,
      hasSalesInfo: hasSalesInfo ?? this.hasSalesInfo,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      salesAccount: salesAccount ?? this.salesAccount,
      salesDescription: salesDescription ?? this.salesDescription,
      salesDescriptionArabic: salesDescriptionArabic ?? this.salesDescriptionArabic,
      hasPurchaseInfo: hasPurchaseInfo ?? this.hasPurchaseInfo,
      purchaseType: purchaseType ?? this.purchaseType,
      costPrice: costPrice ?? this.costPrice,
      preferredVendor: preferredVendor ?? this.preferredVendor,
      purchaseAccount: purchaseAccount ?? this.purchaseAccount,
      purchaseDescription: purchaseDescription ?? this.purchaseDescription,
      purchaseDescriptionArabic: purchaseDescriptionArabic ?? this.purchaseDescriptionArabic,
      account: account ?? this.account,
      taxPreference: taxPreference ?? this.taxPreference,
      typeBool: typeBool ?? this.typeBool,
      name: name ?? this.name,
      unitId: unitId ?? this.unitId,
      code: code ?? this.code,
      taxPrefObj: taxPrefObj ?? this.taxPrefObj,
      exemptionReason: exemptionReason ?? this.exemptionReason,
      salesFlag: salesFlag ?? this.salesFlag,
      purchaseFlag: purchaseFlag ?? this.purchaseFlag,
      purchaseInformation: purchaseInformation ?? this.purchaseInformation,
      saleInformation: saleInformation ?? this.saleInformation,
      categoryType: categoryType ?? this.categoryType,
      inventoryDto: inventoryDto ?? this.inventoryDto,
      inventoryFlag: inventoryFlag ?? this.inventoryFlag,
      errors: errors ?? this.errors,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': typeBool,
    'name': name,
    'itemNameArabic': itemNameArabic,
    'unitId': unitId,
    'code': code,
    'taxPreference': taxPrefObj.toJson(),
    'exemptionReason': exemptionReason,
    'salesFlag': salesFlag,
    'purchaseFlag': purchaseFlag,
    'purchaseInformation': purchaseInformation.toJson(),
    'saleInformation': saleInformation.toJson(),
    'categoryType': categoryType,
    'invetoryDto': inventoryDto.toJson(),
    'inventoryFlag': inventoryFlag,
  };
}

class TaxPreference {
  final int taxId;
  final String taxType;
  const TaxPreference({required this.taxId, required this.taxType});

  Map<String, dynamic> toJson() => {
    'taxId': taxId,
    'taxType': taxType,
  };
}

class PurchaseInformation {
  final int purchaseType;
  final int costCurrency;
  final String costPrice;
  final int purchaseAccount;
  final String description;
  final String descriptionArabic;
  final int preferedVendor;
  final dynamic categoryType;

  const PurchaseInformation({
    this.purchaseType = 0,
    this.costCurrency = 0,
    this.costPrice = '',
    this.purchaseAccount = 0,
    this.description = '',
    this.descriptionArabic = '',
    this.preferedVendor = 0,
    this.categoryType,
  });

  PurchaseInformation copyWith({
    int? purchaseType,
    int? costCurrency,
    String? costPrice,
    int? purchaseAccount,
    String? description,
    String? descriptionArabic,
    int? preferedVendor,
    dynamic categoryType,
  }) {
    return PurchaseInformation(
      purchaseType: purchaseType ?? this.purchaseType,
      costCurrency: costCurrency ?? this.costCurrency,
      costPrice: costPrice ?? this.costPrice,
      purchaseAccount: purchaseAccount ?? this.purchaseAccount,
      description: description ?? this.description,
      descriptionArabic: descriptionArabic ?? this.descriptionArabic,
      preferedVendor: preferedVendor ?? this.preferedVendor,
      categoryType: categoryType ?? this.categoryType,
    );
  }

  Map<String, dynamic> toJson() => {
    'purchaseType': purchaseType,
    'costCurrency': costCurrency,
    'costPrice': costPrice,
    'purchaseAccount': purchaseAccount,
    'description': description,
    'descriptionArabic': descriptionArabic,
    'preferedVendor': preferedVendor,
    'categoryType': categoryType,
  };
}

class SaleInformation {
  final int salesCurrency;
  final String sellingPrice;
  final int sellingAccount;
  final String description;
  final String descriptionArabic;

  const SaleInformation({
    this.salesCurrency = 0,
    this.sellingPrice = '',
    this.sellingAccount = 0,
    this.description = '',
    this.descriptionArabic = '',
  });

  SaleInformation copyWith({
    int? salesCurrency,
    String? sellingPrice,
    int? sellingAccount,
    String? description,
    String? descriptionArabic,
  }) {
    return SaleInformation(
      salesCurrency: salesCurrency ?? this.salesCurrency,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      sellingAccount: sellingAccount ?? this.sellingAccount,
      description: description ?? this.description,
      descriptionArabic: descriptionArabic ?? this.descriptionArabic,
    );
  }

  Map<String, dynamic> toJson() => {
    'salesCurrency': salesCurrency,
    'sellingPrice': sellingPrice,
    'sellingAccount': sellingAccount,
    'description': description,
    'descriptionArabic': descriptionArabic,
  };
}

class InventoryDto {
  final int stockAccountId;
  final String stockAccountName;
  final double openingStock;
  final int stockCurrency;
  final String stockCurrencyName;
  final double? openingStockRate;

  const InventoryDto({
    this.stockAccountId = 0,
    this.stockAccountName = '',
    this.openingStock = 0.0,
    this.stockCurrency = 0,
    this.stockCurrencyName = '',
    this.openingStockRate,
  });

  InventoryDto copyWith({
    int? stockAccountId,
    String? stockAccountName,
    double? openingStock,
    int? stockCurrency,
    String? stockCurrencyName,
    double? openingStockRate,
  }) {
    return InventoryDto(
      stockAccountId: stockAccountId ?? this.stockAccountId,
      stockAccountName: stockAccountName ?? this.stockAccountName,
      openingStock: openingStock ?? this.openingStock,
      stockCurrency: stockCurrency ?? this.stockCurrency,
      stockCurrencyName: stockCurrencyName ?? this.stockCurrencyName,
      openingStockRate: openingStockRate ?? this.openingStockRate,
    );
  }

  Map<String, dynamic> toJson() => {
    'stockAccountId': stockAccountId,
    'stockAccountName': stockAccountName,
    'openingStock': openingStock,
    'stockCurrency': stockCurrency,
    'stockCurrencyName': stockCurrencyName,
    'openingStockRate': openingStockRate,
  };
}
