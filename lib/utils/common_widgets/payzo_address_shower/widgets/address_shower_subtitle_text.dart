import 'package:payzo_books/import_data.dart';

class AddressShowerSubtitleText extends ConsumerWidget {
  final String title;
  const AddressShowerSubtitleText({super.key, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReusableText(
      text: title,
      fontSize: 12,
      overflow: TextOverflow.ellipsis,
      color: AppColors.appBlackColor,
      maxLines: 10,
      fontWeight: FontWeight.normal,
    );
  }
}
