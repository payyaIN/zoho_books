import 'package:payzo_books/data/models/unit_list_model/unit_list_model.dart';
import 'package:payzo_books/import_data.dart';

class UnitListNotifier extends StateNotifier<UnitListModel?> {
  UnitListNotifier() : super(null);

  void setUnitListData(UnitListModel unitModel) {
    state = unitModel;
  }

  void clearUnitListData() {
    state = null;
  }
}

final unitListProvider =
    StateNotifierProvider<UnitListNotifier, UnitListModel?>((ref) {
  return UnitListNotifier();
});

final selectedUnitProvider = StateProvider<UnitItem?>((ref) => null);

void setSelectedUnit(WidgetRef ref, UnitItem unit) {
  ref.read(selectedUnitProvider.notifier).state = unit;
}

UnitItem? getSelectedUnit(WidgetRef ref) {
  return ref.read(selectedUnitProvider);
}

final unitsByGroupProvider =
    Provider.family<Map<String?, List<UnitItem>>, UnitListModel?>((ref, model) {
  if (model == null || model.units.isEmpty) {
    return {};
  }

  Map<String?, List<UnitItem>> groupedUnits = {};

  for (var unit in model.units) {
    if (!groupedUnits.containsKey(unit.groupName)) {
      groupedUnits[unit.groupName] = [];
    }
    groupedUnits[unit.groupName]!.add(unit);
  }

  return groupedUnits;
});

final unitGroupsProvider =
    Provider.family<List<String?>, UnitListModel?>((ref, model) {
  if (model == null || model.units.isEmpty) {
    return [];
  }

  Set<String?> uniqueGroups = model.units.map((unit) => unit.groupName).toSet();
  return uniqueGroups.toList()
    ..sort((a, b) {
      if (a == null) return -1;
      if (b == null) return 1;
      return a.compareTo(b);
    });
});
