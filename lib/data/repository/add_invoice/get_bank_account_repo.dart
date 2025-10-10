import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_invoice/get_bank_account.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class GetBankAccountRepository {
  final BaseApiService apiService;

  GetBankAccountRepository(this.apiService);

  Future<List<BankAccount>> fetchBankAccounts() {
    return apiService.getApi(
      url: 'http://81.208.173.149/pb-accounting-service/api/statements/bankAccountsList',
      fromJson: (json) {
        final List<dynamic> data = json['response'] ?? [];
        return data.map((e) => BankAccount.fromJson(e)).toList();
      },
    );
  }
}

final getBankAccountRepoProvider = Provider<GetBankAccountRepository>((ref) {
  return GetBankAccountRepository(ref.read(apiServiceProvider));
});

final fetchBankAccountListProvider = FutureProvider<List<BankAccount>>((ref) {
  return ref.read(getBankAccountRepoProvider).fetchBankAccounts();
});
