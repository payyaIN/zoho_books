import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/payzo_address_shower/providers/payzo_address_shower_provider.dart' show payzoFirstAddressListProvider, payzoSecondAddressListProvider;
import 'package:payzo_books/utils/common_widgets/payzo_address_shower/widgets/first_address_reusable.dart';

import '../../providers/invoice_address_providers.dart';

class SelectedCustomerDetailsShowerInvoiceNew extends ConsumerWidget {
  final String title;
  final String secondTitle;

  const SelectedCustomerDetailsShowerInvoiceNew({
    super.key,
    required this.title,
    required this.secondTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firstList = ref.watch(invoiceBillingAddressProvider);
    final secondList = ref.watch(invoiceShippingAddressProvider);

    return firstList.isEmpty && secondList.isEmpty
        ? const SizedBox.shrink()
        : ScalingFactor(
      child: ReusableColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ReusableRow(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                  child: FirstAddressReusable(
                      title: title, firstAddressList: firstList)),
              const SizedBox(width: 16),
              Expanded(
                  child: FirstAddressReusable(
                      title: secondTitle, firstAddressList: secondList)),
            ],
          ),
          const SizedBox(height: 6),
          PayzoDivider(),
          const SizedBox(height: 5),
        ],      ),
    );
  }
}
