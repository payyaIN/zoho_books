import 'package:payzo_books/import_data.dart';

class HomeAppbarBackground extends StatelessWidget {
  const HomeAppbarBackground({super.key});

  @override
  Widget build(BuildContext context) {
    Color topBackgroundContainerColor = const Color(0xFF3F53EE);
    return  ReusableContainer(
      color: topBackgroundContainerColor,
      height: 266,
      width: double.infinity,
      borderRadius: const BorderRadius.all(Radius.circular(30)),
    );
  }
}
