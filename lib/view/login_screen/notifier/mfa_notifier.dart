import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../import_data.dart';

final mfaLoginProvider = StateNotifierProvider<MfaLoginNotifier, AsyncValue<String>>(
      (ref) => MfaLoginNotifier(),
);

class MfaLoginNotifier extends StateNotifier<AsyncValue<String>> {
  MfaLoginNotifier() : super(const AsyncValue.data(''));

  Future<void> submitOtpLogin({
    required String email,
    required String password,
    required String otp,
  }) async {
    state = const AsyncValue.loading();

    try {
      final response = await http.post(
        Uri.parse("http://158.101.247.195/pb-auth-service/oauth/token"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "grant_type": "password",
          "username": email,
          "password": password,
          "oneTimePassword": otp,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['response']?['accessToken'];
        state = AsyncValue.data(accessToken ?? '');
      } else {
        final error = jsonDecode(response.body);
        throw error['message'] ?? 'OTP verification failed';
      }
    } catch (e, st) {
      state = AsyncValue.error(e.toString(), st);
    }
  }
}
