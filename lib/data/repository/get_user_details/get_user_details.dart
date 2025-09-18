import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/get_user_details/get_user_details.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class GetUserDetailsRepo {
  final BaseApiService apiService;
  GetUserDetailsRepo(this.apiService);

  Future<GetUserDetails> fetchAccountList() {
    return apiService.getApi(
      url: 'http://158.101.247.195/pb-common-service/api/common/getUserDetails',
      fromJson: (json) => GetUserDetails.fromJson(json),
    );
  }
}

final getUserDetailsProvider = Provider<GetUserDetailsRepo>((ref) {
  return GetUserDetailsRepo(ref.read(apiServiceProvider));
});

final fetchUserDetails = FutureProvider<GetUserDetails>((ref) {
  return ref.read(getUserDetailsProvider).fetchAccountList();
});
