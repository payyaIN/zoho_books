import 'package:payzo_books/import_data.dart';

// showCheckBoxSheet({
//   required BuildContext context,
// }) {
//   return showModalBottomSheet(
//     isScrollControlled: true,
//     context: context,
//     builder: (context) {
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//           return FractionallySizedBox(
//             heightFactor: 0.9,
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(
//                       left: 23, right: 23, top: 23, bottom: 37),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       ReusableText(
//                         text: AppText.filterBy,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 20,
//                         color: AppColors.appBlackColor,
//                         fontFamily: 'SF Pro Display',
//                       ),
//                       GestureDetector(
//                         behavior: HitTestBehavior.opaque,
//                         onTap: () {
//                           Navigator.of(context).pop();
//                         },
//                         child: SvgPictureWIidget(
//                           image: AppImages.crossSymbol,
//                           height: 24,
//                           width: 24,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     physics: const BouncingScrollPhysics(),
//                     itemCount: filterText.length,
//                     itemBuilder: (context, index) {
//                       return Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           CheckboxListTile(
//                             controlAffinity: ListTileControlAffinity.leading,
//                             enableFeedback: true,
//                             title: ReusableText(
//                               text: filterText[index],
//                               fontWeight: FontWeight.w400,
//                               fontSize: 16,
//                               color: AppColors.appBlackColor,
//                               fontFamily: 'SF Pro Display',
//                             ),
//                             value: selectedFilter == filterText[index],
//                             onChanged: (value) {
//                               setState(() {
//                                 selectedFilter = filterText[index];
//                               });
//                               Future.delayed(const Duration(milliseconds: 550),
//                                   () {
//                                 if (context.mounted) {
//                                   return Navigator.of(context)
//                                       .pop(selectedFilter);
//                                 }
//                               });
//                             },
//                           ),
//                           if (index < filterText.length - 1)
//                             Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 23),
//                               child: Divider(),
//                             )
//                         ],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }
