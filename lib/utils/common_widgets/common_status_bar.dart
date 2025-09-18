import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/searchbar/provider/search_bar_provider.dart';
import 'package:payzo_books/utils/searchbar/search_bar_ui/search_bar_ui.dart';
import 'package:payzo_books/utils/common_widgets/common_status_box.dart';

// class BodyStatus extends ConsumerWidget {
//   // final bool isProductPage;
//   BodyStatus(
//       {
//       // required this.isProductPage,
//       super.key});

//   final List<String> statusText = [
//     "All",
//     "Active",
//     "CRM",
//     "Duplicate",
//     "InActive",
//     "Portal Enabled",
//     "Portal Disabled",
//     "Overdue",
//     "Unpaid"
//   ];

//   final List<String> filterText = [
//     "Company Name",
//     "Email",
//     "Mobile Phone",
//     "First Name",
//     "Last Name",
//   ];

//   void showCheckBoxSheet(BuildContext context, WidgetRef ref) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return FractionallySizedBox(
//           heightFactor: 0.9,
//           child: Consumer(
//             builder: (context, ref, child) {
//               return Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 23, right: 23, top: 23, bottom: 37),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.max,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         ReusableText(
//                           text: AppText.filterBy,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 20,
//                           color: AppColors.appBlackColor,
//                           fontFamily: 'SF Pro Display',
//                         ),
//                         GestureDetector(
//                           behavior: HitTestBehavior.opaque,
//                           onTap: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: SvgPictureWIidget(
//                             image: AppImages.crossSymbol,
//                             height: 24,
//                             width: 24,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: statusText.length,
//                       itemBuilder: (context, index) {
//                         final selectedCheckBox =
//                             ref.watch(selectedCheckBoxProvider);

//                         return Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CheckboxListTile(
//                               controlAffinity: ListTileControlAffinity.leading,
//                               title: ReusableText(
//                                 text: statusText[index],
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 16,
//                                 color: AppColors.appBlackColor,
//                                 fontFamily: 'SF Pro Display',
//                               ),
//                               checkColor: AppColors.appWhiteColor,
//                               activeColor: AppColors.appMainColor,
//                               value: selectedCheckBox == statusText[index],
//                               onChanged: (bool? value) {
//                                 ref
//                                     .read(selectedCheckBoxProvider.notifier)
//                                     .state = statusText[index];
//                                 ref.read(isAllSelectedProvider.notifier).state =
//                                     true;
//                                 ref
//                                     .read(selectedStatusProvider.notifier)
//                                     .state = null;

//                                 Future.delayed(
//                                     const Duration(milliseconds: 300), () {
//                                   if (context.mounted) {
//                                     Navigator.of(context).pop();
//                                   }
//                                 });
//                               },
//                             ),
//                             if (index < statusText.length - 1)
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 23),
//                                 child: Divider(),
//                               )
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   void showFilterCheckBox(BuildContext context, WidgetRef ref) {
//     showModalBottomSheet(
//       isScrollControlled: true,
//       context: context,
//       builder: (BuildContext context) {
//         return Consumer(
//           builder: (context, ref, child) {
//             return FractionallySizedBox(
//               heightFactor: 0.59,
//               child: Column(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         left: 100, right: 100, bottom: 29, top: 21),
//                     child: SvgPictureWIidget(
//                         image: AppImages.indicator, height: 5, width: 144),
//                   ),
//                   Expanded(
//                     child: ListView.builder(
//                       shrinkWrap: true,
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: filterText.length,
//                       itemBuilder: (context, index) {
//                         final selectedFilter =
//                             ref.watch(selectedFilterProvider);
//                         return Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             CheckboxListTile(
//                               controlAffinity: ListTileControlAffinity.leading,
//                               title: ReusableText(
//                                 text: filterText[index],
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 16,
//                                 color: AppColors.appBlackColor,
//                                 fontFamily: 'SF Pro Display',
//                               ),
//                               checkColor: AppColors.appWhiteColor,
//                               activeColor: AppColors.appMainColor,
//                               value: selectedFilter == filterText[index],
//                               onChanged: (bool? value) {
//                                 ref
//                                     .read(selectedFilterProvider.notifier)
//                                     .state = filterText[index];

//                                 Future.delayed(
//                                     const Duration(milliseconds: 200), () {
//                                   if (context.mounted) {
//                                     Navigator.of(context).pop();
//                                   }
//                                 });
//                               },
//                             ),
//                             if (index < filterText.length - 1)
//                               Padding(
//                                 padding:
//                                     const EdgeInsets.symmetric(horizontal: 23),
//                                 child: Divider(),
//                               ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                   GapSpace.height30,
//                   PayzoFormSubmitTwoButtons(
//                       cancelText: AppText.clear,
//                       saveText: AppText.save,
//                       cancelOnPressed: () {
//                         ref.read(selectedFilterProvider.notifier).state =
//                             filterText[0];

//                         final currentFilters =
//                             ref.read(selectedFilterProvider.notifier).state;
//                       },
//                       saveOnPressed: () {})
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // final selectedStatus = ref.watch(selectedStatusProvider);
//     // final selectedCheckBox = ref.watch(selectedCheckBoxProvider);
//     // final isAllSelected = ref.watch(isAllSelectedProvider);
//     // final searchState = ref.watch(searchProvider);
//     return Padding(
//         padding:
//             const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
//         child: Row(children: [
//           SearchBarUi(ref: ref,),
//           // Expanded(
//           //   child: searchState.query.isEmpty
//           //       ? _buildAllItemsList(searchState.items)
//           //       : _buildSearchResultsList(searchState.filteredItems),
//           // ),
//           // GestureDetector(
//           //   child: SvgPictureWIidget(
//           //       image: AppImages.searchIcon, height: 21, width: 21),
//           // ),
//           GapSpace.width12,
//           GestureDetector(
//             onTap: () {
//               showFilterCheckBox(context, ref);
//             },
//             child: SvgPictureWIidget(
//                 image: AppImages.filterIcon, height: 21, width: 21),
//           ),
//         ]));

//     // return isProductPage == false
//     //     ? Padding(
//     //         padding:
//     //             const EdgeInsets.only(left: 20, right: 26, top: 30, bottom: 20),
//     //         child: Row(
//     //           children: [
//     //             InkWell(
//     //               onTap: () {
//     //                 ref.read(selectedStatusProvider.notifier).state =
//     //                     (selectedStatus == AppText.active)
//     //                         ? null
//     //                         : AppText.active;
//     //                 ref.read(isAllSelectedProvider.notifier).state = false;
//     //               },
//     //               child: statusBox(
//     //                 width: 65,
//     //                 height: 33,
//     //                 isAllBox: false,
//     //                 isIcon: false,
//     //                 boxText: AppText.active,
//     //                 isSelected: selectedStatus == AppText.active,
//     //               ),
//     //             ),
//     //             GapSpace.width10,
//     //             InkWell(
//     //               onTap: () {
//     //                 ref.read(selectedStatusProvider.notifier).state =
//     //                     (selectedStatus == AppText.unpaid)
//     //                         ? null
//     //                         : AppText.unpaid;
//     //                 ref.read(isAllSelectedProvider.notifier).state = false;
//     //               },
//     //               child: statusBox(
//     //                 width: 70,
//     //                 height: 33,
//     //                 isAllBox: false,
//     //                 isIcon: false,
//     //                 boxText: AppText.unpaid,
//     //                 isSelected: selectedStatus == AppText.unpaid,
//     //               ),
//     //             ),
//     //             GapSpace.width10,
//     //             InkWell(
//     //               onTap: () {
//     //                 ref.read(selectedStatusProvider.notifier).state = null;
//     //                 ref.read(isAllSelectedProvider.notifier).state = true;
//     //               },
//     //               child: statusBox(
//     //                 width: 90,
//     //                 height: 33,
//     //                 isAllBox: true,
//     //                 isIcon: false,
//     //                 boxText: selectedCheckBox,
//     //                 isSelected: isAllSelected,
//     //               ),
//     //             ),
//     //             GapSpace.width10,
//     //             GestureDetector(
//     //               onTap: () {
//     //                 showCheckBoxSheet(context, ref);
//     //               },
//     //               child: statusBox(
//     //                 width: 33,
//     //                 height: 33,
//     //                 isAllBox: false,
//     //                 isIcon: true,
//     //                 boxText: '',
//     //               ),
//     //             ),
//     //             const Spacer(),
//     //             GestureDetector(
//     //               child: SvgPictureWIidget(
//     //                   image: AppImages.searchIcon, height: 21, width: 21),
//     //             ),
//     //             GapSpace.width12,
//     //             GestureDetector(
//     //               onTap: () {
//     //                 showFilterCheckBox(context, ref);
//     //               },
//     //               child: SvgPictureWIidget(
//     //                   image: AppImages.filterIcon, height: 21, width: 21),
//     //             ),
//     //           ],
//     //         ),
//     //       )
//     //     : Padding(
//     //         padding:
//     //             const EdgeInsets.only(left: 20, right: 26, top: 30, bottom: 20),
//     //         child: Row(children: [
//     //           InkWell(
//     //             onTap: () {
//     //               ref.read(selectedStatusProvider.notifier).state = null;
//     //               ref.read(isAllSelectedProvider.notifier).state = true;
//     //             },
//     //             child: statusBox(
//     //               width: 70,
//     //               height: 33,
//     //               isAllBox: true,
//     //               isIcon: false,
//     //               boxText: selectedCheckBox,
//     //               isSelected: isAllSelected,
//     //             ),
//     //           ),
//     //           GapSpace.width10,
//     //           GestureDetector(
//     //             onTap: () {
//     //               showCheckBoxSheet(context, ref);
//     //             },
//     //             child: statusBox(
//     //               width: 33,
//     //               height: 33,
//     //               isAllBox: false,
//     //               isIcon: true,
//     //               boxText: '',
//     //             ),
//     //           ),
//     //           const Spacer(),
//     //           GestureDetector(
//     //             child: SvgPictureWIidget(
//     //                 image: AppImages.searchIcon, height: 21, width: 21),
//     //           ),
//     //           GapSpace.width12,
//     //           GestureDetector(
//     //             onTap: () {
//     //               showFilterCheckBox(context, ref);
//     //             },
//     //             child: SvgPictureWIidget(
//     //                 image: AppImages.filterIcon, height: 21, width: 21),
//     //           ),
//     //         ]));
//   }

//   Widget _buildAllItemsList(List<String> items) {
//     return ListView.builder(
//       itemCount: items.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(items[index]),
//         );
//       },
//     );
//   }

//   Widget _buildSearchResultsList(List<String> filteredItems) {
//     if (filteredItems.isEmpty) {
//       return const Center(
//         child: Text('No results found'),
//       );
//     }

//     return ListView.builder(
//       itemCount: filteredItems.length,
//       itemBuilder: (context, index) {
//         return ListTile(
//           title: Text(filteredItems[index]),
//         );
//       },
//     );
//   }
// }
class BodyStatus extends ConsumerWidget {
  TextEditingController controller;
  Function(String)? onChanged;
  final VoidCallback? onClear;
  final String hintText;
  final FocusNode? focusNode;
  BodyStatus(
      {super.key,
      required this.controller,
      required this.onChanged,
      required this.onClear,
      this.focusNode,
      required this.hintText});

  final List<String> statusText = [
    "All",
    "Active",
    "CRM",
    "Duplicate",
    "InActive",
    "Portal Enabled",
    "Portal Disabled",
    "Overdue",
    "Unpaid"
  ];

  final List<String> filterText = [
    "Company Name",
    "Email",
    "Mobile Phone",
    "First Name",
    "Last Name",
  ];

  void showCheckBoxSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Consumer(
            builder: (context, ref, child) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 23, right: 23, top: 23, bottom: 37),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                          text: AppText.filterBy,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: AppColors.appBlackColor,
                          fontFamily: 'SF Pro Display',
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SvgPictureWIidget(
                            image: AppImages.crossSymbol,
                            height: 24,
                            width: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: statusText.length,
                      itemBuilder: (context, index) {
                        final selectedCheckBox =
                            ref.watch(selectedCheckBoxProvider);

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: ReusableText(
                                text: statusText[index],
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.appBlackColor,
                                fontFamily: 'SF Pro Display',
                              ),
                              checkColor: AppColors.appWhiteColor,
                              activeColor: AppColors.appMainColor,
                              value: selectedCheckBox == statusText[index],
                              onChanged: (bool? value) {
                                ref
                                    .read(selectedCheckBoxProvider.notifier)
                                    .state = statusText[index];
                                ref.read(isAllSelectedProvider.notifier).state =
                                    true;
                                ref
                                    .read(selectedStatusProvider.notifier)
                                    .state = null;

                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              },
                            ),
                            if (index < statusText.length - 1)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 23),
                                child: Divider(),
                              )
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  void showFilterCheckBox(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Consumer(
          builder: (context, ref, child) {
            return FractionallySizedBox(
              heightFactor: 0.59,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 100, right: 100, bottom: 29, top: 21),
                    child: SvgPictureWIidget(
                        image: AppImages.indicator, height: 5, width: 144),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: filterText.length,
                      itemBuilder: (context, index) {
                        final selectedFilter =
                            ref.watch(selectedFilterProvider);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: ReusableText(
                                text: filterText[index],
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: AppColors.appBlackColor,
                                fontFamily: 'SF Pro Display',
                              ),
                              checkColor: AppColors.appWhiteColor,
                              activeColor: AppColors.appMainColor,
                              value: selectedFilter == filterText[index],
                              onChanged: (bool? value) {
                                ref
                                    .read(selectedFilterProvider.notifier)
                                    .state = filterText[index];

                                Future.delayed(
                                    const Duration(milliseconds: 200), () {
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                });
                              },
                            ),
                            if (index < filterText.length - 1)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 23),
                                child: Divider(),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  GapSpace.height30,
                  PayzoFormSubmitTwoButtons(
                      cancelText: AppText.clear,
                      saveText: AppText.save,
                      cancelOnPressed: () {
                        ref.read(selectedFilterProvider.notifier).state =
                            filterText[0];

                        final currentFilters =
                            ref.read(selectedFilterProvider.notifier).state;
                      },
                      saveOnPressed: () {})
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print("Building BodyStatus with controller: ${controller.text}");
    return Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 30, bottom: 20),
        child: Row(children: [
          SearchBarUi(
            ref: ref,
            controller: controller,
            focusNode: focusNode,
            onChanged: (value) {
              print("SearchBarUi onChanged called with: $value");
              if (onChanged != null) {
                onChanged!(value);
              }
            },
            onClear: onClear,
            hintText: hintText,
          ),
          // GapSpace.width12,
          // GestureDetector(
          //   onTap: () {
          //     showFilterCheckBox(context, ref);
          //   },
          //   child: SvgPictureWIidget(
          //       image: AppImages.filterIcon, height: 21, width: 21),
          // ),
        ]));
  }
}
