import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_screen/components/bill_bulk_approve_box.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_fn_provider.dart';

class BillCheckBoxSection extends ConsumerStatefulWidget {
  const BillCheckBoxSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BillCheckBoxSectionState();
}

class _BillCheckBoxSectionState extends ConsumerState<BillCheckBoxSection> {
  @override
  Widget build(BuildContext context) {
    final billSelectionState = ref.watch(billSelectionProvider);
    final billSelectionNotifier = ref.read(billSelectionProvider.notifier);

    if (!billSelectionState.isSelectionMode) {
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
            right: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.02, -1.00),
            end: Alignment(0.02, 1),
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
              cancelOnPressed: billSelectionNotifier.resetSelection,
              saveOnPressed: () {
                final selectedIndices =
                    billSelectionNotifier.getSelectedIndices();
                // bulkApproveAlert(
                //     context,
                //     AppText.bulkApprvConfrmtn,
                //     AppText.bulkApprvalBillsSubTitle,
                //     AppText.bulkApprvalBillscontent,
                //     () {});
                print('Approving bills at indices: $selectedIndices');
              }),
        ),
      ),
    );
  }
}
