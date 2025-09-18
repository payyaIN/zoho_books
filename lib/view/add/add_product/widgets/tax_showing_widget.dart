import 'package:payzo_books/import_data.dart';

class TaxShowingWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final String detail;

  const TaxShowingWidget(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.detail});

  @override
  Widget build(BuildContext context) {
    return ReusableColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ReusableSizedBox(
            height: 8,
          ),
          ReusableText(text: title),
          ReusableSizedBox(
            height: 8,
          ),
          ReusableRow(children: <Widget>[
            ReusableText(text: subTitle,color: AppColors.appMainColor,),
            Spacer(),
            ReusableText(text: detail,color: AppColors.appMainColor,),
          ]),
          ReusableSizedBox(
            height: 8,
          ),
        ]);
  }
}
