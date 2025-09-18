import 'package:payzo_books/data/models/notification_model/approve_notification.dart';
import 'package:payzo_books/import_data.dart';

class ApproveNotificationNotifier extends StateNotifier<ApproveModel?> {
  ApproveNotificationNotifier() : super(null);

  void setApproveNotification(ApproveModel approveModel) {
    state = approveModel;
  }

  void clearApproveNotification() {
    state = null;
  }
}

final approveNotificationStateProvider =
    StateNotifierProvider<ApproveNotificationNotifier, ApproveModel?>((ref) {
  return ApproveNotificationNotifier();
});
