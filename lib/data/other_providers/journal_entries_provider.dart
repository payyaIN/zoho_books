import 'package:payzo_books/data/models/jounrnal_entries_model/journal_entries_model.dart';
import 'package:payzo_books/import_data.dart';

class JournalEntriesNotifier
    extends StateNotifier<Map<int, GetJournalEntriesModel>> {
  JournalEntriesNotifier() : super({});

  void setJournalEntries(int transactionId, GetJournalEntriesModel entries) {
    state = {...state, transactionId: entries};
  }

  void clearJournalEntries(int transactionId) {
    final newState = Map<int, GetJournalEntriesModel>.from(state);
    newState.remove(transactionId);
    state = newState;
  }

  void clearAllJournalEntries() {
    state = {};
  }
}

final journalEntriesNotifierProvider = StateNotifierProvider<
    JournalEntriesNotifier, Map<int, GetJournalEntriesModel>>((ref) {
  return JournalEntriesNotifier();
});

final journalEntriesTotalProvider =
    Provider.family<Map<String, double>, int>((ref, transactionId) {
  final entriesMap = ref.watch(journalEntriesNotifierProvider);
  final entries = entriesMap[transactionId]?.response ?? [];

  if (entries.isEmpty) return {'debit': 0.0, 'credit': 0.0};

  double totalDebit = 0.0;
  double totalCredit = 0.0;

  for (var entry in entries) {
    totalDebit += entry.debitAmount;
    totalCredit += entry.creditAmount;
  }

  return {
    'debit': totalDebit,
    'credit': totalCredit,
  };
});

final journalEntriesByAccountProvider =
    Provider.family<List<JournalEntry>, JournalEntriesFilter>((ref, filter) {
  final entriesMap = ref.watch(journalEntriesNotifierProvider);
  final entries = entriesMap[filter.transactionId]?.response ?? [];

  if (entries.isEmpty) return [];

  return entries.where((entry) => entry.accountId == filter.accountId).toList();
});

class JournalEntriesFilter {
  final int transactionId;
  final int accountId;

  JournalEntriesFilter({
    required this.transactionId,
    required this.accountId,
  });
}
