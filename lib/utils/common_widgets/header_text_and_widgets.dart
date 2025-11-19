import 'package:payzo_books/import_data.dart';

Column headerTextAndWidgets({
  required String headerText1,
  required String headerText2,
  required VoidCallback onTap1,
  required VoidCallback onTap2,
  required VoidCallback onTap3,
  required VoidCallback onTap4,
  required VoidCallback onTap5,
  required bool isOnTap1Needed,
  required bool isOnTap2Needed,
  required bool isOnTap3Needed,
  required bool isOnTap4Needed,
  required bool isOnTap5Needed,
  required String img1,
  required String img2,
  required String img3,
  required String img4,
  required String img5,
  required String title1,
  required String title2,
  required String title3,
  required String title4,
  required String title5,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GapSpace.height20,
      Center(child: titleData(text1: headerText1, text2: headerText2)),
      GapSpace.height30,
      boxIconWithLabel(
          img1: img1,
          img2: img2,
          img3: img3,
          img4: img4,
          img5: img5,
          title1: title1,
          title2: title2,
          title3: title3,
          title4: title4,
          title5: title5,
          onTap1: onTap1,
          onTap2: onTap2,
          onTap3: onTap3,
          onTap4: onTap4,
          onTap5: onTap5,
          isOnTap1Needed: isOnTap2Needed,
          isOnTap2Needed: isOnTap1Needed,
          isOnTap3Needed: isOnTap3Needed,
          isOnTap4Needed: isOnTap4Needed,
          isOnTap5Needed: isOnTap5Needed),
      title4 == 'Edit' ? GapSpace.height10 : GapSpace.height20
    ],
  );
}

Column boxIconWithLabelComponent({
  required String image,
  required String labelText,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Container(
        width: 45,
        height: 45,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: AppColors.appMainColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        child: Center(
            child: SvgPictureWidget(
          image: image,
          height: 24,
          width: 24,
        )),
      ),
      GapSpace.height10,
      Text(
        labelText,
        // maxLines: labelText.length > 6 ? 2 : 1,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.appMainColor,
          fontSize: 12,
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

SingleChildScrollView boxIconWithLabel({
  required VoidCallback onTap1,
  required VoidCallback onTap2,
  required VoidCallback onTap3,
  required VoidCallback onTap4,
  required VoidCallback onTap5,
  required bool isOnTap1Needed,
  required bool isOnTap2Needed,
  required bool isOnTap3Needed,
  required bool isOnTap4Needed,
  required bool isOnTap5Needed,
  required String img1,
  required String img2,
  required String img3,
  required String img4,
  required String img5,
  required String title1,
  required String title2,
  required String title3,
  required String title4,
  required String title5,
}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    physics: BouncingScrollPhysics(),
    // padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // isOnTap1Needed == true ? GapSpace.width15 : const SizedBox(),
          isOnTap1Needed == true
              ? GestureDetector(
                  onTap: onTap1,
                  child:
                      boxIconWithLabelComponent(image: img1, labelText: title1),
                )
              : const SizedBox(),
          isOnTap2Needed == true ? GapSpace.width30 : const SizedBox(),
          isOnTap2Needed == true
              ? GestureDetector(
                  onTap: onTap2,
                  child:
                      boxIconWithLabelComponent(image: img2, labelText: title2),
                )
              : const SizedBox(),
          isOnTap3Needed == true ? GapSpace.width30 : const SizedBox(),
          isOnTap3Needed == true
              ? GestureDetector(
                  onTap: onTap3,
                  child: boxIconWithLabelComponent(
                    image: img3,
                    labelText: title3,
                  ),
                )
              : const SizedBox(),
          isOnTap4Needed == true ? GapSpace.width30 : const SizedBox(),
          isOnTap4Needed == true
              ? GestureDetector(
                  onTap: onTap4,
                  child: boxIconWithLabelComponent(
                    image: img4,
                    labelText: title4,
                  ),
                )
              : const SizedBox(),
          isOnTap5Needed == true ? GapSpace.width30 : const SizedBox(),
          isOnTap5Needed == true
              ? GestureDetector(
                  onTap: onTap5,
                  child: boxIconWithLabelComponent(
                    image: img5,
                    labelText: title5,
                  ),
                )
              : const SizedBox(),
        ]),
  );
}

Column titleData({
  required String text1,
  required String text2,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      ReusableText(
          text: text1,
          color: AppColors.blackShade,
          fontFamily: 'SF Pro Display',
          fontSize: 20,
          letterSpacing: 0,
          fontWeight: FontWeight.w700,
          height: 1),
      GapSpace.height10,
      ReusableText(
          text: text2,
          color: AppColors.blackShade,
          fontFamily: 'SF Pro Display',
          fontSize: 14,
          letterSpacing: 0,
          fontWeight: FontWeight.w500,
          height: 1),
    ],
  );
}

Container boxIconWithoutLabelComponent({
  required String image,
}) {
  return Container(
    width: 28,
    height: 28,
    clipBehavior: Clip.antiAlias,
    decoration: ShapeDecoration(
      color: AppColors.appMainColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
    ),
    child: Center(
        child: SvgPictureWidget(
      image: image,
      height: 15,
      width: 15,
    )),
  );
}

Row boxIconWithOutLabel({
  required VoidCallback callOnTap,
  required VoidCallback mailOnTap,
  required VoidCallback msgOnTap,
}) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 15,
      children: [
        GestureDetector(
          onTap: callOnTap,
          child: boxIconWithoutLabelComponent(image: AppImages.call),
        ),
        GestureDetector(
          onTap: mailOnTap,
          child: boxIconWithoutLabelComponent(image: AppImages.mail),
        ),
        GestureDetector(
          onTap: msgOnTap,
          child: boxIconWithoutLabelComponent(image: AppImages.msg),
        ),
      ]);
}
