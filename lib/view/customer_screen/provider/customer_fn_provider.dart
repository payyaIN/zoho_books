import 'package:payzo_books/data/models/customer_model/customer_model.dart';
import 'package:payzo_books/import_data.dart';

class CustomerDetailsNotifier extends StateNotifier<CustomerModel?> {
  CustomerDetailsNotifier() : super(null);

  void selectCustomer(CustomerModel customerDetailModel) {
    state = customerDetailModel;
  }

  void clearSelection() {
    state = null;
  }
}

final customerSelectionProvider =
    StateNotifierProvider<CustomerDetailsNotifier, CustomerModel?>((ref) {
  return CustomerDetailsNotifier();
});

final specificCustomerProvider =
    Provider.family<Customer?, CustomerModel?>((ref, model) {
  if (model == null || model.response.response.isEmpty) {
    return null;
  }

  return model.response.response[0];
});
