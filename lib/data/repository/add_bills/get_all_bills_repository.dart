import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_bills/get_all_accounts.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class GetAccountListRepository {
  final BaseApiService apiService;
  GetAccountListRepository(this.apiService);

  Future<List<Account>> fetchAccountList() {
    return apiService.getListApi(
      url: 'http://158.101.247.195/pb-accounting-service/api/chartOfAccounts/getAllAccounts',
      fromJson: (json) => Account.fromJson(json),
    );
  }
}

final getAccountListRepoProvider = Provider<GetAccountListRepository>((ref) {
  return GetAccountListRepository(ref.read(apiServiceProvider));
});

final fetchAccountListProvider = FutureProvider<List<Account>>((ref) {
  return ref.read(getAccountListRepoProvider).fetchAccountList();
});
