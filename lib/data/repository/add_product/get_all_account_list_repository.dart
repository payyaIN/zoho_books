import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

import '../../models/add_product/get_all_account_model.dart';

class ChartOfAccountsRepository {
  final BaseApiService apiService;
  ChartOfAccountsRepository(this.apiService);

  Future<AccountResponse> fetchChartOfAccounts() {
    return apiService.getApi(
      url: 'http://81.208.173.149/pb-accounting-service/api/chartOfAccounts/getAccountList',
      fromJson: (json) => AccountResponse.fromJson(json),
    );
  }
}

final chartOfAccountsRepoProvider = Provider<ChartOfAccountsRepository>((ref) {
  return ChartOfAccountsRepository(ref.read(apiServiceProvider));
});

final getChartOfAccountsProvider = FutureProvider<AccountResponse>((ref) {
  return ref.read(chartOfAccountsRepoProvider).fetchChartOfAccounts();
});
