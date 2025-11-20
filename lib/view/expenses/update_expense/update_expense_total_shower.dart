import 'package:intl/intl.dart';
import 'package:payzo_books/import_data.dart';
import 'update_expense_total_widget.dart'; // adjust path if needed

class AddExpenseTotalShower extends ConsumerWidget {
  const AddExpenseTotalShower({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // schedule calculation after the frame finishes building
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // safe: runs after build completes
      ref.read(addExpenseProvider.notifier).calculateTotal(context, ref);
    });

    // Read numeric providers
    final subtotalVal = ref.watch(addExpenseSubtotalProvider) ?? 0.0;
    final taxAmountVal = ref.watch(addExpenseTaxAmountProvider) ?? 0.0;
    final totalVal = ref.watch(addExpenseTotalProvider) ?? 0.0;
    final taxName = ref.watch(addExpenseSelectedTaxNameProvider) ?? 'Zero Rate';

    // Currency code (fallback to AED)
    final currencyCode = ref.watch(expenseCurrencyProvider) ?? 'AED';

    // Format number WITHOUT symbol, then prepend currency + space
    final numberFormatter = NumberFormat.currency(symbol: '', decimalDigits: 2);
    final subTotalStr =
        '$currencyCode ${numberFormatter.format(subtotalVal).trim()}';
    final taxAmountStr =
        '$currencyCode ${numberFormatter.format(taxAmountVal).trim()}';
    final totalStr = '$currencyCode ${numberFormatter.format(totalVal).trim()}';

    // taxType (you used taxType and taxTypeText fields in AddExpenseTotal)
    // We'll pass taxAmountStr as taxType and taxName as taxTypeText
    return AddExpenseTotal(
      taxType: taxAmountStr,
      taxTypeText: taxName,
      subTotal: subTotalStr,
      total: totalStr,
    );
  }
}
