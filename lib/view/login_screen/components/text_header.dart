import 'package:payzo_books/import_data.dart';

Widget textHeader() {
  return Padding(
    padding: const EdgeInsets.all(24),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableText(
          text: AppText.loginText,
          fontWeight: FontWeight.w700,
          fontSize: 24,
          color: AppColors.loginTextColor,
          fontFamily: 'SF Pro Display',
        ),
        GapSpace.height15,
        ReusableText(
          text: AppText.loginTextDisc,
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: AppColors.loginTextColor,
          fontFamily: 'SF Pro Display',
        ),
      ],
    ),
  );
}
