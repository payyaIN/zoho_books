import 'package:payzo_books/import_data.dart';
class SpeedDialChikldrenWidget extends StatelessWidget {
  final String text;
  final String image;
  const SpeedDialChikldrenWidget({super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    return   ReusableColumn(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SvgPictureWidget(
            image:image,
            height: 23,
            width: 18.89),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF7B7B7B),
            fontSize: 8,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w400,
            height: 1.30,
          ),
        )
      ],
    );
  }
}
