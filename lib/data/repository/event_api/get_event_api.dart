import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/event_model/event_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class GetEventsRepository {
  final BaseApiService _apiService;
  GetEventsRepository(this._apiService);

  Future<List<EventModel>> fetchEvents() async {
    try {
      return await _apiService.getListApi(
        url: 'http://81.208.173.149/pb-process-service/api/process/getEvents',
        fromJson: (json) => EventModel.fromJson(json),
      );
    } catch (e) {
      print('Error fetching events: $e');
      return [];
    }
  }
}

final getEventsRepositoryProvider = Provider<GetEventsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetEventsRepository(apiService);
});

final eventsProvider = FutureProvider<List<EventModel>>((ref) async {
  final repository = ref.read(getEventsRepositoryProvider);
  return repository.fetchEvents();
});
