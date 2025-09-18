import 'package:payzo_books/import_data.dart';
class HeadingTextPayzo extends StatelessWidget {
  final String text;
  const HeadingTextPayzo({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: SizedBox(
        width: 352,
        child: SizedBox(
          width: 352,
          child: ReusableText(
            text: text,
            color: const Color(0xFF141414),
            fontSize: 20,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w700,
            height: 0.91,
          ),
        ),
      ),
    );
  }
}
