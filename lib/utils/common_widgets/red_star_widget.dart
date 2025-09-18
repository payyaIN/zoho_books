import 'package:payzo_books/import_data.dart';

class RedStarWidget extends StatelessWidget {
  const RedStarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ReusableText(
      text:' *',
        color: Colors.red,
        fontSize: 12,
        fontWeight: FontWeight.w600,
    );
  }
}
