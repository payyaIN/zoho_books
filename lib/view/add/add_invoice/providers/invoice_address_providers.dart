import 'package:payzo_books/import_data.dart';

/// ✅ Invoice Billing Address Provider
class InvoiceBillingAddressNotifier extends StateNotifier<List<String>> {
  InvoiceBillingAddressNotifier() : super([]);

  void addAddress(String address) {
    state = [...state, address];
  }

  void removeAddress(int index) {
    final updatedList = [...state]..removeAt(index);
    state = updatedList;
  }

  void clearAddresses() {
    state = [];
  }
}

final invoiceBillingAddressProvider =
StateNotifierProvider<InvoiceBillingAddressNotifier, List<String>>((ref) {
  return InvoiceBillingAddressNotifier();
});

/// ✅ Invoice Shipping Address Provider
class InvoiceShippingAddressNotifier extends StateNotifier<List<String>> {
  InvoiceShippingAddressNotifier() : super([]);

  void addAddress(String address) {
    state = [...state, address];
  }

  void removeAddress(int index) {
    final updatedList = [...state]..removeAt(index);
    state = updatedList;
  }

  void clearAddresses() {
    state = [];
  }
}

final invoiceShippingAddressProvider =
StateNotifierProvider<InvoiceShippingAddressNotifier, List<String>>((ref) {
  return InvoiceShippingAddressNotifier();
});
