import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/two_step_verification/providers/notifiers/two_step_otp_notifier.dart';

class TwoStepVerificationScreen extends ConsumerWidget {
  const TwoStepVerificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otp = ref.watch(twoStepOtpNotifierProvider); // ✅ watch notifier state

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColorGrey,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ReusableColumn(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo
                Center(
                  child: SvgPictureWidget(
                    image: 'assets/payzo-logo (1).svg',
                    height: 36,
                    width: 180,
                  ),
                ),
                const SizedBox(height: 48),

                // Title
                Text(
                  "Two-step Authentication",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.appMainColor,
                    fontFamily: 'SF Pro Display',
                  ),
                ),
                const SizedBox(height: 12),

                // Description
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                      fontFamily: 'SF Pro Display',
                      fontSize: 15,
                      height: 1.5,
                    ),
                    children: const [
                      TextSpan(
                          text:
                          "Enter the 6-digit authentication code we sent to your email: "),
                      TextSpan(
                        text: "nayaxo5331@calorpg.com",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: AppColors.appMainColor,
                          fontFamily: 'SF Pro Display',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // OTP Input fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    6,
                        (index) => SizedBox(
                      width: 48,
                      height: 58,
                      child: TextField(
                        maxLength: 1,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SF Pro Display',
                        ),
                        textInputAction: index < 5
                            ? TextInputAction.next
                            : TextInputAction.done,
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.appMainColor,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          ref
                              .read(twoStepOtpNotifierProvider.notifier)
                              .updateOtp(index, value);

                          if (value.isNotEmpty && index < 5) {
                            FocusScope.of(context).nextFocus();
                          } else if (value.isEmpty && index > 0) {
                            FocusScope.of(context).previousFocus();
                          }
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Resend Code
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("OTP Resent")),
                      );
                    },
                    child: const Text(
                      "Resend Code",
                      style: TextStyle(
                        color: AppColors.appMainColor,
                        decoration: TextDecoration.underline,
                        fontFamily: 'SF Pro Display',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Buttons
                PayzoFormSubmitTwoButtons(
                  cancelText: 'Cancel',
                  saveText: "Verify & Login",
                  cancelOnPressed: () {
                    Navigator.of(context).pop();
                  },
                  saveOnPressed: () async {
                    final otpNotifier =
                    ref.read(twoStepOtpNotifierProvider.notifier);

                    if (otpNotifier.isOtpComplete) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Verifying OTP...")),
                      );

                      await otpNotifier.saveOtp();

                      // Example: Navigate after success
                      // Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter the complete OTP"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
