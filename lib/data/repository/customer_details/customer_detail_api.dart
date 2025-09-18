import 'package:payzo_books/data/models/customer_model/customer_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetCustomerDetailsRepository {
  final BaseApiService _apiService;
  GetCustomerDetailsRepository(this._apiService);

  Future<CustomerModel> fetchCustomerDetailsData(int partyId) async {
    try {
      print('Fetching customer details for partyId: $partyId');

      final result = await _apiService.getApi(
        url:
            "http://158.101.247.195/pb-process-service/api/process/viewParty?partyId=$partyId",
        fromJson: (json) {
          print('Customer detail API response received for partyId $partyId');
          return CustomerModel.fromMap(json);
        },
      );

      print('Customer detail result for partyId $partyId:');
      print('- Has error: ${result.error}');
      print('- Response count: ${result.response.response.length}');

      if (result.response.response.isNotEmpty) {
        print(
            '- First customer name: ${result.response.response.first.companyName}');
      } else {
        print('- No customer details found in response');
      }

      return result;
    } catch (e) {
      print('Error fetching customer details for partyId $partyId: $e');

      return CustomerModel(
        error: true,
        errorMsg: 'Failed to load customer details: $e',
        response: ResponseData(response: [], totalRecord: 0),
        status: false,
        transactionId: "",
      );
    }
  }
}

final getCustomersDetailsData = Provider<GetCustomerDetailsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetCustomerDetailsRepository(apiService);
});

final getCustomerDetailsProvider =
    FutureProvider.family<CustomerModel, int>((ref, partyId) async {
  print('getCustomerDetailsProvider called for partyId: $partyId');
  final repository = ref.read(getCustomersDetailsData);
  final result = await repository.fetchCustomerDetailsData(partyId);
  print(
      'Customer details fetched for partyId $partyId: ${result.response.response.length} customers found');
  return result;
});
