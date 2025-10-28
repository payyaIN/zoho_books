import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/view/add/add_billls/model/add_bill_form_model.dart';
import 'package:payzo_books/view/add/add_billls/model/item_details_model.dart';

import '../../../../data/models/add_bills/get_venor_list_model.dart';
import '../../../../data/repository/add_bills/get_price_currency_repository.dart';
import '../../../../import_data.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';

import '../../../../utils/common_widgets/reusable_bottom_sheet.dart';
import 'add_bill_providers.dart';
class AddBillFormNotifier extends StateNotifier<AddBillFormModel> {
  AddBillFormNotifier() : super(const AddBillFormModel());

  void updateField(String key, dynamic value) {
    switch (key) {
      case 'vendor':
        state = state.copyWith(vendor: value);
        break;
      case 'vendorId':
        state = state.copyWith(vendorId: value);
        break;
      case 'branch':
        state = state.copyWith(branch: value);
        break;
      case 'billRefNo':
        state = state.copyWith(billRefNo: value);
        break;
      case 'orderNo':
        state = state.copyWith(orderNo: value);
        break;
      case 'billDate':
        state = state.copyWith(billDate: value);
        break;
      case 'dueDate':
        state = state.copyWith(dueDate: value);
        break;
      case 'shippingMethod':
        state = state.copyWith(shippingMethod: value);
        break;
      case 'currency':
        state = state.copyWith(currency: value);
        break;
      case 'paymentTerms':
        state = state.copyWith(paymentTerms: value);
        break;
      case 'customerNotes':
        state = state.copyWith(customerNotes: value);
        break;
      case 'terms':
        state = state.copyWith(terms: value);
        break;
      case 'attachment':
        state = state.copyWith(attachment: value as File);
        break;
      case 'customerId':
        state = state.copyWith(customerId: value);
        break;
      case 'orgId':
        state = state.copyWith(orgId: value);
        break;
      case 'cmpCr':
        state = state.copyWith(cmpCr: value);
        break;
    }
  }

  void updateItemField(int index, String key, dynamic value) {
    final updatedList = [...state.itemDetails];
    final current = updatedList[index];

    final updated = switch (key) {
      'itemName' => current.copyWith(itemName: value),
      'account' => current.copyWith(account: value),
      'quantity' => current.copyWith(quantity: value),
      'unitType' => current.copyWith(unitType: value),
      'rateDate' => current.copyWith(rateDate: value),
      'taxType' => current.copyWith(taxType: value),
      'customerDate' => current.copyWith(customerDate: value),
      'amount' => current.copyWith(amount: value),
      'discountAmount' => current.copyWith(discountAmount: value),
      'discountPercentage' => current.copyWith(discountPercentage: value),
      'exemptionReason' => current.copyWith(exemptionReason: value),
      'taxDescription' => current.copyWith(taxDescription: value),
      'othersDescription' => current.copyWith(othersDescription: value),
      'othersAmount' => current.copyWith(othersAmount: value),
      'discountIsCurrency' => current.copyWith(discountIsCurrency: value as bool),
      'unitId' => current.copyWith(unitId: value),
      'customerId' => current.copyWith(customerId: value),
      'taxAmount' => current.copyWith(taxAmount: value),
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
    final updatedList = [...state.itemDetails]..removeAt(index);
    state = state.copyWith(itemDetails: updatedList);
    _recalculateTotal();
  }

  void _recalculateTotal() {
    // item.amount already includes quantity (we set amount = qty * rate above),
    // so just sum the line amounts directly.
    final subTotal = state.itemDetails.fold<double>(
      0.0,
          (sum, item) => sum + (item.amount ?? 0.0),
    );
    final tax = 0.0; // compute tax if needed
    final total = subTotal + tax;
    state = state.copyWith(subTotal: subTotal, tax: tax, total: total);
  }

  Future<void> showAddBillCurrencySelector(BuildContext context, WidgetRef ref) async {
    // keep same unfocus / delay behaviour as your other selector
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

                    // write into new providers
                    ref.read(addBillGlobalDiscountCurrencyProvider.notifier).state =
                        selected.currencyValue ?? 'SAR';
                    ref.read(addBillGlobalDiscountCurrencyIdProvider.notifier).state =
                        selected.currencyId?.toInt();

                    // optional: also update AddBillFormModel state if you want it reflected in the form model
                    final formNotifier = ref.read(addBillFormProvider.notifier);
                    formNotifier.updateField('currency', selected.currencyValue ?? 'SAR');
                    // debug log
                    print("💱 Selected AddBill Currency: ${selected.currencyValue} (id: ${selected.currencyId})");
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Failed to load currencies: $err')),
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

                    // write into new providers for item-level currency
                    ref.read(addBillItemCurrencySelector.notifier).state =
                        selected.currencyValue ?? 'SAR';
                    ref.read(addBillItemCurrencySelectorId.notifier).state =
                        selected.currencyId?.toInt();

                    // optional: also update AddBillFormModel state if you want
                    // e.g. ref.read(addBillFormProvider.notifier).updateField('itemCurrency', selected.currencyValue ?? 'SAR');

                    // close sheet
                    Navigator.of(context).pop();

                    // debug log
                    print("💱 Selected AddBill Item Currency: ${selected.currencyValue} (id: ${selected.currencyId})");
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Failed to load currencies: $err')),
            );
          },
        );
      },
    );
  }
  void calculateItemAmount(int index, WidgetRef ref) {
    final discountState = ref.read(payzoDiscountProvider);
    final showItemDiscount =
        discountState.apply && discountState.level == PayzoDiscountLevel.item;

    final item = state.itemDetails[index];

    final quantity = (item.quantity ?? 0).toDouble();
    final rate = double.tryParse(item.rateDate?.toString() ?? '') ??
        (item.rateDate is num ? (item.rateDate as num).toDouble() : 0.0);

    double amount = quantity * rate;

    if (showItemDiscount) {
      // prefer item-level flag, fallback to provider; default to percentage (false) if both null
      final providerIsCurrency = ref.read(addBillItemDiscountCurrencyProvider) == true;
      final isCurrency = item.discountIsCurrency ?? providerIsCurrency;

      final discountRaw = item.discountAmount;
      final discountVal = double.tryParse(discountRaw?.toString() ?? '') ?? 0.0;

      if (isCurrency) {
        amount -= discountVal;
      } else {
        amount -= (amount * discountVal / 100.0);
      }
    }

    if (amount < 0) amount = 0.0;

    updateItemField(index, 'amount', amount);
    print('DEBUG calc idx=$index qty=$quantity rate=$rate '
        'item.discountIsCurrency=${item.discountIsCurrency} '
        'providerIsCurrency=${ref.read(addBillItemDiscountCurrencyProvider)} '
        'discountVal=${item.discountAmount} -> amount=$amount');
  }




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
    // if (state.paymentTerms == null || state.paymentTerms!.isEmpty) {
    //   errors['paymentTerms'] = 'Payment terms are required';
    // }
    // if (state.customerNotes == null || state.customerNotes!.isEmpty) {
    //   errors['customerNotes'] = 'Customer notes are required';
    // }
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
      if (item.rateDate == null || item.rateDate == 0) {
        errors['rateDate'] = 'Rate is required';
      }
      if (item.taxType == null || item.taxType!.isEmpty) {
        errors['taxType'] = 'Tax type is required';
      }
      // if (item.customerDate == null) {
      //   errors['customerDate'] = 'Customer date is required';
      // }
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
    if (item.rateDate == null || item.rateDate == 0) {
      errors['rateDate'] = 'Rate is required';
    }

    if (item.taxType == null || item.taxType!.isEmpty) {
      errors['taxType'] = 'Tax type is required';
    }
    // if (item.customerDate == null || item.customerDate.toString().isEmpty) {
    //   errors['customerDate'] = 'Customer details are required';
    // }

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

final addBillFormProvider =
    StateNotifierProvider<AddBillFormNotifier, AddBillFormModel>(
  (ref) => AddBillFormNotifier(),
);

final addNewLineProvider = StateProvider<int>((ref) => 1);
// utils/vendor_address_mapper.dart

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
