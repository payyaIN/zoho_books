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

AppBar reusableAppBarWithSuffixWidget({
  required String title,
  required BuildContext context,
  String? suffixText,
  String? importText,
  String? exportText,
  VoidCallback? onSuffixTap,
  VoidCallback? onImportTap,
  VoidCallback? onExportTap,
  required bool showTitle,
  required bool showBackButton,
  bool? isSuffixText,
  bool? isImportExportNeeded,
  Widget? widget,
}) =>
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
        ),
        isImportExportNeeded == true
            ? Padding(
                padding: const EdgeInsets.only(right: 10),
                child: PopupMenuButton<String>(
                  onSelected: (String result) {
                    if (result == 'option1') {
                      print('Option 1 selected!');
                    } else if (result == 'option2') {
                      print('Option 2 selected!');
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: importText,
                      child: GestureDetector(
                        onTap: onImportTap,
                        child: Row(
                          children: [
                            Text(
                              importText!,
                              style: TextStyle(
                                color: AppColors.appMainColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.download_rounded,
                                color: AppColors.appMainColor, size: 20),
                          ],
                        ),
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: exportText,
                      child: GestureDetector(
                        onTap: onExportTap,
                        child: Row(
                          children: [
                            Text(
                              exportText!,
                              style: TextStyle(
                                color: AppColors.appMainColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.upload_rounded,
                                color: AppColors.appMainColor, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                  child: const Icon(Icons.more_vert),
                ),
              )
            : const SizedBox(),
      ],
      backgroundColor: AppColors.appWhiteColor,
      centerTitle: true,
    );
