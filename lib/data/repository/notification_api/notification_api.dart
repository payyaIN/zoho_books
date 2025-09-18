import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class NotificationRepository {
  final BaseApiService _apiService;

  NotificationRepository(this._apiService);

  Future<NotificationModel> fetchNotifications(
      {String timezone = 'Asia/Calcutta'}) async {
    try {
      print('Fetching notifications with timezone: $timezone');
      return await _apiService.getApi(
        url:
            "http://158.101.247.195/pb-process-service/common/getNotifications?timezone=$timezone",
        fromJson: (json) {
          print('Notifications API response received');
          return NotificationModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error fetching notifications: $e');
      return NotificationModel.empty();
    }
  }

  Future<bool> markNotificationAsRead(int notificationId) async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      return true;
    } catch (e) {
      print('Error marking notification as read: $e');
      return false;
    }
  }
}

final notificationRepository = Provider<NotificationRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return NotificationRepository(apiService);
});

final getNotificationsProvider = FutureProvider<NotificationModel>((ref) async {
  final repository = ref.read(notificationRepository);
  final result = await repository.fetchNotifications();
  return result;
});

final markNotificationAsReadProvider =
    FutureProvider.family<bool, int>((ref, notificationId) async {
  final repository = ref.read(notificationRepository);
  final result = await repository.markNotificationAsRead(notificationId);

  if (result) {
    ref.refresh(getNotificationsProvider);
  }

  return result;
});
