import 'package:payzo_books/data/models/jounrnal_entries_model/journal_entries_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class JournalEntriesRepository {
  final BaseApiService _apiService;
  JournalEntriesRepository(this._apiService);

  Future<GetJournalEntriesModel> fetchJournalEntries(int transactionId) async {
    try {
      print('Fetching journal entries for transaction ID: $transactionId');
      return await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-accounting-service/api/getDetail/getJournalEntries?transactionId=$transactionId",
        fromJson: (json) {
          print('Journal entries API response received');
          return GetJournalEntriesModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error fetching journal entries: $e');
      return GetJournalEntriesModel.empty();
    }
  }
}

final journalEntriesRepository = Provider<JournalEntriesRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return JournalEntriesRepository(apiService);
});

final journalEntriesProvider =
    FutureProvider.family<GetJournalEntriesModel, int>(
        (ref, transactionId) async {
  print('journalEntriesProvider called for transaction ID: $transactionId');
  final repository = ref.read(journalEntriesRepository);
  final result = await repository.fetchJournalEntries(transactionId);
  print('Journal entries fetched: ${result.response.length} entries');
  return result;
});
