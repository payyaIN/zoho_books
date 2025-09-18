import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/utils/app_data/shared_preference_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../import_data.dart';

class AuthNotifier extends
StateNotifier<bool?> {
  AuthNotifier() : super(null) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(SharedPreferenceKey.accessToken);
    state = token != null;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, bool?>((ref) {
  return AuthNotifier();
});
