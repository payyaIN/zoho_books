import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/cash_flow_model.dart';
import 'package:payzo_books/data/models/income_and_expences/income_and_expences.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class IncomeExpenceRepo {
  final BaseApiService _apiService;
  IncomeExpenceRepo(this._apiService);

  Future<IncomeAndExpenses> fetchData() {
    return _apiService.getApi(
      url: 'http://158.101.247.195/pb-accounting-service/api/dashboard/getIncomeAndExpense?periodType=0',
      fromJson: (json) => IncomeAndExpenses.fromJson(json),
    );
  }
}

final getIncomeAndExpenseProvider = Provider<IncomeExpenceRepo>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return IncomeExpenceRepo(apiService);
});