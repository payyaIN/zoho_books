class BillSelectionState {
  final bool isSelectionMode;
  final List<bool> selectedItems;

  BillSelectionState({
    this.isSelectionMode = false,
    List<bool>? selectedItems,
  }) : selectedItems = selectedItems ?? List.filled(7, false);

  BillSelectionState copyWith({
    bool? isSelectionMode,
    List<bool>? selectedItems,
  }) {
    return BillSelectionState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }
}
