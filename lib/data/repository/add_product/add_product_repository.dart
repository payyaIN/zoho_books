import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/view/add/add_product/notifier/add_item_notifier.dart';
import 'package:payzo_books/data/models/add_product/add_product_api_model.dart';

class AddProductRepository {
  final Ref ref;

  AddProductRepository(this.ref);

  Future<AddProductApiModel> addProduct() async {
    final state = ref.read(productFormProvider);

    // ✅ Basic validation
    if (state.name.trim().isEmpty) {
      throw Exception("Product name is required");
    }
    if (state.unitId == 0) {
      throw Exception("Unit is required");
    }
    if (state.taxPrefObj.taxId == 0 || state.taxPrefObj.taxType.isEmpty) {
      throw Exception("Tax preference is required");
    }

    final body = {
      "type": state.typeBool,
      "name": state.name,
      "nameArabic": state.itemNameArabic,
      "unitId": state.unitId,
      "code": state.code.isEmpty ? '' : state.code,
      "categoryType": state.categoryType,
      "exemptionReason": state.exemptionReason,
      "inventoryFlag": state.inventoryFlag,
      "invetoryDto": {
        "stockAccountId": state.inventoryDto.stockAccountId,
        "openingStock": state.inventoryDto.openingStock,
        "stockCurrency": state.inventoryDto.stockCurrency,
        "openingStockRate": state.inventoryDto.openingStockRate,
      },
      "purchaseFlag": state.purchaseFlag,
      "purchaseInformation": {
        "purchaseType": state.purchaseInformation.purchaseType,
        "costCurrency": state.purchaseInformation.costCurrency,
        "costPrice": state.purchaseInformation.costPrice,
        "purchaseAccount": state.purchaseInformation.purchaseAccount,
        "description": state.purchaseInformation.description,
        "descriptionArabic": state.purchaseInformation.descriptionArabic,
        "preferedVendor": state.purchaseInformation.preferedVendor,
        "categoryType": state.purchaseInformation.categoryType,
      },
      "salesFlag": state.salesFlag,
      "saleInformation": {
        "salesCurrency": state.saleInformation.salesCurrency,
        "sellingPrice": state.saleInformation.sellingPrice,
        "sellingAccount": state.saleInformation.sellingAccount,
        "description": state.saleInformation.description,
        "descriptionArabic": state.saleInformation.descriptionArabic,
      },
      "taxPreference": {
        "taxId": state.taxPrefObj.taxId,
        "taxType": state.taxPrefObj.taxType,
      },
    };

    debugPrint("📦 Final Product Payload: $body");

    const url = 'http://158.101.247.195/pb-item-service/v1/items';

    return await ref.read(apiServiceProvider).postApi<AddProductApiModel>(
      url: url,
      body: body,
      fromJson: (json) => AddProductApiModel.fromJson(json),
    );
  }
}

final addProductRepoProvider = Provider<AddProductRepository>((ref) {
  return AddProductRepository(ref);
});
