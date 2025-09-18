import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/get_total_payments_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class GetTotalPayablesRepository {
  final BaseApiService _apiService;
  GetTotalPayablesRepository(this._apiService);

  Future<GetTotalPayables> fetchData() {
    return _apiService.getApi(
      url: 'http://158.101.247.195/pb-accounting-service/api/dashboard/getTotalPayables',
      fromJson: (json) => GetTotalPayables.fromJson(json),
    );
  }
}

final getTotalPayablesAmount = Provider<GetTotalPayablesRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetTotalPayablesRepository(apiService);
});