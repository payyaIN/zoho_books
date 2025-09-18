import 'package:payzo_books/import_data.dart';

class PayzoHomeAppbarSvgBackground extends StatelessWidget {
  const PayzoHomeAppbarSvgBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -60,
      left: 53,
      child: ReusableSizedBox(
        width: 305.07,
        height: 433.92,
        child: SvgPicture.asset(
          'assets/Vector.svg',
        ),
      ),
    );
  }
}
