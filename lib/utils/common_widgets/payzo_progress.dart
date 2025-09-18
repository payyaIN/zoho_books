import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:payzo_books/import_data.dart';

class PayzoCircularLoader extends StatelessWidget {
  const PayzoCircularLoader({super.key, this.size = 40});

  final double size;

  static  Color appMainColor = AppColors.appMainColor.withValues(
  );


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: 4.0,
        valueColor:  AlwaysStoppedAnimation<Color>(appMainColor),
        backgroundColor: appMainColor.withValues(
          alpha: 0.2
        ),
      ),
    );
  }
}
final isLoadingProvider = StateProvider<bool>((ref) => false);

Future<void> showPayzoProgress({
  required BuildContext context,
  bool dismissible = false,
}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierColor: Colors.black.withValues(alpha: 0.3), // Dim background
    builder: (context) => Center(
      child: ReusableColumn(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ReusableContainer(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height:30,width: 30,
                    child: const PayzoCircularLoader()),
                // ReusableSizedBox(height: 10,),
                // ReusableText(text: 'Loading...',fontWeight: FontWeight.w500,)
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// final isLoading = ref.watch(isLoadingProvider);