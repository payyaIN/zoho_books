import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/reusable_textform_field.dart';
import 'package:payzo_books/utils/common_widgets/text_field_validation.dart';
import 'package:payzo_books/view/login_screen/components/img_header.dart';
import 'package:payzo_books/view/login_screen/components/login_fields.dart';
import 'package:payzo_books/view/login_screen/components/text_header.dart';
import 'package:payzo_books/view/main_screen/notifiers/bottom_nav_bar_notifier.dart';
import 'package:payzo_books/view/main_screen/notifiers/login_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginNotifierProvider);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              loginImageHeader(),
              textHeader(),
              LoginFields(
                formKey: _formKey,
                controller1: emailController,
                controller2: passwordController,
              ),
              if (loginState is AsyncError)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    loginState.error.toString(),
                    style: const TextStyle(color: Colors.red, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ElevatedButton(
                  onPressed: loginState is AsyncLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            ref.read(loginNotifierProvider.notifier).login(
                                emailController.text,
                                passwordController.text,
                                context);
                            ref.watch(bottomNavBarProvider.notifier).state = 0;
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 46),
                    backgroundColor: AppColors.appMainColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: loginState is AsyncLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : ReusableText(
                          text: AppText.login,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: AppColors.btnTextColor,
                          fontFamily: 'SF Pro Display',
                        ),
                ),
              ),
              GapSpace.height50,
            ],
          ),
        ),
      ),
    );
  }
}
