import 'package:flutter/material.dart';
import 'package:payzo_books/utils/common_widgets/reusable_sized_box.dart';

import '../../import_data.dart';

class SarTextfield extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  const SarTextfield({Key? key, required this.onTap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ReusableSizedBox(
        width: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ReusableText(
              text: title,
              fontSize: 12,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w700,
              color: AppColors.appMainColor,
            ),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}
