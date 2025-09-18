import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/bill_model/bill_model.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_notifier.dart';

import '../../../import_data.dart';

class BillSelectionNotifier extends StateNotifier<BillSelectionState> {
  BillSelectionNotifier() : super(BillSelectionState());

  void toggleSelectionMode() {
    state = state.copyWith(
      isSelectionMode: !state.isSelectionMode,
      selectedItems: state.isSelectionMode
          ? List.filled(state.selectedItems.length, false)
          : state.selectedItems,
    );
  }

  void toggleItemSelection(int index) {
    if (index >= state.selectedItems.length) {
      final updatedList = List<bool>.from(state.selectedItems);
      while (updatedList.length <= index) {
        updatedList.add(false);
      }
      state = state.copyWith(selectedItems: updatedList);
    }

    final updatedSelectedItems = List<bool>.from(state.selectedItems);
    updatedSelectedItems[index] = !updatedSelectedItems[index];

    state = state.copyWith(
      selectedItems: updatedSelectedItems,
      isSelectionMode: true,
    );
  }

  void updateSelectionSize(int size) {
    if (state.selectedItems.length != size) {
      state = state.copyWith(
        selectedItems: List.filled(size, false),
      );
    }
  }

  void resetSelection() {
    state = state.copyWith(
      isSelectionMode: false,
      selectedItems: List.filled(state.selectedItems.length, false),
    );
  }

  List<int> getSelectedIndices() {
    return List.generate(state.selectedItems.length,
            (index) => state.selectedItems[index] ? index : -1)
        .where((index) => index != -1)
        .toList();
  }
}

final billSelectionProvider =
    StateNotifierProvider<BillSelectionNotifier, BillSelectionState>((ref) {
  return BillSelectionNotifier();
});
