import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/view_party/view_party_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class ViewPartyRepository {
  final BaseApiService _apiService;
  ViewPartyRepository(this._apiService);

  Future<ViewPartyModel> fetchPartyDetails(int partyId) async {
    try {
      return await _apiService.getApi(
        url:
            'http://81.208.173.149/pb-process-service/api/process/viewParty?partyId=$partyId',
        fromJson: (json) => ViewPartyModel.fromMap(json),
      );
    } catch (e) {
      print('Error fetching party details: $e');
      throw Exception('Failed to load party details: $e');
    }
  }
}

final viewPartyRepositoryProvider = Provider<ViewPartyRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ViewPartyRepository(apiService);
});

final viewPartyProvider =
    FutureProvider.family<ViewPartyModel, int>((ref, partyId) async {
  final repository = ref.read(viewPartyRepositoryProvider);
  return repository.fetchPartyDetails(partyId);
});

final customerTypeProvider = Provider.family<String, int>((ref, partyId) {
  final viewPartyAsyncValue = ref.watch(viewPartyProvider(partyId));

  if (viewPartyAsyncValue.hasValue) {
    return viewPartyAsyncValue.value!.response.customerType;
  }

  return 'BUSINESS';
});
