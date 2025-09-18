import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/credential_model/login/login_model.dart';
import 'package:payzo_books/utils/app_data/shared_preference_key.dart';
import 'package:payzo_books/utils/routing/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../import_data.dart';

final loginNotifierProvider =
    StateNotifierProvider<LoginNotifier, AsyncValue<LoginModel?>>((ref) {
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<AsyncValue<LoginModel?>> {
  LoginNotifier() : super(const AsyncValue.data(null));

  Future<void> login(
    String username,
    String password,
    BuildContext? context, {
    bool skipNavigation = false,
  }) async {
    state = const AsyncValue.loading();

    try {
      final url =
          Uri.parse('http://158.101.247.195/pb-auth-service/oauth/token');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'TransactionId': 'X7G9L2M5T8Y3P0Q1R6WZ',
        },
        body: jsonEncode({
          "grant_type": "password",
          "username": username,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final loginData = LoginModel.fromJson(data);

        if (loginData.error == true) {
          state = AsyncValue.error(
              loginData.message ?? "Authentication failed", StackTrace.current);

          if (context != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loginData.message ?? "Authentication failed"),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(SharedPreferenceKey.accessToken,
            loginData.response?.accessToken ?? '');
        await prefs.setString(SharedPreferenceKey.refreshToken,
            loginData.response?.refreshToken ?? '');

        await prefs.setString(SharedPreferenceKey.loginEmail, username);
        await prefs.setString(SharedPreferenceKey.loginPassword, password);

        state = AsyncValue.data(loginData);

        if (context != null && context.mounted && !skipNavigation) {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.homeScreen, (route) => false);
        }
      } else {
        String errorMessage = "Login failed";

        try {
          final errorData = jsonDecode(response.body);
          final errorCode = errorData['response']?['errorCode'];
          final otp = errorData['oneTimePassword'];
          debugPrint("🔐 MFA Triggered: Navigating to OTP screen with OTP: $otp");
          // Handle MFA
          if (errorCode == "UL401") {
            if (context != null && context.mounted) {
              Navigator.pushNamed(
                context,
                RouteNames.mfaScreen,
                arguments: otp ?? '',
              );
            }
            return;
          }

          errorMessage = errorData['message'] ?? "Login failed: ${response.statusCode}";
        } catch (e) {
          errorMessage = "Login failed: ${response.statusCode}";
        }

        state = AsyncValue.error(errorMessage, StackTrace.current);

        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e, stackTrace) {
      final errorMessage = "Something went wrong: $e";
      state = AsyncValue.error(errorMessage, stackTrace);

      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
