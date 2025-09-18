class InvoiceSelectionState {
  final bool isSelectionMode;
  final List<bool> selectedItems;

  InvoiceSelectionState({
    this.isSelectionMode = false,
    List<bool>? selectedItems,
  }) : selectedItems = selectedItems ?? List.filled(7, false);

  InvoiceSelectionState copyWith({
    bool? isSelectionMode,
    List<bool>? selectedItems,
  }) {
    return InvoiceSelectionState(
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      selectedItems: selectedItems ?? this.selectedItems,
    );
  }
}
