import 'package:payzo_books/import_data.dart';

SizedBox floatingActionBtn({required VoidCallback onPress}) {
  return SizedBox(
    height: 65,
    width: 65,
    child: FloatingActionButton(
        backgroundColor: AppColors.appMainColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.appWhiteColor),
        onPressed: onPress),
  );
}
