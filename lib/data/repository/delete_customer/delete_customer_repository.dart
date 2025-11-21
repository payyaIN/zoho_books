import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/data/models/base_api_response.dart';
import '../../../import_data.dart';

class DeleteCustomerRepository {
  final Ref ref;

  DeleteCustomerRepository(this.ref);

  Future<BaseApiResponse> deleteCustomer({required int partyId}) async {
    final url = 'http://81.208.173.149/pb-process-service/api/process/party/$partyId/status?status=0';

    return await ref.read(apiServiceProvider).patchApi<BaseApiResponse>(
      url: url,
      body: {},
      fromJson: (json) => BaseApiResponse.fromJson(json),
    );
  }
}

final deleteCustomerRepoProvider = Provider<DeleteCustomerRepository>((ref) {
  return DeleteCustomerRepository(ref);
});
