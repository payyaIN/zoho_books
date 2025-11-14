import 'package:flutter/foundation.dart';
import 'package:payzo_books/import_data.dart';
import '../../controllers/add_invoice_new_controller.dart';
import '../../providers/add_invoice_providers_new.dart';
class CustomerNameFieldAddInvoiceNew extends ConsumerWidget {
  const CustomerNameFieldAddInvoiceNew({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final customerName = ref.watch(customerNameAddInvoiceProvider);
    final customerError = ref.watch(customerNameAddInvoiceErrorProvider);
    return ScalingFactor(child:PayzoBottomsheetNavigator(
      required: true,
      isPayzoColor: true,
      title: 'Customer Name',
      trailing: customerName ?? 'Tap to select',
      errorText: customerError,
      onTap: () async {
        try {
          await ref
              .read(addInvoiceNewControllerProvider.notifier)
              .selectCustomer(context);
        } catch (e, st) {
          if (kDebugMode) {
            print('Error selecting customer: $e');
            print(st);
          }
        }
      },
    ),);
  }
}
