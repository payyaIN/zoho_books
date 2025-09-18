import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/utils/app_data/shared_preference_key.dart';
import 'package:payzo_books/data/services/shared_preference_service.dart';
import 'package:payzo_books/view/main_screen/notifiers/login_notifier.dart';

class BaseApiService {
  final Ref ref;

  BaseApiService(this.ref);

  Future<Map<String, String>> _getHeaders() async {
    final sharedPrefs = ref.read(sharedPreferencesProvider);
    if (sharedPrefs == null) {
      throw Exception('SharedPreferences not initialized');
    }

    String? accessToken =
        SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);

    print('Access Token: $accessToken');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken ?? ''}',
      'TransactionId': 'djadajadjafjdbfsjkdb',
      'company-id': '1',
    };
  }

  Future<Map<String, String>> _getHeaders2() async {
    final sharedPrefs = ref.read(sharedPreferencesProvider);
    if (sharedPrefs == null) {
      throw Exception('SharedPreferences not initialized');
    }

    String? accessToken =
        SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);

    print('Access Token: $accessToken');

    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken ?? ''}',
    };
  }

  Future<List<T>> getListApi<T>({
    required String url,
    required T Function(Map<String, dynamic>) fromJson,
    bool retryingAfterLogin = false,
  }) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final jsonList = jsonDecode(response.body);

      if (jsonList is List) {
        return jsonList.map<T>((item) => fromJson(item)).toList();
      } else {
        throw Exception('Expected a list but got ${jsonList.runtimeType}');
      }
    } else if (response.statusCode == 401 && !retryingAfterLogin) {
      final name =
          SharedPreferencesHelper.getString(SharedPreferenceKey.loginEmail);
      final password =
          SharedPreferencesHelper.getString(SharedPreferenceKey.loginPassword);

      if (name != null && password != null) {
        await ref.read(loginNotifierProvider.notifier).login(
              name,
              password,
              null,
              skipNavigation: true,
            );

        final newAccessToken =
            SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);
        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          return getListApi(
            url: url,
            fromJson: fromJson,
            retryingAfterLogin: true,
          );
        }
      }

      throw Exception('Unauthorized. Login failed.');
    } else {
      throw Exception(
          'GET List API call failed with status code: ${response.statusCode}');
    }
  }

  Future<T> getApi<T>({
    required String url,
    required T Function(Map<String, dynamic>) fromJson,
    bool retryingAfterLogin = false,
  }) async {
    final headers = await _getHeaders();
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401 && !retryingAfterLogin) {
      final name =
          SharedPreferencesHelper.getString(SharedPreferenceKey.loginEmail);
      final password =
          SharedPreferencesHelper.getString(SharedPreferenceKey.loginPassword);

      if (name != null && password != null) {
        await ref.read(loginNotifierProvider.notifier).login(
              name,
              password,
              null,
              skipNavigation: true,
            );

        final newAccessToken =
            SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);
        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          return getApi(
            url: url,
            fromJson: fromJson,
            retryingAfterLogin: true,
          );
        }
      }

      throw Exception('Unauthorized. Login failed.');
    } else {
      throw Exception(
          'API call failed with status code: ${response.statusCode}');
    }
  }

  Future<T> postApi<T>({
    required String url,
    required Map<String, dynamic> body,
    required T Function(Map<String, dynamic>) fromJson,
    bool retryingAfterLogin = false,
  }) async {
    final headers = await _getHeaders();
    print('POST API Request Headers: $headers');

    final response = await http.post(Uri.parse(url),
        headers: headers, body: jsonEncode(body));

    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401 && !retryingAfterLogin) {
      final name =
          SharedPreferencesHelper.getString(SharedPreferenceKey.loginEmail);
      final password =
          SharedPreferencesHelper.getString(SharedPreferenceKey.loginPassword);

      if (name != null && password != null) {
        await ref.read(loginNotifierProvider.notifier).login(
              name,
              password,
              null,
              skipNavigation: true,
            );

        final newAccessToken =
            SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);
        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          return postApi(
            url: url,
            body: body,
            fromJson: fromJson,
            retryingAfterLogin: true,
          );
        }
      }
      throw Exception('Unauthorized. Login failed.');
    } else {
      throw Exception(
          'POST API call failed with status code: ${response.statusCode}');
    }
  }

  Future<T> postFileAsJson<T>({
    required String url,
    required Map<String, dynamic> body,
    required List<File> files,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    final sharedPrefs = ref.read(sharedPreferencesProvider);
    if (sharedPrefs == null) throw Exception('SharedPreferences not initialized');

    final token = SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);

    // ✅ Encode files
    final encodedFiles = await Future.wait(files.map((file) async {
      final bytes = await file.readAsBytes();
      return {
        'name': file.path.split('/').last,
        'encodedFile': base64Encode(bytes),
        'fileType': 'image/jpeg', // Optional, you can skip this if backend doesn't need it
      };
    }));

    final payload = {
      ...body,
      'file': encodedFiles,
    };

    print('📦 JSON Payload: $payload');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        'TransactionId': 'auto-gen-tx-id',
        'company-id': '1',
      },
      body: jsonEncode(payload),
    );

    print('📨 Response (${response.statusCode}): ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      return fromJson(jsonDecode(response.body));
    } else {
      throw Exception('❌ POST failed with status ${response.statusCode}');
    }
  }

}

final apiServiceProvider = Provider<BaseApiService>((ref) {
  return BaseApiService(ref);
});
