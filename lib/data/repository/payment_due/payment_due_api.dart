import 'package:payzo_books/data/models/payment_due_model/payment_due_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class PaymentDueRepository {
  final BaseApiService _apiService;
  PaymentDueRepository(this._apiService);

  Future<PaymentDueModel> fetchPaymentDueData() async {
    try {
      print('Fetching payment due data...');
      return await _apiService.getApi(
        url: "api/getPaymentDue",
        fromJson: (json) {
          print('Payment due API response received');
          if (json is List) {
            return PaymentDueModel.fromList(json as List);
          } else {
            print('Warning: Expected a list response but got an object');
            return PaymentDueModel.empty();
          }
        },
      );
    } catch (e) {
      print('Error fetching payment due data: $e');
      return PaymentDueModel.empty();
    }
  }
}

final paymentDueRepository = Provider<PaymentDueRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return PaymentDueRepository(apiService);
});

final paymentDueData = FutureProvider<PaymentDueModel>((ref) async {
  print('paymentDueData provider called');
  final repository = ref.read(paymentDueRepository);
  final result = await repository.fetchPaymentDueData();
  print('Payment due data fetched: ${result.items.length} items');
  return result;
});
