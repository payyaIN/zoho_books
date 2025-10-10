// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:payzo_books/data/models/credential_model/login/login_model.dart';
// import 'package:payzo_books/utils/app_data/shared_preference_key.dart';
// import 'package:payzo_books/utils/routing/route_names.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// import '../../../import_data.dart';

// final loginNotifierProvider =
//     StateNotifierProvider<LoginNotifier, AsyncValue<LoginModel?>>((ref) {
//   return LoginNotifier();
// });

// class LoginNotifier extends StateNotifier<AsyncValue<LoginModel?>> {
//   LoginNotifier() : super(const AsyncValue.data(null));

//   Future<void> login(
//     String username,
//     String password,
//     BuildContext? context, {
//     bool skipNavigation = false,
//   }) async {
//     state = const AsyncValue.loading();

//     try {
//       final url =
//           Uri.parse('http://81.208.173.149/pb-auth-service/oauth/token');

//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'TransactionId': 'X7G9L2M5T8Y3P0Q1R6WZ',
//         },
//         body: jsonEncode({
//           "grant_type": "password",
//           "username": username,
//           "password": password,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final loginData = LoginModel.fromJson(data);

//         if (loginData.error == true) {
//           state = AsyncValue.error(
//               loginData.message ?? "Authentication failed", StackTrace.current);

//           if (context != null && context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(loginData.message ?? "Authentication failed"),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//           return;
//         }

//         final prefs = await SharedPreferences.getInstance();

//         await prefs.setString(SharedPreferenceKey.accessToken,
//             loginData.response?.accessToken ?? '');
//         await prefs.setString(SharedPreferenceKey.refreshToken,
//             loginData.response?.refreshToken ?? '');

//         await prefs.setString(SharedPreferenceKey.loginEmail, username);
//         await prefs.setString(SharedPreferenceKey.loginPassword, password);

//         state = AsyncValue.data(loginData);

//         if (context != null && context.mounted && !skipNavigation) {
//           Navigator.pushNamedAndRemoveUntil(
//               context, RouteNames.twostepverification, (route) => false);
//         }
//       } else {
//         String errorMessage = "Login failed";

//         try {
//           final errorData = jsonDecode(response.body);
//           final errorCode = errorData['response']?['errorCode'];
//           final otp = errorData['oneTimePassword'];
//           debugPrint(
//               "🔐 MFA Triggered: Navigating to OTP screen with OTP: $otp");
//           // Handle MFA
//           if (errorCode == "UL401") {
//             if (context != null && context.mounted) {
//               Navigator.pushNamed(
//                 context,
//                 RouteNames.mfaScreen,
//                 arguments: otp ?? '',
//               );
//             }
//             return;
//           }

//           errorMessage =
//               errorData['message'] ?? "Login failed: ${response.statusCode}";
//         } catch (e) {
//           errorMessage = "Login failed: ${response.statusCode}";
//         }

//         state = AsyncValue.error(errorMessage, StackTrace.current);

//         if (context != null && context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(errorMessage),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     } catch (e, stackTrace) {
//       final errorMessage = "Something went wrong: $e";
//       state = AsyncValue.error(errorMessage, stackTrace);

//       if (context != null && context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorMessage),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }
// }

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/credential_model/login/login_model.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/shared_preference_key.dart';
import 'package:payzo_books/utils/routing/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final loginNotifierProvider =
    StateNotifierProvider<LoginNotifier, AsyncValue<LoginModel?>>((ref) {
  return LoginNotifier();
});

class LoginNotifier extends StateNotifier<AsyncValue<LoginModel?>> {
  LoginNotifier() : super(const AsyncValue.data(null));

  /// Check if saved OTP is still valid (within 2 days = 48 hours)
  Future<String?> getValidSavedOtp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedOtp = prefs.getString(SharedPreferenceKey.savedOtp);
      final timestampStr = prefs.getString(SharedPreferenceKey.otpTimestamp);

      if (savedOtp == null || timestampStr == null) {
        debugPrint("⚠️ No saved MFA OTP found");
        return null;
      }

      final timestamp = DateTime.tryParse(timestampStr);
      if (timestamp == null) {
        debugPrint("⚠️ Invalid OTP timestamp");
        return null;
      }

      final now = DateTime.now();
      final hoursDiff = now.difference(timestamp).inHours;

      if (hoursDiff < 48) {
        // 2 days = 48 hours
        final hoursRemaining = 48 - hoursDiff;
        debugPrint("✅ Valid MFA OTP found (expires in $hoursRemaining hours)");
        return savedOtp;
      } else {
        debugPrint(
            "⚠️ MFA OTP expired (${now.difference(timestamp).inDays} days old)");
        await prefs.remove(SharedPreferenceKey.savedOtp);
        await prefs.remove(SharedPreferenceKey.otpTimestamp);
        return null;
      }
    } catch (e) {
      debugPrint("❌ Error checking saved OTP: $e");
      return null;
    }
  }

  /// Save OTP after successful MFA verification
  Future<void> saveOtp(String otp) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(SharedPreferenceKey.savedOtp, otp);
      await prefs.setString(
          SharedPreferenceKey.otpTimestamp, DateTime.now().toIso8601String());
      debugPrint("💾 MFA OTP saved successfully (valid for 2 days)");
    } catch (e) {
      debugPrint("❌ Error saving OTP: $e");
    }
  }

  /// Clear saved OTP (called on logout)
  Future<void> clearSavedOtp() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(SharedPreferenceKey.savedOtp);
      await prefs.remove(SharedPreferenceKey.otpTimestamp);
      debugPrint("🗑️ MFA OTP cleared");
    } catch (e) {
      debugPrint("❌ Error clearing OTP: $e");
    }
  }

  /// Main login method
  Future<void> login(
    String username,
    String password,
    BuildContext? context, {
    String? oneTimePassword, // ✅ Accept OTP parameter
    bool skipNavigation = false,
  }) async {
    state = const AsyncValue.loading();

    try {
      // ✅ CRITICAL DECISION POINT: Check if we need to show 2FA
      if (oneTimePassword == null && context != null && !skipNavigation) {
        final savedOtp = await getValidSavedOtp();

        if (savedOtp == null) {
          // ✅ No valid OTP - Show 2FA screen WITHOUT making API call
          debugPrint("🔐 No valid MFA OTP - Showing 2FA screen");
          state = const AsyncValue.data(null);

          if (context.mounted) {
            Navigator.pushNamed(
              context,
              RouteNames.twostepverification,
              arguments: {
                'username': username,
                'password': password,
              },
            );
          }
          return;
        }

        // ✅ Valid OTP exists - Use it automatically
        oneTimePassword = savedOtp;
        debugPrint("🔐 Using saved MFA OTP for automatic login");
      }

      // ✅ Make API call with OTP (or empty string)
      final url =
          Uri.parse('http://81.208.173.149/pb-auth-service/oauth/token');

      final body = {
        "grant_type": "password",
        "username": username,
        "password": password,
        "oneTimePassword": oneTimePassword ?? "", // ✅ Include OTP
      };

      debugPrint("🔐 Login API Call");
      debugPrint("   Username: $username");
      debugPrint(
          "   OTP included: ${(oneTimePassword?.isNotEmpty ?? false) ? 'Yes' : 'No'}");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'TransactionId': 'X7G9L2M5T8Y3P0Q1R6WZ',
        },
        body: jsonEncode(body),
      );

      debugPrint("🔐 Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final loginData = LoginModel.fromJson(data);

        // Check for API-level errors
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

        // ✅ Login successful - Save credentials
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString(SharedPreferenceKey.accessToken,
            loginData.response?.accessToken ?? '');
        await prefs.setString(SharedPreferenceKey.refreshToken,
            loginData.response?.refreshToken ?? '');
        await prefs.setString(SharedPreferenceKey.loginEmail, username);
        await prefs.setString(SharedPreferenceKey.loginPassword, password);

        // ✅ Save OTP only when user manually entered it (from 2FA screen)
        final currentlySavedOtp = await getValidSavedOtp();
        if (oneTimePassword != null &&
            oneTimePassword.isNotEmpty &&
            oneTimePassword != currentlySavedOtp) {
          await saveOtp(oneTimePassword);
          debugPrint("✅ Login successful - MFA OTP saved for future logins");
        } else if (oneTimePassword != null && oneTimePassword.isNotEmpty) {
          debugPrint("✅ Login successful - Used existing saved OTP");
        }

        state = AsyncValue.data(loginData);

        // ✅ Navigate to HOME (not 2FA screen!)
        if (context != null && context.mounted && !skipNavigation) {
          debugPrint("🏠 Navigating to Home Screen");
          Navigator.pushNamedAndRemoveUntil(
              context, RouteNames.homeScreen, (route) => false);
        }
      } else {
        // ✅ Handle errors (keeping existing MFA error handling for UL401)
        String errorMessage = "Login failed";

        try {
          final errorData = jsonDecode(response.body);
          final errorCode = errorData['response']?['errorCode'];
          final otp = errorData['oneTimePassword'];

          // Handle MFA suspicious login (if your API returns this)
          if (errorCode == "UL401") {
            debugPrint("🔐 MFA Required (UL401): Navigating to MFA screen");
            if (context != null && context.mounted) {
              Navigator.pushNamed(
                context,
                RouteNames.mfaScreen,
                arguments: otp ?? '',
              );
            }
            state = const AsyncValue.data(null);
            return;
          }

          errorMessage =
              errorData['message'] ?? "Login failed: ${response.statusCode}";
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
      debugPrint("❌ Login exception: $errorMessage");
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

//oldd

// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:payzo_books/data/models/credential_model/login/login_model.dart';
// import 'package:payzo_books/utils/app_data/shared_preference_key.dart';
// import 'package:payzo_books/utils/clear_state/clear_app_state.dart';
// import 'package:payzo_books/utils/routing/route_names.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';

// final loginNotifierProvider =
//     StateNotifierProvider<LoginNotifier, AsyncValue<LoginModel?>>((ref) {
//   return LoginNotifier(ref);
// });

// class LoginNotifier extends StateNotifier<AsyncValue<LoginModel?>> {
//   final Ref ref;

//   LoginNotifier(this.ref)
//       : super(const AsyncValue.data(null)); // 🔥 MODIFIED CONSTRUCTOR

//   Future<void> login(
//     String username,
//     String password,
//     BuildContext? context, {
//     bool skipNavigation = false,
//   }) async {
//     state = const AsyncValue.loading();

//     try {
//       final url =
//           Uri.parse('http://158.101.247.195/pb-auth-service/oauth/token');

//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json',
//           'TransactionId': 'X7G9L2M5T8Y3P0Q1R6WZ',
//         },
//         body: jsonEncode({
//           "grant_type": "password",
//           "username": username,
//           "password": password,
//         }),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final loginData = LoginModel.fromJson(data);

//         if (loginData.error == true) {
//           state = AsyncValue.error(
//               loginData.message ?? "Authentication failed", StackTrace.current);

//           if (context != null && context.mounted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(loginData.message ?? "Authentication failed"),
//                 backgroundColor: Colors.red,
//               ),
//             );
//           }
//           return;
//         }

//         final prefs = await SharedPreferences.getInstance();

//         await prefs.setString(SharedPreferenceKey.accessToken,
//             loginData.response?.accessToken ?? '');
//         await prefs.setString(SharedPreferenceKey.refreshToken,
//             loginData.response?.refreshToken ?? '');

//         await prefs.setString(SharedPreferenceKey.loginEmail, username);
//         await prefs.setString(SharedPreferenceKey.loginPassword, password);

//         print(
//             '🔄 Login successful - clearing all cached data for fresh user session...');
//         try {
//           await ProviderInvalidationHelper.invalidateAllProviders(
//               ref as WidgetRef);
//           print(
//               '✅ All providers invalidated after login - user will see fresh data');
//         } catch (e) {
//           print('❌ Error invalidating providers after login: $e');
//           // Continue with login even if invalidation fails
//         }

//         state = AsyncValue.data(loginData);

//         if (context != null && context.mounted && !skipNavigation) {
//           Navigator.pushNamedAndRemoveUntil(
//               context, RouteNames.homeScreen, (route) => false);
//         }
//       } else {
//         String errorMessage = "Login failed";

//         try {
//           final errorData = jsonDecode(response.body);
//           errorMessage =
//               errorData['message'] ?? "Login failed: ${response.statusCode}";
//         } catch (e) {
//           errorMessage = "Login failed: ${response.statusCode}";
//         }

//         state = AsyncValue.error(errorMessage, StackTrace.current);

//         if (context != null && context.mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(errorMessage),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     } catch (e, stackTrace) {
//       final errorMessage = "Something went wrong: $e";
//       state = AsyncValue.error(errorMessage, stackTrace);

//       if (context != null && context.mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(errorMessage),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   /// Helper method to clear providers for token refresh scenarios
//   Future<void> refreshUserSession() async {
//     print('🔄 Refreshing user session - clearing cached data...');
//     try {
//       await ProviderInvalidationHelper.invalidateAllProviders(ref as WidgetRef);
//       print('✅ User session refreshed successfully');
//     } catch (e) {
//       print('❌ Error refreshing user session: $e');
//     }
//   }
// }
