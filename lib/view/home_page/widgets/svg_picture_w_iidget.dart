import 'package:payzo_books/import_data.dart';
class SvgPictureWIidget extends StatelessWidget {
  final String image;
  final double height;
  final double width;

  const SvgPictureWIidget({
    super.key,
    required this.image,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: SvgPicture.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}
