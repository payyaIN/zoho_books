import 'package:payzo_books/import_data.dart';

PreferredSizeWidget vendorAppBar({
  required BuildContext context,
}) {
  return reusableAppBar(
      context: context, title: AppText.vendors, showBackButton: true);
}
