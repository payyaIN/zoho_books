import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/view/add/add_product/notifier/add_item_notifier.dart';
import 'package:payzo_books/data/models/add_product/add_product_api_model.dart';

class AddProductRepository {
  final Ref ref;

  AddProductRepository(this.ref);

  // Map purchaseType -> itemCategory (as per required payload)
  String _mapItemCategory(int purchaseType) {
    switch (purchaseType) {
      case 1:
        return 'TRADE';
      case 2:
        return 'ASSET';
      case 3:
        return 'EXPENSE';
      default:
        return 'TRADE';
    }
  }

  Future<AddProductApiModel> addProduct() async {
    final state = ref.read(productFormProvider);

    // ✅ Basic validation (as you had)
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
      // --- EXACT KEYS / SHAPES AS REQUIRED ---
      "type": state.typeBool,                                   // bool
      "name": state.name,                                       // string
      "nameArabic": state.itemNameArabic,                       // string
      "unitId": state.unitId,                                   // int
      "code": state.code.isEmpty ? '' : state.code,             // string
      "taxPreference": {
        "taxId": state.taxPrefObj.taxId,                        // int
        "taxType": state.taxPrefObj.taxType,                    // string (e.g., "default")
      },
      "exemptionReason": state.exemptionReason,                 // string
      "salesFlag": state.salesFlag,                             // bool
      "purchaseFlag": state.purchaseFlag,                       // bool

      // 🔥 NEW: itemCategory (derived from purchaseType int)
      "itemCategory": _mapItemCategory(state.purchaseInformation.purchaseType),

      "purchaseInformation": {
        "purchaseType": state.purchaseInformation.purchaseType,     // int (1/2/3)
        "costCurrency": state.purchaseInformation.costCurrency,     // int
        "costPrice": state.purchaseInformation.costPrice,           // string
        "purchaseAccount": state.purchaseInformation.purchaseAccount, // int
        "description": state.purchaseInformation.description,       // string
        "descriptionArabic": state.purchaseInformation.descriptionArabic, // string
        "preferedVendor": state.purchaseInformation.preferedVendor, // int
        "categoryType": state.purchaseInformation.categoryType,     // null or id
      },
      "saleInformation": {
        "salesCurrency": state.saleInformation.salesCurrency,       // int
        "sellingPrice": state.saleInformation.sellingPrice,         // string
        "sellingAccount": state.saleInformation.sellingAccount,     // int
        "description": state.saleInformation.description,           // string
        "descriptionArabic": state.saleInformation.descriptionArabic, // string
      },

      // top-level categoryType (null in your example)
      "categoryType": state.categoryType,

      "invetoryDto": {
        "stockAccountId": state.inventoryDto.stockAccountId,        // int
        "openingStock": state.inventoryDto.openingStock,            // number
        "stockCurrency": state.inventoryDto.stockCurrency,          // int
        // 👇 required as STRING in payload
        "openingStockRate": state.inventoryDto.openingStockRate == null
            ? null
            : state.inventoryDto.openingStockRate!.toString(),
      },
      "inventoryFlag": state.inventoryFlag,                         // bool
    };

    debugPrint("📦 Final Product Payload: $body");

    const url = 'http://81.208.173.149/pb-item-service/v1/items';

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
