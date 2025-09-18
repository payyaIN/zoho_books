import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:payzo_books/utils/app_data/color_palette.dart';

class CustomFormField extends StatelessWidget {
  final String hintTxt;
  final TextEditingController txtController;
  final bool obscureText;
  final bool showSuffixIcon;
  final VoidCallback? onSuffixIconTap;
  final String prefImg;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool isPhoneField;
  final String? Function(String?)? validator;
  final int? maxLength;
  final bool? readOnly;

  const CustomFormField({
    Key? key,
    required this.hintTxt,
    required this.txtController,
    required this.obscureText,
    required this.showSuffixIcon,
    this.onSuffixIconTap,
    required this.prefImg,
    required this.textInputAction,
    required this.keyboardType,
    this.isPhoneField = false,
    this.validator,
    this.maxLength,
    this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: txtController,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        validator: validator,
        readOnly: readOnly ?? false,
        style: TextStyle(
          color: AppColors.loginTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'SF Pro Display',
        ),
        maxLength: maxLength,
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: AppColors.whiteShade,
          hintText: hintTxt,
          hintStyle: TextStyle(
            color: AppColors.appGreyColor,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            fontFamily: 'SF Pro Display',
          ),
          prefixIcon: SizedBox(
            width: 20,
            height: 20,
            child: Center(
              child: SvgPicture.asset(
                prefImg,
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  AppColors.appGreyColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          suffixIcon: showSuffixIcon
              ? InkWell(
                  onTap: onSuffixIconTap,
                  child: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.appGreyColor,
                    size: 20,
                  ),
                )
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Color(0xFFDEDEDE),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: AppColors.appMainColor,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          errorMaxLines: 3,
        ),
      ),
    );
  }
}
