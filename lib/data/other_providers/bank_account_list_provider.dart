import 'package:payzo_books/data/models/bank_account_list_model/bank_account_list_model.dart';
import 'package:payzo_books/import_data.dart';

class BankAccountsNotifier extends StateNotifier<BankAccountsListModel?> {
  BankAccountsNotifier() : super(null);

  void setBankAccountsData(BankAccountsListModel accountsModel) {
    state = accountsModel;
  }

  void clearBankAccountsData() {
    state = null;
  }
}

final bankAccountsProvider =
    StateNotifierProvider<BankAccountsNotifier, BankAccountsListModel?>((ref) {
  return BankAccountsNotifier();
});

final selectedBankAccountProvider = StateProvider<BankAccount?>((ref) => null);

void setSelectedBankAccount(WidgetRef ref, BankAccount account) {
  ref.read(selectedBankAccountProvider.notifier).state = account;
}

BankAccount? getSelectedBankAccount(WidgetRef ref) {
  return ref.read(selectedBankAccountProvider);
}

final bankAccountByIdProvider =
    Provider.family<BankAccount?, int>((ref, accountId) {
  final accountsModel = ref.watch(bankAccountsProvider);
  if (accountsModel == null) return null;

  try {
    return accountsModel.response
        .firstWhere((account) => account.accountId == accountId);
  } catch (e) {
    print('Bank account with ID $accountId not found');
    return null;
  }
});

final searchBankAccountsProvider =
    Provider.family<List<BankAccount>, String>((ref, searchQuery) {
  final accountsModel = ref.watch(bankAccountsProvider);
  if (accountsModel == null) return [];
  if (searchQuery.isEmpty) return accountsModel.response;

  final query = searchQuery.toLowerCase();
  return accountsModel.response.where((account) {
    return account.accountName.toLowerCase().contains(query) ||
        account.accountCode.toLowerCase().contains(query);
  }).toList();
});
