import 'package:payzo_books/import_data.dart';

class AddressShowerTitleText extends ConsumerWidget {
  final String title;
  const AddressShowerTitleText({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReusableText(
      text: title,
      fontSize: 15,
      overflow: TextOverflow.ellipsis,
      color: AppColors.appBlackColor,
      maxLines: 1,
      fontWeight: FontWeight.bold,
    );
  }
}
