import 'package:payzo_books/data/models/bank_account_list_model/bank_account_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class BankAccountsListRepository {
  final BaseApiService _apiService;
  BankAccountsListRepository(this._apiService);

  Future<BankAccountsListModel> fetchBankAccountsData() async {
    try {
      print('Fetching bank accounts data...');
      return await _apiService.getApi(
        url: "api/statements/bankAccountsList",
        fromJson: (json) {
          print('Bank accounts API response received');
          return BankAccountsListModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error fetching bank accounts data: $e');
      return BankAccountsListModel.empty();
    }
  }
}

final bankAccountsListRepository = Provider<BankAccountsListRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return BankAccountsListRepository(apiService);
});

final bankAccountsListData = FutureProvider<BankAccountsListModel>((ref) async {
  print('bankAccountsListData provider called');
  final repository = ref.read(bankAccountsListRepository);
  final result = await repository.fetchBankAccountsData();
  print('Bank accounts data fetched: ${result.response.length} accounts');
  return result;
});
