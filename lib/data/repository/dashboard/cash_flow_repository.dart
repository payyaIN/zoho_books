import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/cash_flow_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class CashFlowRepository {
  final BaseApiService _apiService;
  CashFlowRepository(this._apiService);

  Future<CashFlowModel> fetchData() {
    return _apiService.getApi(
      url: 'http://158.101.247.195/pb-accounting-service/api/dashboard/getCashFlow?periodType=0',
      fromJson: (json) => CashFlowModel.fromJson(json),
    );
  }
}

final getCashFlowProvider = Provider<CashFlowRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return CashFlowRepository(apiService);
});