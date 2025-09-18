import 'package:google_fonts/google_fonts.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/color_palette.dart';

class AppTextStyle {
  static TextStyle loginTextStyle = GoogleFonts.poppins(
      fontWeight: FontWeight.w700,
      fontSize: 24,
      color: AppColors.loginTextColor);
  static TextStyle loginTextDiscStyle = GoogleFonts.poppins(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: AppColors.loginTextColor);
  static TextStyle hintTextStyle = GoogleFonts.poppins(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: AppColors.loginTextColor);
  static TextStyle listTileSubTxt = GoogleFonts.poppins(
      fontWeight: FontWeight.w300,
      fontSize: 12,
      color: AppColors.loginTextColor);
  static TextStyle rememberMeStyle = GoogleFonts.poppins(
      fontWeight: FontWeight.w400, fontSize: 12, color: AppColors.appGreyColor);
  static TextStyle forgotPaswrdStyle = GoogleFonts.poppins(
      fontWeight: FontWeight.w400, fontSize: 12, color: AppColors.appMainColor);

  static TextStyle buttonTextStyle = GoogleFonts.poppins(
      fontWeight: FontWeight.w700, fontSize: 16, color: AppColors.btnTextColor);

  static TextStyle appbarTextStyle = GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 18,
      color: AppColors.appBlackColor);
}
