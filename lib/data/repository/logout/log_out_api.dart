import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/credential_model/log_out/log_out_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/utils/app_data/shared_preference_key.dart';
import 'package:payzo_books/data/services/shared_preference_service.dart';

class LogoutRepository {
  final BaseApiService _apiService;
  LogoutRepository(this._apiService);

  Future<LogoutModel> logout({String refreshToken = ''}) async {
    try {
      print(
          'Calling logout API with refresh token: ${refreshToken.isNotEmpty ? 'Present' : 'Empty'}');

      if (refreshToken.isEmpty) {
        print('No refresh token available, returning local success');
        return LogoutModel(
          error: false,
          message: null,
          response: LogoutResponse(
            code: "Success",
            message: "Logged out successfully from device.",
          ),
          status: true,
        );
      }

      final Map<String, dynamic> body = {"refreshToken": refreshToken};
      print('Logout request body: $body');

      final result = await _apiService.postApi(
        url: "http://81.208.173.149/pb-auth-service/oauth/token/logout",
        body: body,
        fromJson: (json) {
          print('Logout API response received: $json');
          return LogoutModel.fromMap(json);
        },
      );

      print('Logout API call completed successfully');
      return result;
    } catch (e) {
      print('Error during logout API call: $e');
      return LogoutModel(
        error: false,
        message: null,
        response: LogoutResponse(
          code: "Success",
          message: "Logged out successfully from device.",
        ),
        status: true,
      );
    }
  }
}

final logoutRepositoryProvider = Provider<LogoutRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return LogoutRepository(apiService);
});

final logoutProvider = FutureProvider<LogoutModel>((ref) async {
  print('logoutProvider called');
  final repository = ref.read(logoutRepositoryProvider);

  final refreshToken =
      SharedPreferencesHelper.getString(SharedPreferenceKey.refreshToken) ?? '';
  print(
      'Getting refresh token for logout: ${refreshToken.isNotEmpty ? 'found' : 'not found'}');

  final result = await repository.logout(refreshToken: refreshToken);

  await SharedPreferencesHelper.remove(SharedPreferenceKey.accessToken);
  await SharedPreferencesHelper.remove(SharedPreferenceKey.refreshToken);
  await SharedPreferencesHelper.remove(SharedPreferenceKey.loginEmail);
  await SharedPreferencesHelper.remove(SharedPreferenceKey.loginPassword);
  print('All credentials cleared after logout');

  print('Logout completed with status: ${result.status}');
  return result;
});
