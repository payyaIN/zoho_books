import 'package:payzo_books/import_data.dart';

final selectedStatusProvider = StateProvider<String?>((ref) => null);
final selectedFilterProvider = StateProvider<String?>((ref) => null);
final selectedCheckBoxProvider = StateProvider<String>((ref) => AppText.all);
final isAllSelectedProvider = StateProvider<bool>((ref) => true);
