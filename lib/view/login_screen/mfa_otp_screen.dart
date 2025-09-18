import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/utils/common_widgets/reusable_text.dart';
import 'package:payzo_books/view/login_screen/notifier/mfa_notifier.dart';

class MfaOtpScreen extends ConsumerStatefulWidget {
  const MfaOtpScreen({super.key});

  @override
  ConsumerState<MfaOtpScreen> createState() => _MfaOtpScreenState();
}

class _MfaOtpScreenState extends ConsumerState<MfaOtpScreen> {
  String _otpCode = '';

  final String _email = 'sixaja5475@frisbook.com'; // You can get this from route args or cache
  final String _password = 'Maxint@123'; // For demo purposes only

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(mfaLoginProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            const Text(
              'Suspicious Login Detected',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            const Text(
              'An OTP has been sent to your registered email. Please enter it below to continue.',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFECEAFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Enter One-Time Password',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  OtpTextField(
                    numberOfFields: 6,
                    fieldWidth: 42,
                    borderRadius: BorderRadius.circular(8),
                    showFieldAsBox: true,
                    borderColor: const Color(0xFF6B46C1),
                    focusedBorderColor: const Color(0xFF6B46C1),
                    onCodeChanged: (_) {},
                    onSubmit: (code) {
                      setState(() => _otpCode = code);
                    },
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6B46C1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  if (_otpCode.length == 6) {
                    ref.read(mfaLoginProvider.notifier).submitOtpLogin(
                      email: _email,
                      password: _password,
                      otp: _otpCode,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter the complete 6-digit OTP'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                child: loginState.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const ReusableText(
                  text: 'Continue',
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (loginState.hasError)
              Text(
                loginState.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
