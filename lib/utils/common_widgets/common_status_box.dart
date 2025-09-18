import 'package:payzo_books/import_data.dart';

Container statusBox({
  required String boxText,
  required bool isAllBox,
  required double width,
  required double height,
  required bool isIcon,
  bool isSelected = false,
  String txtLength = '',
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: isSelected ? AppColors.appMainColor : AppColors.appWhiteColor,
      borderRadius: BorderRadius.all(Radius.circular(9)),
      border: Border.all(color: AppColors.boxBorder, width: 1),
    ),
    child: Center(
      child: isIcon == false
          ? Padding(
              padding: boxText.length >= 6
                  ? const EdgeInsets.all(6.0)
                  : const EdgeInsets.all(0),
              child: ReusableText(
                text: boxText,
                color: isSelected
                    ? AppColors.appWhiteColor
                    : AppColors.appBlackColor,
                maxLines: boxText.length >= 6 ? 1 : null,
                overflow: boxText.length >= 6 ? TextOverflow.ellipsis : null,
                fontSize: boxText.length >= 6 ? 12 : 14,
                fontFamily: 'SF Pro Display',
                fontWeight: FontWeight.w400,
              ),
            )
          : GestureDetector(
              child: SvgPictureWIidget(
                  image: AppImages.arrowDown, height: 6, width: 12),
            ),
    ),
  );
}
