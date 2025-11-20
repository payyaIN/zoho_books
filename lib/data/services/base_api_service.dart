import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;
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
    if (sharedPrefs == null)
      throw Exception('SharedPreferences not initialized');

    final token =
        SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);

    // ✅ Encode files
    final encodedFiles = await Future.wait(files.map((file) async {
      final bytes = await file.readAsBytes();
      return {
        'name': file.path.split('/').last,
        'encodedFile': base64Encode(bytes),
        'fileType':
            'image/jpeg', // Optional, you can skip this if backend doesn't need it
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

  Future<T> deleteApi<T>({
    required String url,
    required T Function(Map<String, dynamic>) fromJson,
    bool retryingAfterLogin = false,
  }) async {
    final headers = await _getHeaders();
    final response = await http.delete(Uri.parse(url), headers: headers);

    print('DELETE API Response Status Code: ${response.statusCode}');
    print('DELETE API Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 204) {
      if (response.body.isEmpty) {
        return fromJson({'success': true, 'message': 'Deleted successfully'});
      }
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
          return deleteApi(
            url: url,
            fromJson: fromJson,
            retryingAfterLogin: true,
          );
        }
      }

      throw Exception('Unauthorized. Login failed.');
    } else {
      throw Exception(
          'DELETE API call failed with status code: ${response.statusCode}');
    }
  }

  /// POST Multipart with File and JSON (for expense update)
  Future<T> postMultipartWithFileAndJson<T>({
    required String url,
    required Map<String, dynamic> jsonData,
    File? file,
    required T Function(Map<String, dynamic>) fromJson,
    bool retryingAfterLogin = false,
  }) async {
    final sharedPrefs = ref.read(sharedPreferencesProvider);
    if (sharedPrefs == null)
      throw Exception('SharedPreferences not initialized');

    final token =
        SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);

    final uri = Uri.parse(url);
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer ${token ?? ''}',
      'TransactionId': 'djadajadjafjdbfsjkdb',
      'company-id': '1',
    });

    // Add JSON data as blob
    request.files.add(
      http.MultipartFile.fromString(
        'data',
        jsonEncode(jsonData),
        contentType: http_parser.MediaType('application', 'json'),
        filename: 'blob',
      ),
    );

    // Add file if provided
    if (file != null && await file.exists()) {
      final ext = file.path.split('.').last.toLowerCase();
      final contentType = ext == 'pdf'
          ? http_parser.MediaType('application', 'pdf')
          : http_parser.MediaType('image', 'jpeg');

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: contentType,
        ),
      );
    }

    print('📤 POST Multipart Request Headers: ${request.headers}');
    print('📤 POST Multipart JSON Data: ${jsonEncode(jsonData)}');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('📥 Response Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

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
          return postMultipartWithFileAndJson(
            url: url,
            jsonData: jsonData,
            file: file,
            fromJson: fromJson,
            retryingAfterLogin: true,
          );
        }
      }

      throw Exception('Unauthorized. Login failed.');
    } else {
      throw Exception(
          'POST Multipart API call failed with status code: ${response.statusCode}');
    }
  }

  /// POST Multipart File (for import/export)
  Future<T> postMultipartFile<T>({
    required String url,
    required File file,
    String fileFieldName = 'file',
    Map<String, String>? additionalFields,
    required T Function(Map<String, dynamic>) fromJson,
    bool retryingAfterLogin = false,
  }) async {
    final sharedPrefs = ref.read(sharedPreferencesProvider);
    if (sharedPrefs == null)
      throw Exception('SharedPreferences not initialized');

    final token =
        SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);

    final uri = Uri.parse(url);
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer ${token ?? ''}',
      'TransactionId': 'djadajadjafjdbfsjkdb',
      'company-id': '1',
    });

    // Add file
    if (await file.exists()) {
      final ext = file.path.split('.').last.toLowerCase();
      final contentType = ext == 'xlsx'
          ? http_parser.MediaType('application',
              'vnd.openxmlformats-officedocument.spreadsheetml.sheet')
          : http_parser.MediaType('application', 'octet-stream');

      request.files.add(
        await http.MultipartFile.fromPath(
          fileFieldName,
          file.path,
          contentType: contentType,
        ),
      );
    }

    // Add additional fields
    if (additionalFields != null) {
      request.fields.addAll(additionalFields);
    }

    print('📤 POST Multipart File Request Headers: ${request.headers}');
    print('📤 POST Multipart File Fields: ${request.fields}');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('📥 Response Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

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
          return postMultipartFile(
            url: url,
            file: file,
            fileFieldName: fileFieldName,
            additionalFields: additionalFields,
            fromJson: fromJson,
            retryingAfterLogin: true,
          );
        }
      }

      throw Exception('Unauthorized. Login failed.');
    } else {
      throw Exception(
          'POST Multipart File API call failed with status code: ${response.statusCode}');
    }
  }

  /// POST Multipart with Blob JSON (for import with config and mapping)
  Future<T> postMultipartWithBlobJson<T>({
    required String url,
    required File file,
    required Map<String, dynamic> config,
    required Map<String, dynamic> mapping,
    required T Function(Map<String, dynamic>) fromJson,
    bool retryingAfterLogin = false,
  }) async {
    final sharedPrefs = ref.read(sharedPreferencesProvider);
    if (sharedPrefs == null)
      throw Exception('SharedPreferences not initialized');

    final token =
        SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);

    final uri = Uri.parse(url);
    final request = http.MultipartRequest('POST', uri);

    request.headers.addAll({
      'Authorization': 'Bearer ${token ?? ''}',
      'TransactionId': 'djadajadjafjdbfsjkdb',
      'company-id': '1',
    });

    // Add config as blob JSON
    request.files.add(
      http.MultipartFile.fromString(
        'config',
        jsonEncode(config),
        contentType: http_parser.MediaType('application', 'json'),
        filename: 'blob',
      ),
    );

    // Add mapping as blob JSON
    request.files.add(
      http.MultipartFile.fromString(
        'mapping',
        jsonEncode(mapping),
        contentType: http_parser.MediaType('application', 'json'),
        filename: 'blob',
      ),
    );

    // Add file
    if (await file.exists()) {
      final ext = file.path.split('.').last.toLowerCase();
      final contentType = ext == 'xlsx'
          ? http_parser.MediaType('application',
              'vnd.openxmlformats-officedocument.spreadsheetml.sheet')
          : http_parser.MediaType('application', 'octet-stream');

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: contentType,
        ),
      );
    }

    print(
        '📤 POST Multipart with Blob JSON Request Headers: ${request.headers}');
    print('📤 Config: ${jsonEncode(config)}');
    print('📤 Mapping: ${jsonEncode(mapping)}');

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    print('📥 Response Status Code: ${response.statusCode}');
    print('📥 Response Body: ${response.body}');

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
          return postMultipartWithBlobJson(
            url: url,
            file: file,
            config: config,
            mapping: mapping,
            fromJson: fromJson,
            retryingAfterLogin: true,
          );
        }
      }

      throw Exception('Unauthorized. Login failed.');
    } else {
      throw Exception(
          'POST Multipart with Blob JSON API call failed with status code: ${response.statusCode}');
    }
  }
}

final apiServiceProvider = Provider<BaseApiService>((ref) {
  return BaseApiService(ref);
});
