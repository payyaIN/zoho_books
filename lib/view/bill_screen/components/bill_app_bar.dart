import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_fn_provider.dart';

PreferredSizeWidget billAppBar(
    {required BuildContext context, required WidgetRef ref}) {
  final billSelectionState = ref.watch(billSelectionProvider);
  final billSelectionNotifier = ref.read(billSelectionProvider.notifier);
  return reusableAppBarWithSuffixWidget(
    context: context,
    showTitle: true,
    showBackButton: false,
    isSuffixText: true,
    title: AppText.bills,
    suffixText:
        billSelectionState.isSelectionMode ? AppText.cancel : AppText.select,
    onSuffixTap: () {
      billSelectionNotifier.toggleSelectionMode();
    },
  );
}
