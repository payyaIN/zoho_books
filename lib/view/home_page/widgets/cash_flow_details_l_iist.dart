import 'package:payzo_books/import_data.dart';
class CashFlowDetailsLIist extends StatelessWidget {
  final String text;
  final Color color;
  final Widget price;
  final bool divider;
  const CashFlowDetailsLIist({super.key, required this.text, required this.color, required this.price, required this.divider});

  @override
  Widget build(BuildContext context) {
    return ReusableColumn(
      children: [
        const ReusableSizedBox(height: 15,),
        Container(
          width: 316,
          height: 17.6,
          child:  Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ReusableText(
                text: text,
                  color: color,
                  fontSize: 14,
                  fontFamily: 'SF Pro Display',
                  fontWeight: FontWeight.w500,
              ),
              Spacer(),
              price
            ],
          ),
        ),
        const ReusableSizedBox(height: 15,),
        divider==true?Container(
          width: 328,
          decoration: const ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 0.4,
                strokeAlign: BorderSide.strokeAlignCenter,
                color: Color(0xFFC9C9C9),
              ),
            ),
          ),
        ):ReusableSizedBox()
      ],
    );
  }
}
