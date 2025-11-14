// lib/view/add/add_billls/notifier/add_bill_form_notifier.dart

import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:payzo_books/view/add/add_billls/model/add_bill_form_model.dart';
import 'package:payzo_books/view/add/add_billls/model/item_details_model.dart';

import '../../../../data/models/add_bills/get_branch_list_model.dart';
import '../../../../data/models/add_bills/get_venor_list_model.dart';
import '../../../../data/repository/add_bills/add_bills_repository.dart';
import '../../../../data/repository/add_bills/get_all_bills_repository.dart';
import '../../../../data/repository/add_bills/get_price_currency_repository.dart';
import '../../../../data/repository/add_invoice/get_tax_list_repo.dart';
import '../../../../import_data.dart';
import '../../../../utils/common_widgets/reusable_bottom_sheet.dart';

// add missing imports for repository & mapper & generate response
// import 'package:payzo_books/data/mapper/bill_mapper.dart'; //This is now inside generate_bill_providers.dart
import 'package:payzo_books/data/models/add_bills/generate_bill_response.dart'; // used by submitBill
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart'; // used by submitBill
import 'package:payzo_books/data/repository/add_bills/get_item_repository.dart'; // used by submitBill
import 'package:payzo_books/data/repository/add_bills/shipping_method_repository.dart'; // used by submitBill
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart'; // used by submitBill

// These are now provided by generate_bill_providers.dart
// import 'package:payzo_books/data/repository/add_bills/generate_bill_repository.dart';
// import 'package:payzo_books/data/providers/add_bill_providers.dart'; // Old provider file


class AddBillFormNotifier extends StateNotifier<AddBillFormModel> {
  AddBillFormNotifier() : super(const AddBillFormModel());

  // ------------------------------
  // Field updaters
  // ------------------------------
  void updateField(String key, dynamic value) {
    switch (key) {
      case 'vendor':
        state = state.copyWith(vendor: value as String?);
        break;
      case 'vendorId':
        state = state.copyWith(vendorId: value as int?);
        break;
      case 'branch':
        state = state.copyWith(branch: value as String?);
        break;
      case 'billRefNo':
        state = state.copyWith(billRefNo: value as String?);
        break;
      case 'orderNo':
        state = state.copyWith(orderNo: value as String?);
        break;
      case 'billDate':
        state = state.copyWith(billDate: value as DateTime?);
        break;
      case 'dueDate':
        state = state.copyWith(dueDate: value as DateTime?);
        break;
      case 'shippingMethod':
        state = state.copyWith(shippingMethod: value as String?);
        break;
      case 'currency':
        state = state.copyWith(currency: value as String?);
        break;
      case 'paymentTerms':
        state = state.copyWith(paymentTerms: value as String?);
        break;
      case 'customerNotes':
        state = state.copyWith(customerNotes: value as String?);
        break;
      case 'terms':
        state = state.copyWith(terms: value as String?);
        break;

    // ✅ Accept nullable File for 'attachment' so `updateField('attachment', null)` clears it
      case 'attachment':
        final file = value as File?;
        state = state.copyWith(attachment: file);
        break;

      case 'customerId':
        state = state.copyWith(customerId: value as int?);
        break;
      case 'orgId':
        state = state.copyWith(orgId: value as int?);
        break;
      case 'cmpCr':
        state = state.copyWith(cmpCr: value as int?);
        break;

    // additional optional fields
      case 'paidThroughAccount':
        state = state.copyWith(paidThroughAccount: value as int?);
        break;
      case 'discountType':
        state = state.copyWith(discountType: value as String?);
        break;
      case 'discountAmount':
        state = state.copyWith(discountAmount: value as double?);
        break;
      case 'discountPercentage':
        state = state.copyWith(discountPercentage: value as double?);
        break;
      case 'billType':
        state = state.copyWith(billType: value as int?);
        break;
      case 'billAdvance':
        state = state.copyWith(billAdvance: value as bool?);
        break;
      case 'billDelivery':
        state = state.copyWith(billDelivery: value as bool?);
        break;
      case 'isIncoming':
        state = state.copyWith(isIncoming: value as int?);
        break;
      case 'billStatus':
        state = state.copyWith(billStatus: value as int?);
        break;
      case 'billInfo':
        state = state.copyWith(billInfo: value as String?);
        break;
      case 'discountMethod':
        state = state.copyWith(discountMethod: value as String?);
        break;
      case 'taxMethod':
        state = state.copyWith(taxMethod: value as String?);
        break;
      case 'isTaxInclusive':
        state = state.copyWith(isTaxInclusive: value as bool?);
        break;

      default:
      // Optionally handle or log unknown keys
        debugPrint('Unknown updateField key: $key');
    }
  }

  // ------------------------------
  // Item-level updaters
  // ------------------------------
  void updateItemField(int index, String key, dynamic value) {
    final updatedList = [...state.itemDetails];
    if (index < 0 || index >= updatedList.length) return;
    final current = updatedList[index];

    final updated = switch (key) {
      'itemName' => current.copyWith(itemName: value as String?),
      'account' => current.copyWith(account: value as String?),
      'quantity' => current.copyWith(quantity: value as int?),
      'unitType' => current.copyWith(unitType: value as String?),
      'rateDate' => current.copyWith(rateDate: value as String?),
      'taxType' => current.copyWith(taxType: value as String?),
      'customerDate' => current.copyWith(customerDate: value as String?),
      'amount' => current.copyWith(amount: value as double?),
      'discountAmount' => current.copyWith(discountAmount: value),
      'discountPercentage' => current.copyWith(discountPercentage: value as double?),
      'exemptionReason' => current.copyWith(exemptionReason: value as String?),
      'taxDescription' => current.copyWith(taxDescription: value as String?),
      'othersDescription' => current.copyWith(othersDescription: value as String?),
      'othersAmount' => current.copyWith(othersAmount: value as double?),
      'discountIsCurrency' => current.copyWith(discountIsCurrency: value as bool?),
      'unitId' => current.copyWith(unitId: value as int?),
      'customerId' => current.copyWith(customerId: value as int?),
      'taxAmount' => current.copyWith(taxAmount: value as double?),
      'prodId' => current.copyWith(prodId: value as int?),
      'prodCatId' => current.copyWith(prodCatId: value as int?),
      'description' => current.copyWith(description: value as String?),
      _ => current,
    };

    updatedList[index] = updated;
    state = state.copyWith(itemDetails: updatedList);
    _recalculateTotal();
  }

  void addNewItem() {
    final updatedList = [...state.itemDetails, const ItemDetail(discountIsCurrency: false)]; // default %
    state = state.copyWith(itemDetails: updatedList);
    _recalculateTotal();
  }

  void removeItem(int index) {
    if (index < 0 || index >= state.itemDetails.length) return;
    final updatedList = [...state.itemDetails]..removeAt(index);
    state = state.copyWith(itemDetails: updatedList);
    _recalculateTotal();
  }

  void _recalculateTotal() {
    // item.amount already includes quantity if you set it that way;
    // We'll sum amounts defensively.
    final subTotal = state.itemDetails.fold<double>(
      0.0,
          (sum, item) {
        final amt = item.amount ?? 0.0;
        return sum + amt;
      },
    );
    final tax = 0.0; // compute tax when tax rules are available
    final total = subTotal + tax;
    state = state.copyWith(subTotal: subTotal, tax: tax, total: total);
  }

  // ------------------------------
  // Submit bill (new behavior)
  // ------------------------------
  /// Submits the bill using the repository.
  /// - Validates the form first.
  /// - Loads all required lookup lists via the provided [ref].
  /// - Builds the DTO with [buildBillDtoFromForm].
  /// - Calls repository.submitBill and updates [billNameIdProvider] on success.
  Future<BillResponse> submitBill(WidgetRef ref) async {
    // Validate locally
    validateForm();
    if (state.errors.isNotEmpty) {
      debugPrint('🚫 Validation failed: ${state.errors}');
      throw Exception('Validation failed. Please check form fields.');
    }

    // Prepare file (from form state)
    final File? attachment = state.attachment;

    // The generateBillProvider now handles all logic internally.
    // We just need to read it with the attachment as a family parameter.
    try {
      // By reading the future, we trigger the provider to execute.
      final resp = await ref.read(generateBillProvider(attachment).future);

      // On success, write returned billId (if any) into billNameIdProvider
      final firstDetail =
          resp.details != null && resp.details!.isNotEmpty ? resp.details!.first : null;
      if (firstDetail != null) {
        ref.read(billNameIdProvider.notifier).state = firstDetail.billId ?? 0;
        debugPrint('✅ Bill generated with id: ${firstDetail.billId} invoice: ${firstDetail.billInvoiceNumber}');
      } else {
        debugPrint('⚠️ Bill generated but response.details empty');
      }

      return resp;
    } catch (e, st) {
      debugPrint('❌ submitBill error: $e\n$st');
      rethrow;
    }
  }

  // ------------------------------
  // UI helpers: currency selectors / item currency selector
  // ------------------------------
  Future<void> showAddBillCurrencySelector(BuildContext context, WidgetRef ref) async {
    await ref.read(focusUtilsProvider).unfocusAndDelay();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final currencyAsync = ref.watch(fetchPriceCurrencyProvider);

            return currencyAsync.when(
              data: (currencyList) {
                final currencyNames = currencyList
                    .map((e) => e.currencyValue ?? '')
                    .where((e) => e.isNotEmpty)
                    .toList();

                return ReusableCountryBottomSheet(
                  title: 'Select Currency',
                  items: currencyNames,
                  onSelect: (selectedCurrency) {
                    final selected = currencyList.firstWhere(
                          (c) => c.currencyValue == selectedCurrency,
                      orElse: () => currencyList.first,
                    );
                    ref.read(addBillFormProvider.notifier).updateField('currency', selected.currencyValue ?? 'SAR');
                    debugPrint("💱 Selected AddBill Currency: ${selected.currencyValue} (id: ${selected.currencyId})");
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Failed to load currencies: $err')),
            );
          },
        );
      },
    );
  }

  Future<void> showAddBillItemCurrencySelector(BuildContext context, WidgetRef ref) async {
    await ref.read(focusUtilsProvider).unfocusAndDelay();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final currencyAsync = ref.watch(fetchPriceCurrencyProvider);

            return currencyAsync.when(
              data: (currencyList) {
                final currencyNames = currencyList
                    .map((e) => e.currencyValue ?? '')
                    .where((e) => e.isNotEmpty)
                    .toList();

                return ReusableCountryBottomSheet(
                  title: 'Select Currency',
                  items: currencyNames,
                  onSelect: (selectedCurrency) {
                    final selected = currencyList.firstWhere(
                          (c) => c.currencyValue == selectedCurrency,
                      orElse: () => currencyList.first,
                    );
                    // This selector's state can be handled locally or via a simple StateProvider if needed elsewhere.
                    // For now, it just closes the sheet.
                    // close sheet
                    Navigator.of(context).pop();

                    debugPrint("💱 Selected AddBill Item Currency: ${selected.currencyValue} (id: ${selected.currencyId})");
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Failed to load currencies: $err')),
            );
          },
        );
      },
    );
  }

  // ------------------------------
  // Item amount calculation
  // ------------------------------
  void calculateItemAmount(int index, WidgetRef ref) {
    if (index < 0 || index >= state.itemDetails.length) return;

    final item = state.itemDetails[index];

    final quantity = (item.quantity ?? 0).toDouble();
    final rate = double.tryParse(item.rateDate ?? '') ?? 0.0;

    double amount = quantity * rate;

    // Simplified discount logic based on item-level flags.
    // Assuming a discount value is present.
    if ((item.discountAmount ?? 0) > 0 || (item.discountPercentage ?? 0) > 0) {
      final isCurrency = item.discountIsCurrency ?? false; // Default to percentage
      final discountRaw = item.discountAmount;
      final discountVal = (discountRaw is String)
          ? double.tryParse(discountRaw.toString()) ?? 0.0
          : (discountRaw is double
          ? discountRaw
          : (double.tryParse(discountRaw?.toString() ?? '') ?? 0.0));

      if (isCurrency) {
        amount -= discountVal;
      } else {
        // If not currency, use percentage field
        final discPerc = item.discountPercentage ?? 0.0;
        amount -= (amount * discPerc / 100.0);
      }
    }

    if (amount < 0) amount = 0.0;

    updateItemField(index, 'amount', amount);
    debugPrint('DEBUG calc idx=$index qty=$quantity rate=$rate -> amount=$amount');
  }

  // ------------------------------
  // Validation (keeps your validations)
  // ------------------------------
  void validateForm() {
    final Map<String, String?> errors = {};

    if (state.vendor == null || state.vendor!.isEmpty) {
      errors['vendor'] = 'Vendor is required';
    }
    if (state.vendorId == null || state.vendorId == 0) {
      errors['vendor'] = 'Vendor selection is invalid';
    }
    if (state.branch == null || state.branch!.isEmpty) {
      errors['branch'] = 'Branch is required';
    }
    if (state.billRefNo == null || state.billRefNo!.isEmpty) {
      errors['billRefNo'] = 'Bill reference number is required';
    }
    // if (state.orderNo == null || state.orderNo!.isEmpty) {
    //   errors['orderNo'] = 'Order Number is required';
    // }
    if (state.billDate == null) {
      errors['billDate'] = 'Bill date is required';
    }
    if (state.dueDate == null) {
      errors['dueDate'] = 'Due date is required';
    }
    if (state.shippingMethod == null || state.shippingMethod!.isEmpty) {
      errors['shippingMethod'] = 'Shipping method is required';
    }
    if (state.currency == null || state.currency!.isEmpty) {
      errors['currency'] = 'Currency is required';
    }

    for (var item in state.itemDetails) {
      if (item.quantity == null || item.quantity == 0) {
        errors['quantity'] = 'Quantity is required';
      }
      if (item.itemName == null || item.itemName!.isEmpty) {
        errors['itemName'] = 'Item name is required';
      }
      if (item.account == null || item.account!.isEmpty) {
        errors['account'] = 'Account is required';
      }
      if (item.unitType == null || item.unitType!.isEmpty) {
        errors['unitType'] = 'Unit type is required';
      }

      final parsedRate = double.tryParse(item.rateDate ?? '');
      if (item.rateDate == null || parsedRate == null || parsedRate == 0.0) {
        errors['rateDate'] = 'Rate is required';
      }

      if (item.taxType == null || item.taxType!.isEmpty) {
        errors['taxType'] = 'Tax type is required';
      }
      if (item.amount == null || item.amount == 0.0) {
        errors['amount'] = 'Amount must be greater than 0';
      }
    }
    state = state.copyWith(errors: errors);
  }

  bool validateLastItemFields() {
    final Map<String, String?> errors = {};
    if (state.itemDetails.isEmpty) return true;

    final item = state.itemDetails.last;

    if (item.quantity == null || item.quantity == 0) {
      errors['quantity'] = 'Quantity is required';
    }
    if (item.itemName == null || item.itemName!.isEmpty) {
      errors['itemName'] = 'Item name is required';
    }
    if (item.account == null || item.account!.isEmpty) {
      errors['account'] = 'Account is required';
    }
    if (item.unitType == null || item.unitType!.isEmpty) {
      errors['unitType'] = 'Unit type is required';
    }

    final parsedRate = double.tryParse(item.rateDate ?? '');
    if (item.rateDate == null || parsedRate == null || parsedRate == 0.0) {
      errors['rateDate'] = 'Rate is required';
    }

    if (item.taxType == null || item.taxType!.isEmpty) {
      errors['taxType'] = 'Tax type is required';
    }

    if (item.amount == null || item.amount == 0.0) {
      errors['amount'] = 'Amount must be greater than 0';
    }

    if (errors.isNotEmpty) {
      state = state.copyWith(errors: errors);
      return false;
    }

    return true;
  }

  void clearForm() {
    state = const AddBillFormModel();
  }
}

// Providers
final addBillFormProvider =
StateNotifierProvider<AddBillFormNotifier, AddBillFormModel>(
      (ref) => AddBillFormNotifier(),
);

final addNewLineProvider = StateProvider<int>((ref) => 1);

// Utility mappers (copied over for convenience if used nearby)
List<String> buildBillingAddressLines(VendorData v) {
  final a = v.billingAddress;
  return [
    if ((v.displayName ?? '').trim().isNotEmpty) v.displayName!.trim(),
    if ((a?.streetAddress ?? '').trim().isNotEmpty) a!.streetAddress!.trim() else
      [
        if ((a?.buildingNumber ?? '').toString().trim().isNotEmpty) a!.buildingNumber!.toString().trim(),
        if ((a?.streetName ?? '').trim().isNotEmpty) a!.streetName!.trim(),
      ].where((e) => e.trim().isNotEmpty).join(' ').trim(),
    [
      if ((a?.city ?? '').trim().isNotEmpty) a!.city!.trim(),
      if ((a?.state ?? '').trim().isNotEmpty) a!.state!.trim(),
    ].where((e) => e.trim().isNotEmpty).join(', ').trim(),
    if ((a?.zipCode ?? '').toString().trim().isNotEmpty) a!.zipCode!.toString().trim(),
    (a?.countryName ?? a?.countryRegion ?? '').trim(),
  ].where((e) => e.trim().isNotEmpty).toList();
}

List<String> buildShippingAddressLines(VendorData v) {
  final a = v.shippingAddress;
  return [
    if ((v.displayName ?? '').trim().isNotEmpty) v.displayName!.trim(),
    if ((a?.streetAddress ?? '').trim().isNotEmpty) a!.streetAddress!.trim() else
      [
        if ((a?.buildingNumber ?? '').toString().trim().isNotEmpty) a!.buildingNumber!.toString().trim(),
        if ((a?.streetName ?? '').trim().isNotEmpty) a!.streetName!.trim(),
      ].where((e) => e.trim().isNotEmpty).join(' ').trim(),
    [
      if ((a?.city ?? '').trim().isNotEmpty) a!.city!.trim(),
      if ((a?.state ?? '').trim().isNotEmpty) a!.state!.trim(),
    ].where((e) => e.trim().isNotEmpty).join(', ').trim(),
    if ((a?.zipCode ?? '').toString().trim().isNotEmpty) a!.zipCode!.toString().trim(),
    (a?.countryName ?? a?.countryRegion ?? '').trim(),
  ].where((e) => e.trim().isNotEmpty).toList();
}
