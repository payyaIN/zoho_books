import 'package:payzo_books/data/models/notification_model/reject_model.dart';
import 'package:payzo_books/import_data.dart';

class RejectNotificationNotifier extends StateNotifier<RejectModel?> {
  RejectNotificationNotifier() : super(null);

  void setRejectNotification(RejectModel rejectModel) {
    state = rejectModel;
  }

  void clearRejectNotification() {
    state = null;
  }
}

final rejectNotificationStateProvider =
    StateNotifierProvider<RejectNotificationNotifier, RejectModel?>((ref) {
  return RejectNotificationNotifier();
});

final rejectionReasonProvider = StateProvider<String>((ref) => '');

final rejectionStatusProvider = StateProvider<bool>((ref) => false);

final rejectionErrorProvider = StateProvider<String?>((ref) => null);
