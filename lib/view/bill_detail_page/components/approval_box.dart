import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/status_color_widget.dart';

Column rowText(
    {required String leftText,
    required String rightText,
    required bool isRightText,
    required bool isUnderlineText,
    required bool is50016,
    required bool is40014,
    required bool changeColor,
    String? img}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(
            text: leftText,
            fontWeight: is50016 == true ? FontWeight.w500 : FontWeight.w400,
            fontFamily: 'SF Pro Display',
            fontSize: is50016 == true ? 16 : 14,
            color: AppColors.loginTextColor,
          ),
          isRightText == false
              ? SvgPictureWidget(image: img ?? '', height: 12, width: 6)
              : isUnderlineText == true
                  ? Transform.translate(
                      offset: Offset(0, 13),
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
                      fontSize: is40014 == true ? 14 : 12,
                      color: changeColor == true
                          ? AppColors.appGreyColor3
                          : AppColors.loginTextColor,
                    ),
        ],
      ),
    ],
  );
}

Row rowText2({
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
        color: isQuantity == false
            ? AppColors.loginTextColor
            : AppColors.appGreyColor,
      ),
      Flexible(
        child: ReusableText(
            text: rightText,
            fontWeight: is70020 == true
                ? FontWeight.w700
                : is60015 == true
                    ? FontWeight.w600
                    : is70016 == true
                        ? FontWeight.w700
                        : FontWeight.w500,
            fontFamily: 'SF Pro Display',
            fontSize: is60015 == true
                ? 15
                : is70016 == true
                    ? 16
                    : is70020 == true
                        ? 20
                        : 14,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            color: AppColors.loginTextColor,
            textAlign: TextAlign.end),
      ),
    ],
  );
}

Column approvalBox({required String status}) {
  return Column(
    children: [
      rowText(
          leftText: "Approval History",
          rightText: '',
          isRightText: false,
          isUnderlineText: false,
          img: AppImages.rightArrow,
          is50016: true,
          changeColor: false,
          is40014: false),
      GapSpace.height17,
      rowText(
          // leftText: "Bill has been approved by one of the approvers.",
          leftText: "Bill has been $status by one of the approvers.",
          rightText: 'View history',
          isUnderlineText: true,
          isRightText: true,
          is40014: true,
          changeColor: false,
          is50016: false),
      GapSpace.height5,
      rowText(
          leftText: "2hrs ago",
          rightText: '',
          isUnderlineText: false,
          isRightText: true,
          changeColor: true,
          is40014: false,
          is50016: false),
    ],
  );
}

Stack billData({
  required String rightText1,
  required String rightText2,
  required String rightText3,
  required String rightText4,
  required BuildContext context,
  required bool isBill,
  // required int isVerified
  required int billStatus,
}) {
  var width = MediaQuery.of(context).size.width;
  return Stack(
    children: [
      ReusableContainer(
        color: AppColors.appFullWhite,
        width: width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 14, top: 24, right: 14, bottom: 24),
              child: ReusableContainer(
                // width: 313,
                child: Transform.translate(
                  offset: const Offset(0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      rowText2(
                          leftText: isBill == true ? 'Bill#' : "Invoice#",
                          rightText: rightText1,
                          is60015: false,
                          is70016: false,
                          isQuantity: false,
                          is70020: false),
                      GapSpace.height15,
                      rowText2(
                        leftText: isBill == true ? "Bill Date" : "Invoice Date",
                        rightText: rightText2,
                        is60015: false,
                        is70016: false,
                        is70020: false,
                        isQuantity: false,
                      ),
                      GapSpace.height15,
                      rowText2(
                        leftText: "Due Date",
                        rightText: rightText3,
                        is60015: false,
                        is70016: false,
                        is70020: false,
                        isQuantity: false,
                      ),
                      GapSpace.height15,
                      rowText2(
                        leftText: "Currency",
                        rightText: rightText4,
                        is60015: false,
                        is70016: false,
                        is70020: false,
                        isQuantity: false,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                right: -20,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(AppImages.statusBox,
                        height: 21,
                        width: 128,
                        fit: BoxFit.contain,
                        color: getIntStatusColor(billStatus)),
                    ReusableText(
                      text: getBillAndInvoiceStatusText(billStatus),
                      color: AppColors.appFullWhite,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    ),
                  ],
                )),
          ],
        ),
      ),
    ],
  );
}

Widget chargeDetails({
  required bool isInvoice,
  required String leftText1,
  required String leftText2,
  String? leftText3,
  String? leftText4,
  required String rightText1,
  required String rightText2,
  String? rightText3,
  String? rightText4,
}) {
  return Column(
    children: [
      rowText2(
        leftText: leftText1,
        rightText: rightText1,
        is60015: false,
        is70020: false,
        is70016: false,
        isQuantity: false,
      ),
      GapSpace.height10,
      rowText2(
        leftText: leftText2,
        rightText: rightText2,
        is60015: false,
        is70020: false,
        is70016: true,
        isQuantity: true,
      ),
      isInvoice == true ? GapSpace.height20 : SizedBox(),
      isInvoice == true
          ? rowText2(
              leftText: leftText3 ?? "",
              rightText: rightText3 ?? "",
              is60015: false,
              is70020: false,
              is70016: false,
              isQuantity: false,
            )
          : SizedBox(),
      isInvoice == true ? GapSpace.height10 : SizedBox(),
      isInvoice == true
          ? rowText2(
              leftText: leftText4 ?? "",
              rightText: rightText4 ?? "",
              is60015: false,
              is70020: false,
              is70016: false,
              isQuantity: false,
            )
          : SizedBox(),
    ],
  );
}

Widget subTotalData({
  required String leftText1,
  required String leftText2,
  required String leftText3,
  required String rightText1,
  required String rightText2,
  required String rightText3,
}) {
  return Row(
    children: [
      GapSpace.width130,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
              text: leftText1,
              fontWeight: FontWeight.w400,
              fontFamily: 'SF Pro Display',
              fontSize: 14,
              color: AppColors.appGreyColor2),
          GapSpace.height10,
          ReusableText(
              text: leftText2,
              fontWeight: FontWeight.w400,
              fontFamily: 'SF Pro Display',
              fontSize: 14,
              color: AppColors.appGreyColor2),
          GapSpace.height25,
          ReusableText(
              text: leftText3,
              fontWeight: FontWeight.w400,
              fontFamily: 'SF Pro Display',
              fontSize: 14,
              color: AppColors.appGreyColor2),
        ],
      ),
      SizedBox(width: 45),
      Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ReusableText(
              text: rightText1,
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro Display',
              fontSize: 16,
              color: AppColors.loginTextColor,
              textAlign: TextAlign.end),
          GapSpace.height10,
          ReusableText(
              text: rightText2,
              fontWeight: FontWeight.w500,
              fontFamily: 'SF Pro Display',
              fontSize: 16,
              color: AppColors.loginTextColor,
              textAlign: TextAlign.end),
          GapSpace.height25,
          ReusableText(
              text: rightText3,
              fontWeight: FontWeight.w700,
              fontFamily: 'SF Pro Display',
              fontSize: 20,
              color: AppColors.loginTextColor,
              textAlign: TextAlign.end),
        ],
      ),
    ],
  );
}

Widget termsAndConditions({
  required String leftText1,
  required String leftText2,
  required String leftText3,
  required String rightText1,
  required String rightText2,
  required String rightText3,
}) {
  return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GapSpace.height20,
        rowText2(
          leftText: leftText1,
          rightText: rightText1,
          is60015: true,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        GapSpace.height15,
        rowText2(
          leftText: leftText2,
          rightText: rightText2,
          is60015: true,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
        GapSpace.height10,
        rowText2(
          leftText: leftText3,
          rightText: rightText3,
          is60015: true,
          is70020: false,
          is70016: false,
          isQuantity: false,
        ),
      ]);
}
