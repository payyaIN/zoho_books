import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/add/add_invoice/views/widgets/selected_customer_details_shower_invoice_new.dart';

class InvoiceDetailsFieldsNew extends ConsumerWidget {
  const InvoiceDetailsFieldsNew({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomExpansionTile(
      title: 'Invoice Details',
      isExpanded: true,
      onToggle: () {},
      height: 2,
      child: ReusableColumn(
        children: [
          CustomerNameFieldAddInvoiceNew(),
          SelectedCustomerDetailsShowerInvoiceNew(title: 'BILLING ADDRESS', secondTitle: 'SHIPPING ADDRESS')
        ],
      ),
    );
  }
}
