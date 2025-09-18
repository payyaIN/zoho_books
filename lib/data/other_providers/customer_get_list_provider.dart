import 'package:payzo_books/data/models/customer_model/customer_list_model.dart';
import 'package:payzo_books/import_data.dart';

class CustomerListNotifier extends StateNotifier<GetCustomerListModel?> {
  CustomerListNotifier() : super(null);

  void setCustomerListData(GetCustomerListModel customerModel) {
    state = customerModel;
  }

  void clearCustomerListData() {
    state = null;
  }
}

final customerListProvider =
    StateNotifierProvider<CustomerListNotifier, GetCustomerListModel?>((ref) {
  return CustomerListNotifier();
});

final selectedCustomerProvider = StateProvider<Customer?>((ref) => null);

void setSelectedCustomer(WidgetRef ref, Customer customer) {
  ref.read(selectedCustomerProvider.notifier).state = customer;
}

Customer? getSelectedCustomer(WidgetRef ref) {
  return ref.read(selectedCustomerProvider);
}

final customerByIdProvider = Provider.family<Customer?, int>((ref, customerId) {
  final customerModel = ref.watch(customerListProvider);
  if (customerModel == null) return null;

  try {
    return customerModel.response.response
        .firstWhere((customer) => customer.partyId == customerId);
  } catch (e) {
    print('Customer with ID $customerId not found');
    return null;
  }
});

final customersByCountryProvider =
    Provider.family<List<Customer>, String>((ref, countryRegion) {
  final customerModel = ref.watch(customerListProvider);
  if (customerModel == null) return [];

  return customerModel.response.response
      .where(
          (customer) => customer.shippingAddress.countryRegion == countryRegion)
      .toList();
});

final searchCustomersProvider =
    Provider.family<List<Customer>, String>((ref, searchQuery) {
  final customerModel = ref.watch(customerListProvider);
  if (customerModel == null) return [];
  if (searchQuery.isEmpty) return customerModel.response.response;

  final query = searchQuery.toLowerCase();
  return customerModel.response.response.where((customer) {
    return customer.displayName.toLowerCase().contains(query) ||
        customer.emailAddress.toLowerCase().contains(query) ||
        customer.companyName.toLowerCase().contains(query) ||
        customer.primaryContact.firstName.toLowerCase().contains(query) ||
        customer.primaryContact.lastName.toLowerCase().contains(query);
  }).toList();
});
