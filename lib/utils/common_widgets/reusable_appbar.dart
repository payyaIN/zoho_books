import 'package:payzo_books/import_data.dart';

AppBar reusableAppBar({
  required String title,
  required bool showBackButton,
  required BuildContext context,
  VoidCallback? onBackPressed,
}) =>
    AppBar(
      title: ReusableText(
          text: title,
          fontWeight: FontWeight.w500,
          fontSize: 18,
          fontFamily: 'SF Pro Display',
          color: AppColors.appBlackColor),
      surfaceTintColor: Colors.transparent,
      leading: showBackButton
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
                size: 16,
              ),
              onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
            )
          : const SizedBox(),
      backgroundColor: AppColors.appWhiteColor,
      centerTitle: true,
    );

AppBar reusableAppBarWithSuffixWidget(
        {required String title,
        required BuildContext context,
        String? suffixText,
        VoidCallback? onSuffixTap,
        required bool showTitle,
        required bool showBackButton,
        bool? isSuffixText,
        Widget? widget}) =>
    AppBar(
      title: showTitle == true
          ? ReusableText(
              text: title,
              fontWeight: FontWeight.w500,
              fontSize: 18,
              fontFamily: 'SF Pro Display',
              color: AppColors.appBlackColor)
          : null,
      surfaceTintColor: Colors.transparent,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.black,
                size: 16,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )
          : const SizedBox(),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 17),
          child: GestureDetector(
            onTap: onSuffixTap,
            child: isSuffixText == true
                ? Text(
                    suffixText!,
                    style: TextStyle(
                      color: AppColors.appMainColor,
                      decoration: TextDecoration.underline,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                : widget,
          ),
        )
      ],
      backgroundColor: AppColors.appWhiteColor,
      centerTitle: true,
    );
