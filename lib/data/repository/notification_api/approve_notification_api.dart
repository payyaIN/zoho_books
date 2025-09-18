import 'package:payzo_books/data/models/notification_model/approve_notification.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class ApproveNotificationRepository {
  final BaseApiService _apiService;
  ApproveNotificationRepository(this._apiService);

  Future<ApproveModel> approveNotification({
    required int typeId,
    required int processId,
  }) async {
    try {
      print(
          'Approving notification for typeId: $typeId, processId: $processId');
      return await _apiService.getApi(
        url:
            "http://158.101.247.195/pb-process-service/rfq/verifyWF?typeId=$typeId&processId=$processId",
        fromJson: (json) {
          print('Approve Notification API response received');
          return ApproveModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error approving notification: $e');
      return ApproveModel.empty();
    }
  }
}

final approveNotificationRepository =
    Provider<ApproveNotificationRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return ApproveNotificationRepository(apiService);
});

final approveNotificationProvider =
    FutureProvider.family<ApproveModel, ApproveNotificationParams>(
        (ref, params) async {
  print('approveNotificationProvider called');
  final repository = ref.read(approveNotificationRepository);
  final result = await repository.approveNotification(
    typeId: params.typeId,
    processId: params.processId,
  );
  print('Approve notification result: ${result.code}');
  return result;
});

class ApproveNotificationParams {
  final int typeId;
  final int processId;

  ApproveNotificationParams({
    required this.typeId,
    required this.processId,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApproveNotificationParams &&
        other.typeId == typeId &&
        other.processId == processId;
  }

  @override
  int get hashCode => typeId.hashCode ^ processId.hashCode;
}
