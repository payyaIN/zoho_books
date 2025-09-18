class ExpensesSelectionState {
  final bool isSelectionMode;
  final List<bool> selectedItems;

  ExpensesSelectionState({
    this.isSelectionMode = false,
    List<bool>? selectedItems,
  }) : selectedItems = selectedItems ?? List.filled(7, false);

  ExpensesSelectionState copyWith({
    bool? isSelectionMode,
    List<bool>? selectedItems,
  }) {
    return ExpensesSelectionState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }
}
