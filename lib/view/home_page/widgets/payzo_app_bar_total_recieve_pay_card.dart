import 'package:payzo_books/data/repository/bills_api/bills_api.dart';
import 'package:payzo_books/data/repository/invoice_api/invoice_detail_api.dart';
import 'package:payzo_books/data/repository/pending_requests/get_pending_request_repo.dart';
import 'package:payzo_books/import_data.dart';
class PayzoAppBarTotalRecievePayCard extends ConsumerWidget {
  const PayzoAppBarTotalRecievePayCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncInvoiceData = ref.watch(getInvoiceData);
    final asyncBillData = ref.watch(getBillData);
    final asyncPendingCount = ref.watch(pendingCountsFutureProvider);
    final isInvoiceLoading = asyncInvoiceData.isLoading;
    final isBillLoading = asyncBillData.isLoading;

    return ScalingFactor(
      child: ReusablePadding(
        padding: const EdgeInsets.only(top: 20, left: 22, right: 22),
        child: ReusableContainer(
          width: 363,
          height: 265,
          color: Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(22)),
          child: ReusableColumn(
            children: [
              const ReusableContainer(
                width: double.infinity,
                height: 153,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  image: DecorationImage(
                    image: AssetImage('assets/unsplash__nWaeTF6qo0.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: PayxoHomeAppBarCardText(),
              ),
              asyncPendingCount.when(data: (data) {
                return ReusableRow(
                  children: <Widget>[
                    PayzoAppBarInVoiceCard(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.pendingInvoices);
                      },
                      text: 'Pending Invoices',
                      number: data.invoice.toString(),
                      isLoading: isInvoiceLoading,
                    ),
                    const ReusableSizedBox(width: 8),
                    PayzoAppBarInVoiceCard(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.pendingBills);
                      },
                      text: 'Pending Bills',
                      number:data.bill.toString(),
                      isLoading: isBillLoading,
                    ),
                  ],
                );
              }, error: (error, stackTrace) {
                return ReusableRow(
                  children: <Widget>[
                    PayzoAppBarInVoiceCard(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.pendingInvoices);
                      },
                      text: 'Pending Invoices',
                      number: '0',
                      isLoading: isInvoiceLoading,
                    ),
                    const ReusableSizedBox(width: 8),
                    PayzoAppBarInVoiceCard(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.pendingBills);
                      },
                      text: 'Pending Bills',
                      number: '0',
                      isLoading: isBillLoading,
                    ),
                  ],
                );
              }, loading: () {
                return ReusableRow(
                  children: <Widget>[
                    PayzoAppBarInVoiceCard(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.pendingInvoices);
                      },
                      text: 'Pending Invoices',
                      number: '0',
                      isLoading: isInvoiceLoading,
                    ),
                    const ReusableSizedBox(width: 8),
                    PayzoAppBarInVoiceCard(
                      onTap: () {
                        Navigator.pushNamed(context, RouteNames.pendingBills);
                      },
                      text: 'Pending Bills',
                      number:'0',
                      isLoading: isBillLoading,
                    ),
                  ],
                );
              },)
            ],
          ),
        ),
      ),
    );
  }
}
