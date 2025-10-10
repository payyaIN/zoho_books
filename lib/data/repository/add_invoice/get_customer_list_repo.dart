import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_invoice/get_customer_list.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class GetCustomerListRepository {
  final BaseApiService apiService;
  GetCustomerListRepository(this.apiService);

  Future<List<Customer>> fetchCustomerList() {
    return apiService.getApi(
      url: 'http://81.208.173.149/pb-process-service/api/process/getCustomerList',
      fromJson: (json) {
        final dataList = json['response']['response'] as List<dynamic>;
        return dataList.map((itemJson) => Customer.fromJson(itemJson)).toList();
      },
    );
  }
}

final getCustomerListRepoProvider = Provider<GetCustomerListRepository>((ref) {
  return GetCustomerListRepository(ref.read(apiServiceProvider));
});

final fetchCustomerListProvider = FutureProvider<List<Customer>>((ref) {
  return ref.read(getCustomerListRepoProvider).fetchCustomerList();
});
