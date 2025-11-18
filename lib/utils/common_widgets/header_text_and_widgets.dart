import 'package:payzo_books/import_data.dart';

// Column headerTextAndWidgets({
//   required String headerText1,
//   required String headerText2,
//   required VoidCallback onTap1,
//   required VoidCallback onTap2,
//   required VoidCallback onTap3,
//   VoidCallback? onTap4,
//   VoidCallback? onTap5,
//   required bool isonTap1Needed,
//   required bool isonTap2Needed,
//   required bool isonTap3Needed,
//   bool isonTap4Needed = false,
//   bool isonTap5Needed = false,
//   required String img1,
//   required String img2,
//   required String img3,
//   String? img4,
//   String? img5,
//   required String title1,
//   required String title2,
//   required String title3,
//   required String title4,
//   String? title5,
// }) {
//   return Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     crossAxisAlignment: CrossAxisAlignment.center,
//     children: [
//       GapSpace.height20,
//       titleData(text1: headerText1, text2: headerText2),
//       GapSpace.height30,
//       boxIconWithLabel(
//           img1: img1,
//           img2: img2,
//           img3: img3,
//           img4: img4 ?? '',
//           img5: img5 ?? '',
//           imgName1: title1,
//           imgName2: title2,
//           imgName3: title3,
//           imgName4: title4,
//           imgName5: title5 ?? '',
//           callOnTap: onTap1,
//           mailOnTap: onTap2,
//           msgOnTap: onTap3,
//           editOnTap: onTap4 ?? () {},
//           delOnTap: onTap5 ?? () {},
//           isCallNeeded: isonTap1Needed,
//           isMailNeeded: isonTap2Needed,
//           isMsgNeeded: isonTap3Needed,
//           isEditNeeded: isonTap4Needed,
//           isDelNeeded: isonTap5Needed),
//       GapSpace.height12
//     ],
//   );
// }

Column headerTextAndWidgets({
  required String headerText1,
  required String headerText2,
  required VoidCallback callOnTap,
  required VoidCallback mailOnTap,
  required VoidCallback msgOnTap,
  required VoidCallback editOnTap,
  required bool isMailNeeded,
  required bool isEditNeeded,
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
          moreOnTap: editOnTap,
          isMoreNeeded: isEditNeeded,
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

// Row boxIconWithLabel({
//   required VoidCallback onTap1,
//   required VoidCallback onTap2,
//   required VoidCallback onTap3,
//   required VoidCallback onTap4,
//   required VoidCallback onTap5,
//   required bool isOnTap1Needed,
//   required bool isOnTap2Needed,
//   required bool isOnTap3Needed,
//   required bool isOnTap4Needed,
//   required bool isOnTap5Needed,
//   required String img1,
//   required String img2,
//   required String img3,
//   required String img4,
//   required String img5,
//   required String imgName1,
//   required String imgName2,
//   required String imgName3,
//   required String imgName4,
//   required String imgName5,
// }) {
//   return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         isOnTap1Needed == true
//             ? GestureDetector(
//                 onTap: onTap1,
//                 child:
//                     boxIconWithLabelComponent(image: img1, labelText: imgName1),
//               )
//             : const SizedBox(),
//         isOnTap2Needed == true ? GapSpace.width36 : const SizedBox(),
//         isOnTap2Needed == true
//             ? GestureDetector(
//                 onTap: onTap2,
//                 child:
//                     boxIconWithLabelComponent(image: img2, labelText: imgName2),
//               )
//             : const SizedBox(),
//         isOnTap2Needed == true ? GapSpace.width36 : const SizedBox(),
//         GestureDetector(
//           onTap: onTap3,
//           child: boxIconWithLabelComponent(image: img3, labelText: imgName3),
//         ),
//         isOnTap3Needed == true ? GapSpace.width36 : const SizedBox(),
//         isOnTap3Needed == true
//             ? GestureDetector(
//                 onTap: onTap4,
//                 child: boxIconWithLabelComponent(
//                   image: img3,
//                   labelText: imgName4,
//                 ),
//               )
//             : const SizedBox(),
//         isOnTap4Needed == true ? GapSpace.width36 : const SizedBox(),
//         isOnTap4Needed == true
//             ? GestureDetector(
//                 onTap: onTap5,
//                 child: boxIconWithLabelComponent(
//                   image: img4,
//                   labelText: imgName4,
//                 ),
//               )
//             : const SizedBox(),
//         isOnTap5Needed == true ? GapSpace.width36 : const SizedBox(),
//         isOnTap5Needed == true
//             ? GestureDetector(
//                 onTap: onTap5,
//                 child: boxIconWithLabelComponent(
//                   image: img5,
//                   labelText: imgName5,
//                 ),
//               )
//             : const SizedBox(),
//       ]);
// }
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
