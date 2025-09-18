import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/get_total_recievables.dart';
import '../services/base_api_service.dart';

class GetTotalRecievablesRepository {
  final BaseApiService _apiService;
  GetTotalRecievablesRepository(this._apiService);

  Future<GetTotalRecievables> fetchData() {
    return _apiService.getApi(
      url: 'http://158.101.247.195/pb-accounting-service/api/dashboard/getTotalReceivables',
      fromJson: (json) => GetTotalRecievables.fromJson(json),
    );
  }
}

final getTotalRecieveablesProvider = Provider<GetTotalRecievablesRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetTotalRecievablesRepository(apiService);
});