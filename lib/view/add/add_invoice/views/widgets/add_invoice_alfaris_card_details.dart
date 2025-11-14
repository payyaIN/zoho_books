import 'package:intl/intl.dart';
import '../../../../../import_data.dart';


final availableCreditProvider = StateProvider<double>((ref) => 0.00);
final unpaidInvoicesProvider = StateProvider<int>((ref) => 0);
final totalAmountProvider = StateProvider<double>((ref) => 6018063.00);
final lastInvoiceDateProvider = StateProvider<DateTime?>((ref) => DateTime(2025, 10, 7));

final currencyFormatterProvider = Provider<NumberFormat>((ref) => NumberFormat.currency(symbol: 'AED ', decimalDigits: 2));

class AlfariDetailsCard extends ConsumerWidget {
  const AlfariDetailsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final availableCredit = ref.watch(availableCreditProvider);
    final unpaidInvoices = ref.watch(unpaidInvoicesProvider);
    final totalAmount = ref.watch(totalAmountProvider);
    final lastInvoice = ref.watch(lastInvoiceDateProvider);
    final currency = ref.watch(currencyFormatterProvider);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header purple bar
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 12),
              color: Color(0xFF6A23E8), // purple tone
              alignment: Alignment.center,
              child: Text(
                "Alfari's Details",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Available credit row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Available Credit:', style: TextStyle(color: Colors.black54)),
                            SizedBox(height: 6),
                            Text(currency.format(availableCredit), style: TextStyle(fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          // You can replace this with a provider action or navigation
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Apply tapped')));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6A23E8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          elevation: 0,
                        ),
                        child: Text('Apply', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),

                  SizedBox(height: 14),

                  // Unpaid invoices box
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF6F2FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text('Unpaid Invoices', style: TextStyle(color: Colors.black54)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(unpaidInvoices.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF6A23E8))),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 14),

                  // Totals
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Amount', style: TextStyle(color: Colors.black54)),
                            SizedBox(height: 6),
                            Text(currency.format(totalAmount), style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Last Invoice', style: TextStyle(color: Colors.black54)),
                            SizedBox(height: 6),
                            Text(lastInvoice != null ? DateFormat('MMM dd, yyyy').format(lastInvoice) : '—', style: TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Footer purple button
            InkWell(
              onTap: () {
                // navigate to invoices
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 14),
                color: Color(0xFF6A23E8),
                alignment: Alignment.center,
                child: Text('View All Invoices', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}