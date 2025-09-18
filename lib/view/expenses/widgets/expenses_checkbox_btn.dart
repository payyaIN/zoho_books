import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/model/expenses_fn_provider.dart';

class ExpensesCheckBoxSection extends ConsumerStatefulWidget {
  const ExpensesCheckBoxSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpensesCheckBoxSectionState();
}

class _ExpensesCheckBoxSectionState extends ConsumerState<ExpensesCheckBoxSection> {
  @override
  Widget build(BuildContext context) {
    final selectionState = ref.watch(expensesSelectionProvider);
    final selectionNotifier = ref.read(expensesSelectionProvider.notifier);

    if (!selectionState.isSelectionMode) {
      return const SizedBox();
    }

    final screenSize = MediaQuery.of(context).size;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: screenSize.width,
        padding: EdgeInsets.only(
          bottom: bottomPadding > 0 ? bottomPadding : 16,
          top: 16,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(-0.02, -1.00),
            end: const Alignment(0.02, 1),
            colors: [
              Colors.white.withOpacity(0.8),
              Colors.white.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          top: false,
          child: PayzoFormSubmitTwoButtons(
            cancelText: AppText.cancel,
            saveText: AppText.approve,
            cancelOnPressed: selectionNotifier.resetSelection,
            saveOnPressed: () {
              final selectedIndices = selectionNotifier.getSelectedIndices();

              // Uncomment below to show confirmation alert
              // bulkApproveExpensesAlert(
              //   context,
              //   AppText.bulkApprvConfrmtn,
              //   AppText.bulkApprvalExpensesSubTitle,
              //   AppText.bulkApprvalExpensesContent,
              //   () {
              //     // actual approval logic
              //   },
              // );

              print('Approving expenses at indices: $selectedIndices');
            },
          ),
        ),
      ),
    );
  }
}
