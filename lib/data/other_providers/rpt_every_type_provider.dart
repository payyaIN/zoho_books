import 'package:payzo_books/data/models/rpt_every_type/rpt_every_type_model.dart';
import 'package:payzo_books/import_data.dart';

class RepeatTypeNotifier extends StateNotifier<GetAllRptEveryTypeModel?> {
  RepeatTypeNotifier() : super(null);

  void setRepeatTypeData(GetAllRptEveryTypeModel typeModel) {
    state = typeModel;
  }

  void clearRepeatTypeData() {
    state = null;
  }
}

final repeatTypeProvider =
    StateNotifierProvider<RepeatTypeNotifier, GetAllRptEveryTypeModel?>((ref) {
  return RepeatTypeNotifier();
});

final selectedRepeatTypeProvider =
    StateProvider<RepeatTypeItem?>((ref) => null);

void setSelectedRepeatType(WidgetRef ref, RepeatTypeItem item) {
  ref.read(selectedRepeatTypeProvider.notifier).state = item;
}

RepeatTypeItem? getSelectedRepeatType(WidgetRef ref) {
  return ref.read(selectedRepeatTypeProvider);
}

final repeatTypeByValueProvider =
    Provider.family<RepeatTypeItem?, int>((ref, value) {
  final typeModel = ref.watch(repeatTypeProvider);
  if (typeModel == null) return null;

  try {
    return typeModel.items.firstWhere((item) => item.value == value);
  } catch (e) {
    print('Repeat type item with value $value not found');
    return null;
  }
});

final repeatTypeByLabelPatternProvider =
    Provider.family<List<RepeatTypeItem>, String>((ref, pattern) {
  final typeModel = ref.watch(repeatTypeProvider);
  if (typeModel == null) return [];

  final lowerPattern = pattern.toLowerCase();
  return typeModel.items
      .where((item) => item.label.toLowerCase().contains(lowerPattern))
      .toList();
});
