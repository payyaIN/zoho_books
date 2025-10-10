import 'package:payzo_books/import_data.dart';
// Notifier for handling OTP
class TwoStepOtpNotifier extends StateNotifier<String> {
  TwoStepOtpNotifier() : super('');

  // Update OTP field
  void updateOtp(int index, String value) {
    final currentOtp = state.padRight(6, ' ');
    final updatedOtp = currentOtp.replaceRange(
      index,
      index + 1,
      value.isEmpty ? ' ' : value,
    );
    state = updatedOtp;
  }

  // Check if OTP is complete
  bool get isOtpComplete => state.replaceAll(' ', '').length == 6;

  // Save OTP (extend this to call API)
  Future<void> saveOtp() async {
    print("✅ Saved OTP: ${state.replaceAll(' ', '')}");
  }
}

// ✅ Only this provider
final twoStepOtpNotifierProvider =
StateNotifierProvider<TwoStepOtpNotifier, String>((ref) {
  return TwoStepOtpNotifier();
});
