import 'package:payzo_books/import_data.dart';

/// ✅ First Address List Provider
class PayzoFirstAddressListNotifier extends StateNotifier<List<String>> {
  PayzoFirstAddressListNotifier() : super([]);

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

final payzoFirstAddressListProvider =
StateNotifierProvider<PayzoFirstAddressListNotifier, List<String>>((ref) {
  return PayzoFirstAddressListNotifier();
});


/// ✅ Second Address List Provider
class PayzoSecondAddressListNotifier extends StateNotifier<List<String>> {
  PayzoSecondAddressListNotifier() : super([]);

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

final payzoSecondAddressListProvider =
StateNotifierProvider<PayzoSecondAddressListNotifier, List<String>>((ref) {
  return PayzoSecondAddressListNotifier();
});
