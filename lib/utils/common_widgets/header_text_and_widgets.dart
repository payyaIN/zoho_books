import 'package:payzo_books/import_data.dart';

Column headerTextAndWidgets({
  required String headerText1,
  required String headerText2,
  required VoidCallback callOnTap,
  required VoidCallback mailOnTap,
  required VoidCallback msgOnTap,
  required VoidCallback moreOnTap,
  required bool isMailNeeded,
  required bool isMoreNeeded,
  required bool isCallNeeded,
  required String img1,
  required String img2,
  required String img3,
  required String img4,
  required String imgName1,
  required String imgName2,
  required String imgName3,
  required String imgName4,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      GapSpace.height20,
      titleData(text1: headerText1, text2: headerText2),
      GapSpace.height30,
      boxIconWithLabel(
          img1: img1,
          img2: img2,
          img3: img3,
          img4: img4,
          imgName1: imgName1,
          imgName2: imgName2,
          imgName3: imgName3,
          imgName4: imgName4,
          callOnTap: callOnTap,
          mailOnTap: mailOnTap,
          msgOnTap: msgOnTap,
          moreOnTap: moreOnTap,
          isMoreNeeded: isMoreNeeded,
          isMailNeeded: isMailNeeded,
          isCallNeeded: isCallNeeded),
      GapSpace.height12
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

Row boxIconWithLabel({
  required VoidCallback callOnTap,
  required VoidCallback mailOnTap,
  required VoidCallback msgOnTap,
  required VoidCallback moreOnTap,
  required bool isMoreNeeded,
  required bool isMailNeeded,
  required bool isCallNeeded,
  required String img1,
  required String img2,
  required String img3,
  required String img4,
  required String imgName1,
  required String imgName2,
  required String imgName3,
  required String imgName4,
}) {
  return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        isCallNeeded == true
            ? GestureDetector(
                onTap: callOnTap,
                child:
                    boxIconWithLabelComponent(image: img1, labelText: imgName1),
              )
            : const SizedBox(),
        isMailNeeded == true ? GapSpace.width36 : const SizedBox(),
        isMailNeeded == true
            ? GestureDetector(
                onTap: mailOnTap,
                child:
                    boxIconWithLabelComponent(image: img2, labelText: imgName2),
              )
            : const SizedBox(),
        isMailNeeded == true ? GapSpace.width36 : const SizedBox(),
        GestureDetector(
          onTap: msgOnTap,
          child: boxIconWithLabelComponent(image: img3, labelText: imgName3),
        ),
        isMoreNeeded == true ? GapSpace.width36 : const SizedBox(),
        isMoreNeeded == true
            ? GestureDetector(
                onTap: moreOnTap,
                child: boxIconWithLabelComponent(
                  image: img4,
                  labelText: imgName4,
                ),
              )
            : const SizedBox(),
      ]);
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
