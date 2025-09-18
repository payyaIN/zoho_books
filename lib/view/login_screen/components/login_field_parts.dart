import 'package:flutter/gestures.dart';
import 'package:payzo_books/import_data.dart';

class LoginTextParts extends StatefulWidget {
  const LoginTextParts({super.key});

  @override
  State<LoginTextParts> createState() => _LoginTextPartsState();
}

class _LoginTextPartsState extends State<LoginTextParts> {
  bool isChecked = true;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Row(
        //   children: [
        // Checkbox(
        //   activeColor: AppColors.appMainColor,
        //   value: isChecked,
        //   onChanged: (bool? value) {
        //     setState(() {
        //       isChecked = value!;
        //     });
        //   },
        // ),

        // Checkbox(
        //   activeColor: AppColors.appMainColor,
        //   value: isChecked,
        //   onChanged: (bool? value) {
        //     setState(() {
        //       isChecked = value!;
        //     });
        //     _saveRememberMePreference(isChecked);
        //   },
        // ),
        //     ReusableText(
        //       text: AppText.rememberMe,
        //       fontWeight: FontWeight.w400,
        //       fontSize: 12,
        //       color: AppColors.appGreyColor,
        //       fontFamily: 'SF Pro Display',
        //     ),
        //   ],
        // ),
        ReusableText(
          text: AppText.forgtPaswrd,
          fontWeight: FontWeight.w400,
          fontSize: 12,
          color: AppColors.appMainColor,
          fontFamily: 'SF Pro Display',
        ),
      ],
    );
  }

  // void _saveRememberMePreference(bool value) {
  //   SharedPreferencesHelper.saveBool('remember_me', value);
  // }
}

class NoAccountTextParts extends StatefulWidget {
  String text1;
  String text2;
  VoidCallback onTap;
  NoAccountTextParts(
      {required this.text1,
      required this.text2,
      required this.onTap,
      super.key});

  @override
  State<NoAccountTextParts> createState() => _NoAccountTextPartsState();
}

class _NoAccountTextPartsState extends State<NoAccountTextParts> {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: widget.text1,
            style: AppTextStyle.rememberMeStyle,
          ),
          WidgetSpan(
            child: SizedBox(width: 5),
          ),
          TextSpan(
            text: widget.text2,
            style: AppTextStyle.forgotPaswrdStyle,
            recognizer: TapGestureRecognizer()..onTap = widget.onTap,
          ),
        ],
      ),
    );
  }
}
