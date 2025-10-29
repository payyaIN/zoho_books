import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/view/add/add_product/model/add_item_model.dart';

import '../../../../import_data.dart';

class ProductFormNotifier extends StateNotifier<AddProductModel> {
  ProductFormNotifier()
      : super(
          AddProductModel(
            itemName: 'werwerw',
            itemNameArabic: 'werwerw',
            unit: '',
            type: 'goods',
            hsnCode: '',
            taxable: false,
            hasSalesInfo: true,
            sellingPrice: '0.00',
            salesAccount: 'Sales',
            salesDescription: '',
            hasPurchaseInfo: true,
            purchaseType: 'Trade',
            costPrice: '0.00',
            preferredVendor: 'Tap to Select',
            purchaseAccount: 'Tap to Select',
            purchaseDescription: '',
            account: '',
            taxPreference: '',
            typeBool: true,
            name: '',
            unitId: 0,
            code: '',
            exemptionReason: '',
            salesFlag: true,
            purchaseFlag: true,
            purchaseInformation: const PurchaseInformation(
              purchaseType: 0,
              costCurrency: 0,
              costPrice: '',
              purchaseAccount: 0,
              description: '',
              descriptionArabic: '',
              preferedVendor: 0,
              categoryType: null,
            ),
            saleInformation: const SaleInformation(
              salesCurrency: 0,
              sellingPrice: '',
              sellingAccount: 0,
              description: '',
              descriptionArabic: '',
            ),
            categoryType: null,
            inventoryDto: const InventoryDto(
              stockAccountId: 0,
              openingStock: 0,
              stockCurrency: 0,
              openingStockRate: null,
            ),
            inventoryFlag: false,
          ),
        );

  void updateField(String key, dynamic value) {
    switch (key) {
      case 'itemName':
        state = state.copyWith(itemName: value);
        break;
      case 'itemNameArabic':
        state = state.copyWith(itemName: value);
        break;
      case 'hsnCode':
        state = state.copyWith(hsnCode: value);
        break;
      case 'unit':
        state = state.copyWith(unit: value);
        break;
      case 'sellingPrice':
        state = state.copyWith(sellingPrice: value);
        break;
      case 'salesDescription':
        state = state.copyWith(salesDescription: value);
        break;
      case 'salesDescriptionArabic':
        state = state.copyWith(salesDescriptionArabic: value);
        break;
      case 'costPrice':
        state = state.copyWith(costPrice: value);
        break;
      case 'purchaseDescription':
        state = state.copyWith(purchaseDescription: value);
        break;
      case 'purchaseDescriptionArabic':
        state = state.copyWith(purchaseDescriptionArabic: value);
        break;
      case 'account':
        state = state.copyWith(account: value);
        break;
      case 'preferredVendor':
        state = state.copyWith(preferredVendor: value);
        break;
      case 'purchaseAccount':
        state = state.copyWith(purchaseAccount: value);
        break;
      case 'taxPreference':
        state = state.copyWith(taxPreference: value);
        break;
      case 'typeBool':
        state = state.copyWith(typeBool: value);
        break;
      case 'name':
        state = state.copyWith(name: value);
        break;
      case 'unitId':
        state = state.copyWith(unitId: value);
        break;
      case 'code':
        state = state.copyWith(code: value);
        break;
      case 'exemptionReason':
        state = state.copyWith(exemptionReason: value);
        break;
      case 'salesFlag':
        state = state.copyWith(salesFlag: value);
        break;
      case 'purchaseFlag':
        state = state.copyWith(purchaseFlag: value);
        break;
      case 'purchaseInformation':
        state = state.copyWith(purchaseInformation: value);
        break;
      case 'saleInformation':
        state = state.copyWith(saleInformation: value);
        break;
      case 'categoryType':
        state = state.copyWith(categoryType: value);
        break;
      case 'inventoryDto':
        state = state.copyWith(inventoryDto: value);
        break;
      case 'inventoryFlag':
        state = state.copyWith(inventoryFlag: value);
        break;
    }
  }

  void updateInventoryDto({
    int? stockAccountId,
    String? stockAccountName,
    double? openingStock,
    int? stockCurrency,
    String? stockCurrencyName, // <-- New
    double? openingStockRate,
  }) {
    state = state.copyWith(
      inventoryDto: state.inventoryDto.copyWith(
        stockAccountId: stockAccountId,
        stockAccountName: stockAccountName,
        openingStock: openingStock,
        stockCurrency: stockCurrency,
        stockCurrencyName: stockCurrencyName,
        // <-- New
        openingStockRate: openingStockRate,
      ),
    );
  }

  void updateSaleInfo({
    int? salesCurrency,
    String? sellingPrice,
    int? sellingAccount,
    String? description,
    String? descriptionArabic,
  }) {
    state = state.copyWith(
      saleInformation: state.saleInformation.copyWith(
        salesCurrency: salesCurrency,
        sellingPrice: sellingPrice,
        sellingAccount: sellingAccount,
        description: description,
        descriptionArabic: descriptionArabic,
      ),
    );
  }

  void updatePurchaseInfo({
    int? purchaseType,
    int? costCurrency,
    String? costPrice,
    int? purchaseAccount,
    String? description,
    String? descriptionArabic,
    int? preferedVendor,
    dynamic categoryType,
  }) {
    state = state.copyWith(
      purchaseInformation: state.purchaseInformation.copyWith(
        purchaseType: purchaseType,
        costCurrency: costCurrency,
        costPrice: costPrice,
        purchaseAccount: purchaseAccount,
        description: description,
        descriptionArabic: descriptionArabic,
        preferedVendor: preferedVendor,
        categoryType: categoryType,
      ),
    );
  }

  void updateToggle({required String section, required bool value}) {
    if (section == 'taxable') {
      state = state.copyWith(taxable: value);
    } else if (section == 'salesInfo') {
      state = state.copyWith(hasSalesInfo: value);
    } else if (section == 'purchaseInfo') {
      state = state.copyWith(hasPurchaseInfo: value);
    }
  }

  void updateRadio(String key, String value) {
    if (key == 'type') {
      state = state.copyWith(type: value);
    } else if (key == 'purchaseType') {
      state = state.copyWith(purchaseType: value);
    }
  }

  void clearForm() {
    state = AddProductModel(
      itemName: '34534534',
      itemNameArabic: '',
      unit: 'Tap to Select',
      type: 'goods',
      hsnCode: '',
      taxable: false,
      hasSalesInfo: true,
      sellingPrice: '0.00',
      salesAccount: 'Sales',
      salesDescription: '',
      hasPurchaseInfo: true,
      purchaseType: 'Trade',
      costPrice: '0.00',
      preferredVendor: 'Tap to Select',
      purchaseAccount: 'Tap to Select',
      purchaseDescription: '',
      account: '',
      taxPreference: '',
      typeBool: true,
      name: '',
      unitId: 0,
      code: '',
      exemptionReason: '',
      salesFlag: true,
      purchaseFlag: true,
      purchaseInformation: const PurchaseInformation(
        purchaseType: 0,
        costCurrency: 0,
        costPrice: '',
        purchaseAccount: 0,
        description: '',
        descriptionArabic: '',
        preferedVendor: 0,
        categoryType: null,
      ),
      saleInformation: const SaleInformation(
        salesCurrency: 0,
        sellingPrice: '',
        sellingAccount: 0,
        description: '',
        descriptionArabic: '',
      ),
      categoryType: null,
      inventoryDto: const InventoryDto(
        stockAccountId: 0,
        openingStock: 0,
        stockCurrency: 0,
        openingStockRate: null,
      ),
      inventoryFlag: false,
    );
  }

  void updateTaxPreferences({
    required int taxId,
    required String taxType,
  }) {
    state = state.copyWith(
      taxPrefObj: TaxPreference(taxId: taxId, taxType: taxType),
    );
  }

  void validateFields() {
    final errors = <String, String>{};

    // 🟡 Basic Product Info
    if (state.name.trim().isEmpty) {
      errors['itemName'] = 'Item name is required';
    } // 🟡 Basic Product Info
    if (state.itemNameArabic.trim().isEmpty) {
      errors['itemNameArabic'] = 'Item name arabic is required';
    }
    if (state.unitId == 0) {
      errors['unitId'] = 'Unit is required';
    }
    if (state.code.isNotEmpty && state.code.length < 6) {
      errors['code'] = 'HS Code must be at least 6 digits';
    }
    if (state.taxPreference == 'Non-Taxable' && state.exemptionReason == '') {
      errors['exemptionReason'] = 'Exemption Reason is required';
    }
    // if (state.code
    //     .trim()
    //     .isEmpty) {
    //   errors['code'] = 'Item code is required';
    // }

    // 🟡 Tax Preference
    if (state.taxPrefObj.taxId == 0 || state.taxPrefObj.taxType.isEmpty) {
      errors['taxPreference'] = 'Tax preference is required';
    }

    // 🟡 Sales Info
    if (state.salesFlag) {
      if (state.saleInformation.sellingPrice.trim().isEmpty) {
        errors['sellingPrice'] = 'Selling price is required';
      }
      if (state.saleInformation.sellingAccount == 0) {
        errors['sellingAccount'] = 'Sales account is required';
      }
      // if (state.saleInformation.salesCurrency == 0) {
      //   errors['salesCurrency'] = 'Sales currency is required';
      // }
    }

    // 🟡 Purchase Info
    if (state.purchaseFlag) {
      final purchaseInfo = state.purchaseInformation;

      // if (purchaseInfo.purchaseType == 0) {
      //   errors['purchaseType'] = 'Purchase type is required';
      // }
      if (purchaseInfo.categoryType == null && purchaseInfo.purchaseType == 2) {
        errors['categoryType'] = 'Category type is required';
      }
      if (purchaseInfo.costPrice.trim().isEmpty) {
        errors['costPrice'] = 'Cost price is required';
      }
      // if (purchaseInfo.costCurrency == 0) {
      //   errors['costCurrency'] = 'Cost currency is required';
      // }
      if (purchaseInfo.purchaseAccount == 0) {
        errors['purchaseAccount'] = 'Purchase account is required';
      }
      // if (purchaseInfo.preferedVendor == 0) {
      //   errors['preferredVendor'] = 'Preferred vendor is required';
      // }

      // 🟡 Asset category type (if purchaseType == 2)
      if (purchaseInfo.purchaseType == 2 && purchaseInfo.categoryType == null) {
        errors['categoryType'] = 'Category type is required';
      }
    }

    // 🟡 Inventory Info
    if (state.inventoryFlag) {
      final inventory = state.inventoryDto;

      if (inventory.stockAccountId == 0) {
        errors['stockAccount'] = 'Inventory account is required';
      }
      // if (inventory.stockCurrency == 0) {
      //   errors['stockCurrency'] = 'Opening stock is required';
      // }
      if (inventory.openingStockRate == null ||
          inventory.openingStockRate == 0) {
        errors['openingStockRate'] = 'Opening stock rate is required';
      }
    }

    state = state.copyWith(errors: errors);
  }
}

final productFormProvider =
    StateNotifierProvider<ProductFormNotifier, AddProductModel>((ref) {
  return ProductFormNotifier();
});
