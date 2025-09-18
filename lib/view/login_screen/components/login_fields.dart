import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/reusable_textform_field.dart';
import 'package:payzo_books/utils/common_widgets/text_field_validation.dart';
import 'package:payzo_books/view/login_screen/components/login_field_parts.dart';

class LoginFields extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller1;
  final TextEditingController controller2;

  const LoginFields({
    Key? key,
    required this.formKey,
    required this.controller1,
    required this.controller2,
  }) : super(key: key);

  @override
  State<LoginFields> createState() => _LoginFieldsState();
}

class _LoginFieldsState extends State<LoginFields> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: widget.formKey,
        child: Column(
          children: [
            CustomFormField(
              hintTxt: AppText.email,
              txtController: widget.controller1,
              prefImg: AppImages.userIcon,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              obscureText: false,
              showSuffixIcon: false,
              isPhoneField: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                return FormValidation.emailValidation(value);
              },
            ),
            CustomFormField(
              hintTxt: AppText.password,
              txtController: widget.controller2,
              obscureText: _obscurePassword,
              showSuffixIcon: true,
              onSuffixIconTap: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
              prefImg: AppImages.lockIcon,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return FormValidation.passwordValidation(value);
              },
            ),
            Transform.translate(
                offset: const Offset(-10, -10), child: const LoginTextParts()),
            GapSpace.height40
          ],
        ),
      ),
    );
  }
}
