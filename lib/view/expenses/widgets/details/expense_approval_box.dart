import 'package:payzo_books/import_data.dart';

Column rowTextExpense({
  required String leftText,
  required String rightText,
  required bool isRightText,
  required bool isUnderlineText,
  required bool is50016,
  required bool is40014,
  required bool changeColor,
  String? img,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(
            text: leftText,
            fontWeight: is50016 ? FontWeight.w500 : FontWeight.w400,
            fontFamily: 'SF Pro Display',
            fontSize: is50016 ? 16 : 14,
            color: AppColors.loginTextColor,
          ),
          !isRightText
              ? SvgPictureWidget(image: img ?? '', height: 12, width: 6)
              : isUnderlineText
              ? Transform.translate(
            offset: const Offset(0, 13),
            child: ReusableText(
              text: rightText,
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro Display',
              fontSize: 14,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.appMainColor,
              color: AppColors.appMainColor,
              overflow: TextOverflow.ellipsis,
            ),
          )
              : ReusableText(
            text: rightText,
            fontWeight: FontWeight.w400,
            fontFamily: 'SF Pro Display',
            fontSize: is40014 ? 14 : 12,
            color: changeColor
                ? AppColors.appGreyColor3
                : AppColors.loginTextColor,
          ),
        ],
      ),
    ],
  );
}

Row rowText2Expense({
  required String leftText,
  required String rightText,
  required bool is60015,
  required bool is70020,
  required bool is70016,
  required bool isQuantity,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ReusableText(
        text: leftText,
        fontWeight: FontWeight.w400,
        fontFamily: 'SF Pro Display',
        fontSize: 14,
        maxLines: 2,
        color:
        isQuantity ? AppColors.appGreyColor : AppColors.loginTextColor,
      ),
      Flexible(
        child: ReusableText(
          text: rightText,
          fontWeight: is70020
              ? FontWeight.w700
              : is60015
              ? FontWeight.w600
              : is70016
              ? FontWeight.w700
              : FontWeight.w500,
          fontFamily: 'SF Pro Display',
          fontSize: is60015
              ? 15
              : is70016
              ? 16
              : is70020
              ? 20
              : 14,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          color: AppColors.loginTextColor,
          textAlign: TextAlign.end,
        ),
      ),
    ],
  );
}
