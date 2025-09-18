import 'package:payzo_books/import_data.dart';

Widget singleButton({
  required String btnText,
  required VoidCallback onPress,
  required double height,
  required double width,
  bool? isExpandNeeded,
}) {
  return isExpandNeeded == true
      ? Expanded(
          child: SizedBox(
            height: height,
            width: width,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appMainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)))),
              onPressed: onPress,
              child: ReusableText(
                text: btnText,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color.fromRGBO(247, 247, 247, 1),
              ),
            ),
          ),
        )
      : Center(
          child: SizedBox(
            height: height,
            width: width,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appMainColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)))),
              onPressed: onPress,
              child: ReusableText(
                text: btnText,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color.fromRGBO(247, 247, 247, 1),
              ),
            ),
          ),
        );
}
