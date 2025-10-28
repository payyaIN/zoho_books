import 'package:intl/intl.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/add/add_billls/notifier/add_bill_form_notifier.dart';
import 'package:payzo_books/view/add/add_billls/widgets/global_discount_field.dart';
import 'package:payzo_books/view/add_invoice/notifier/add_invoice_form_notifier.dart';
import '../notifier/add_bill_providers.dart';

class BillTotalWidget extends ConsumerWidget {
  const BillTotalWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addBillFormProvider);
    final discountState = ref.watch(payzoDiscountProvider); // 👈 watch discount state
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'en_IN');
    final controller = ref.read(addBillGlobalDiscountProvider);

    // Fallback to 0.0 if any are null
    final subTotal = state.subTotal ?? 0.0;
    final tax = state.tax ?? 0.0;
    final total = state.total ?? 0.0;

    // ✅ condition: show GlobalDiscountField only if checkbox ON and global level selected
    final showGlobalDiscount = discountState.apply &&
        discountState.level == PayzoDiscountLevel.global;

    return ScalingFactor(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ReusableSizedBox(height: 10),

            /// Subtotal Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ReusableText(
                  text: 'Sub Total',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
                ReusableText(
                  text: currencyFormat.format(subTotal),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: const Color.fromRGBO(33, 33, 33, 1),
                ),
              ],
            ),

            const ReusableSizedBox(height: 12),

            /// ✅ Conditionally show Global Discount Field
            if (showGlobalDiscount)
              Align(
                alignment: Alignment.centerRight,
                child: GlobalDiscountField(controller: controller),
              ),

            if (showGlobalDiscount) const ReusableSizedBox(height: 12),

            /// IGST Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ReusableText(
                  text: 'IGST (0%)',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(102, 102, 102, 1),
                ),
                ReusableText(
                  text: currencyFormat.format(tax),
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: const Color.fromRGBO(33, 33, 33, 1),
                ),
              ],
            ),

            const ReusableSizedBox(height: 12),

            /// Divider for clarity
            const Divider(thickness: 0.8, color: Color(0xFFDDDDDD)),

            const ReusableSizedBox(height: 10),

            /// Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const ReusableText(
                  text: 'Total',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(33, 33, 33, 1),
                ),
                ReusableText(
                  text: currencyFormat.format(total),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColors.appMainColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
