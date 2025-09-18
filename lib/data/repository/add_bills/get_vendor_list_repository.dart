import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_bills/get_venor_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
class GetVendorListRepository {
  final BaseApiService _apiService;
  GetVendorListRepository(this._apiService);

  Future<VendorListResponse> fetchData() {
    return _apiService.getApi(
      url: 'http://158.101.247.195/pb-process-service/api/process/getVendorList',
      fromJson: (json) => VendorListResponse.fromJson(json),
    );
  }
}

final getVendorListProvider = Provider<GetVendorListRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetVendorListRepository(apiService);
});
final getVendorList = FutureProvider<VendorListResponse>((ref) async {
  final repository = ref.watch(getVendorListProvider);
  return repository.fetchData();
});
