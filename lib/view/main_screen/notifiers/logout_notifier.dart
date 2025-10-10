// import 'package:payzo_books/data/repository/logout/log_out_api.dart';
// import 'package:payzo_books/import_data.dart';
// import 'package:payzo_books/utils/app_data/shared_preference_key.dart';

// class AuthNotifier extends StateNotifier<bool> {
//   AuthNotifier() : super(false);

//   void setLoggedIn(bool value) {
//     state = value;
//   }

//   bool get isLoggedIn => state;
// }

// final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
//   return AuthNotifier();
// });

// Future<void> performLogout(BuildContext context, WidgetRef ref) async {
//   final bool shouldLogout = await showDialog<bool>(
//         context: context,
//         builder: (dialogContext) => AlertDialog(
//           title: const Text('Logout'),
//           content: const Text('Are you sure you want to logout?'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(false),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(true),
//               child: const Text('Logout', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         ),
//       ) ??
//       false;

//   if (!shouldLogout) return;

//   if (!context.mounted) return;

//   BuildContext? loadingDialogContext;

//   showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (dialogContext) {
//       loadingDialogContext = dialogContext;
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     },
//   );

//   try {
//     final refreshToken =
//         SharedPreferencesHelper.getString(SharedPreferenceKey.refreshToken) ??
//             '';
//     print(
//         'Found refresh token for logout: ${refreshToken.isNotEmpty ? 'yes' : 'no'}');

//     final logoutRepository = ref.read(logoutRepositoryProvider);
//     final logoutResult =
//         await logoutRepository.logout(refreshToken: refreshToken);

//     print('Logout API result: ${logoutResult.status}');

//     await _clearAllCredentials();

//     ref.read(authProvider.notifier).setLoggedIn(false);

//     if (loadingDialogContext != null && context.mounted) {
//       Navigator.of(loadingDialogContext!).pop();
//     }

//     if (!context.mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(logoutResult.response.message.isNotEmpty
//             ? logoutResult.response.message
//             : "You have been logged out"),
//       ),
//     );

//     Navigator.of(context)
//         .pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);
//   } catch (e) {
//     print("Logout error: ${e.toString()}");

//     await _clearAllCredentials();
//     ref.read(authProvider.notifier).setLoggedIn(false);

//     if (loadingDialogContext != null && context.mounted) {
//       Navigator.of(loadingDialogContext!).pop();
//     }

//     if (!context.mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Session expired. You have been logged out."),
//         backgroundColor: Colors.orange,
//       ),
//     );

//     Navigator.of(context)
//         .pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);
//   }
// }

// Future<void> _clearAllCredentials() async {
//   try {
//     await SharedPreferencesHelper.remove(SharedPreferenceKey.accessToken);
//     await SharedPreferencesHelper.remove(SharedPreferenceKey.refreshToken);
//     await SharedPreferencesHelper.remove(SharedPreferenceKey.loginEmail);
//     await SharedPreferencesHelper.remove(SharedPreferenceKey.loginPassword);
//     print('All credentials cleared successfully');
//   } catch (e) {
//     print('Error clearing credentials: $e');
//   }
// }

import 'package:payzo_books/data/repository/logout/log_out_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/shared_preference_key.dart';
import 'package:payzo_books/utils/clear_state/clear_app_state.dart';

class AuthNotifier extends StateNotifier<bool> {
  AuthNotifier() : super(false);

  void setLoggedIn(bool value) {
    state = value;
  }

  bool get isLoggedIn => state;
}

final authProvider = StateNotifierProvider<AuthNotifier, bool>((ref) {
  return AuthNotifier();
});

Future<void> performLogout(BuildContext context, WidgetRef ref) async {
  final bool shouldLogout = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ) ??
      false;

  if (!shouldLogout) return;

  if (!context.mounted) return;

  BuildContext? loadingDialogContext;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      loadingDialogContext = dialogContext;
      return const Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  try {
    final refreshToken =
        SharedPreferencesHelper.getString(SharedPreferenceKey.refreshToken) ??
            '';
    print(
        'Found refresh token for logout: ${refreshToken.isNotEmpty ? 'yes' : 'no'}');

    // Call logout API
    final logoutRepository = ref.read(logoutRepositoryProvider);
    final logoutResult =
        await logoutRepository.logout(refreshToken: refreshToken);

    print('Logout API result: ${logoutResult.status}');

    // Clear all credentials from SharedPreferences
    await _clearAllCredentials();

    print('🔄 Invalidating all providers to prevent old data...');
    await ProviderInvalidationHelper.invalidateAllProviders(ref);
    print('✅ All providers invalidated successfully');

    // Update auth state AFTER clearing everything
    ref.read(authProvider.notifier).setLoggedIn(false);

    // Close loading dialog
    if (loadingDialogContext != null && context.mounted) {
      Navigator.of(loadingDialogContext!).pop();
    }

    if (!context.mounted) return;

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(logoutResult.response.message.isNotEmpty
            ? logoutResult.response.message
            : "You have been logged out successfully"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );

    // Navigate to login screen and clear all previous routes
    Navigator.of(context)
        .pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);
  } catch (e) {
    print("Logout error: ${e.toString()}");

    // Even on error, clear credentials and invalidate providers
    await _clearAllCredentials();

    // 🔥 CRITICAL: Invalidate providers even on error to prevent data leakage
    try {
      await ProviderInvalidationHelper.invalidateAllProviders(ref);
      print('✅ Providers invalidated after logout error');
    } catch (invalidationError) {
      print('❌ Error invalidating providers: $invalidationError');
      // Continue with logout even if invalidation fails
    }

    ref.read(authProvider.notifier).setLoggedIn(false);

    // Close loading dialog
    if (loadingDialogContext != null && context.mounted) {
      Navigator.of(loadingDialogContext!).pop();
    }

    if (!context.mounted) return;

    // Show error message but still logout locally
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Session expired. You have been logged out."),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate to login screen even on error
    Navigator.of(context)
        .pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);
  }
}

/// Clears all stored credentials from SharedPreferences
Future<void> _clearAllCredentials() async {
  try {
    print('🔄 Clearing all credentials...');

    await Future.wait([
      SharedPreferencesHelper.remove(SharedPreferenceKey.accessToken),
      SharedPreferencesHelper.remove(SharedPreferenceKey.refreshToken),
      SharedPreferencesHelper.remove(SharedPreferenceKey.loginEmail),
      SharedPreferencesHelper.remove(SharedPreferenceKey.loginPassword),
    ]);

    print('✅ All credentials cleared successfully');
  } catch (e) {
    print('❌ Error clearing credentials: $e');
    rethrow;
  }
}

/// Alternative logout method for emergency/force logout scenarios
///
/// Use this when you need to logout without showing dialogs (e.g., token expired)
Future<void> forceLogout(BuildContext context, WidgetRef ref,
    {String? reason}) async {
  try {
    print('🚨 Force logout initiated. Reason: ${reason ?? "Not specified"}');

    // Clear credentials
    await _clearAllCredentials();

    // Invalidate all providers
    await ProviderInvalidationHelper.invalidateAllProviders(ref);

    // Update auth state
    ref.read(authProvider.notifier).setLoggedIn(false);

    if (!context.mounted) return;

    // Show reason if provided
    if (reason != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(reason),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }

    // Navigate to login
    Navigator.of(context)
        .pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);

    print('✅ Force logout completed');
  } catch (e) {
    print('❌ Error during force logout: $e');
    // Still navigate to login even on error
    if (context.mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);
    }
  }
}
