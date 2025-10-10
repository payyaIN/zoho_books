import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/model/expense_detail_model.dart';

class GetExpenseDetailsRepository {
  final BaseApiService _apiService;
  GetExpenseDetailsRepository(this._apiService);

  Future<ExpenseDetailModel> fetchExpenseDetailsData(int expenseId) async {
    try {
      print('Fetching expense details for expenseId: $expenseId');

      final result = await _apiService.getApi(
        url:
        "http://81.208.173.149/pb-accounting-service/api/expense/view?expenseId=$expenseId",
        fromJson: (json) {
          print('Expense detail API response received for expenseId $expenseId');
          return  ExpenseDetailModel.fromJson(json);
        },
      );

      print('Expense detail result for expenseId $expenseId:');
      print('- Expense Amount: ${result.response?.expenseAmount}');
      print('- Vendor Name: ${result.response?.vendor}');
      print('- Status: ${result.status}');

      return result;
    } catch (e) {
      print('Error fetching expense details for expenseId $expenseId: $e');
      return ExpenseDetailModel.empty();
    }
  }
}

final getExpenseDetailsData = Provider<GetExpenseDetailsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetExpenseDetailsRepository(apiService);
});

final getExpenseDetailsProvider =
FutureProvider.family<ExpenseDetailModel, int>((ref, expenseId) async {
  print('getExpenseDetailsProvider called for expenseId: $expenseId');
  final repository = ref.read(getExpenseDetailsData);
  final result = await repository.fetchExpenseDetailsData(expenseId);
  print('Expense details fetched for expenseId $expenseId');
  return result;
});
