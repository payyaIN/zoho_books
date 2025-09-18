import 'package:payzo_books/data/repository/logout/log_out_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/shared_preference_key.dart';

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

    final logoutRepository = ref.read(logoutRepositoryProvider);
    final logoutResult =
        await logoutRepository.logout(refreshToken: refreshToken);

    print('Logout API result: ${logoutResult.status}');

    await _clearAllCredentials();

    ref.read(authProvider.notifier).setLoggedIn(false);

    if (loadingDialogContext != null && context.mounted) {
      Navigator.of(loadingDialogContext!).pop();
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(logoutResult.response.message.isNotEmpty
            ? logoutResult.response.message
            : "You have been logged out"),
      ),
    );

    Navigator.of(context)
        .pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);
  } catch (e) {
    print("Logout error: ${e.toString()}");

    await _clearAllCredentials();
    ref.read(authProvider.notifier).setLoggedIn(false);

    if (loadingDialogContext != null && context.mounted) {
      Navigator.of(loadingDialogContext!).pop();
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Session expired. You have been logged out."),
        backgroundColor: Colors.orange,
      ),
    );

    Navigator.of(context)
        .pushNamedAndRemoveUntil(RouteNames.loginScreen, (route) => false);
  }
}

Future<void> _clearAllCredentials() async {
  try {
    await SharedPreferencesHelper.remove(SharedPreferenceKey.accessToken);
    await SharedPreferencesHelper.remove(SharedPreferenceKey.refreshToken);
    await SharedPreferencesHelper.remove(SharedPreferenceKey.loginEmail);
    await SharedPreferencesHelper.remove(SharedPreferenceKey.loginPassword);
    print('All credentials cleared successfully');
  } catch (e) {
    print('Error clearing credentials: $e');
  }
}
