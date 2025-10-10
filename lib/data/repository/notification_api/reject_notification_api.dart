import 'package:payzo_books/data/models/notification_model/reject_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class RejectNotificationRepository {
  final BaseApiService _apiService;
  RejectNotificationRepository(this._apiService);

  Future<RejectModel> rejectNotification({
    required int typeId,
    required int processId,
    required String reason,
  }) async {
    try {
      print(
          'Rejecting notification for typeId: $typeId, processId: $processId');

      final encodedReason = Uri.encodeComponent(reason);

      return await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-process-service/rfq/rejectWF?processId=$processId&reason=$encodedReason&typeId=$typeId",
        fromJson: (json) {
          print('Reject Notification API response received');
          return RejectModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error rejecting notification: $e');
      return RejectModel.empty();
    }
  }
}

final rejectNotificationRepository =
    Provider<RejectNotificationRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return RejectNotificationRepository(apiService);
});

final rejectNotificationProvider =
    FutureProvider.family<RejectModel, RejectNotificationParams>(
        (ref, params) async {
  print('rejectNotificationProvider called');
  final repository = ref.read(rejectNotificationRepository);
  final result = await repository.rejectNotification(
    typeId: params.typeId,
    processId: params.processId,
    reason: params.reason,
  );
  print('Reject notification result: ${result.code}');
  return result;
});

class RejectNotificationParams {
  final int typeId;
  final int processId;
  final String reason;

  RejectNotificationParams({
    required this.typeId,
    required this.processId,
    required this.reason,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is RejectNotificationParams &&
        other.typeId == typeId &&
        other.processId == processId &&
        other.reason == reason;
  }

  @override
  int get hashCode => typeId.hashCode ^ processId.hashCode ^ reason.hashCode;
}
