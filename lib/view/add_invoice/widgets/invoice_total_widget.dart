import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/add_invoice/notifier/add_invoice_form_notifier.dart';

class InvoiceTotalWidget extends ConsumerWidget {
  const InvoiceTotalWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Trigger total recalculation before build

    final state = ref.watch(invoiceFormProvider);
    final currencyFormat = NumberFormat.simpleCurrency(locale: 'en_IN');

    final subTotal = state.subTotal ?? 0.0;
    final tax = state.tax ?? 0.0;
    final total = state.total ?? 0.0;

    return ScalingFactor(
      child: ReusableColumn(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          const ReusableSizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ReusableColumn(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  ReusableText(
                    text: 'Sub Total',
                    fontSize: 14,
                    fontFamily: '',
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(102, 102, 102, 1),
                  ),
                  ReusableSizedBox(height: 5),
                  ReusableText(
                    text: 'IGST (0%)',
                    fontSize: 14,
                    fontFamily: '',
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(102, 102, 102, 1),
                  ),
                  ReusableSizedBox(height: 5),
                  ReusableText(
                    text: 'Total',
                    fontSize: 14,
                    fontFamily: '',
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(102, 102, 102, 1),
                  ),
                  ReusableSizedBox(height: 5),
                ],
              ),
              const ReusableSizedBox(width: 32),
              ReusableColumn(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ReusableText(
                    text: currencyFormat.format(subTotal),
                    fontFamily: '',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color.fromRGBO(33, 33, 33, 1),
                  ),
                  ReusableText(
                    text: currencyFormat.format(tax),
                    fontFamily: '',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color.fromRGBO(33, 33, 33, 1),
                  ),
                  ReusableText(
                    text: currencyFormat.format(total),
                    fontFamily: '',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: const Color.fromRGBO(33, 33, 33, 1),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
