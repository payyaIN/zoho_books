import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/status_color_widget.dart';

Stack billDataNotification({
  required String leftText1,
  required String leftText2,
  required String leftText3,
  required String leftText4,
  required String rightText1,
  required String rightText2,
  required String rightText3,
  required String rightText4,
  required Color statusColor,
  required String statusText,
  required BuildContext context,
}) {
  var width = MediaQuery.of(context).size.width;
  return Stack(
    children: [
      ReusableContainer(
        color: AppColors.appFullWhite,
        width: 344,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 14, top: 24, right: 14, bottom: 24),
              child: ReusableContainer(
                width: width,
                child: Transform.translate(
                  offset: const Offset(0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      rowText2(
                          leftText: leftText1,
                          rightText: rightText1,
                          is60015: false,
                          is70016: false,
                          isQuantity: false,
                          is70020: false),
                      GapSpace.height15,
                      rowText2(
                        leftText: leftText2,
                        rightText: rightText2,
                        is60015: false,
                        is70016: false,
                        is70020: false,
                        isQuantity: false,
                      ),
                      GapSpace.height15,
                      rowText2(
                        leftText: leftText3,
                        rightText: rightText3,
                        is60015: false,
                        is70016: false,
                        is70020: false,
                        isQuantity: false,
                      ),
                      GapSpace.height15,
                      rowText2(
                        leftText: leftText4,
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
                        color: statusColor),
                    // SvgPictureWidget(image: image, height: 21, width: 128),
                    ReusableText(
                      text: statusText,
                      color: AppColors.appWhiteColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                    )
                  ],
                )),
          ],
        ),
      ),
    ],
  );
}
