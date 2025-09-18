import 'package:payzo_books/data/repository/bills_api/bills_api.dart';
import 'package:payzo_books/data/repository/invoice_api/invoice_detail_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/home_page/notifier/speed_dial_notifier.dart';
import 'package:payzo_books/view/home_page/widgets/income_and_expenses/income_and_expenses_widget.dart';
import 'package:payzo_books/view/main_screen/notifiers/dashboard_notifier.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
RouteObserver<ModalRoute<void>>();
final pendingInvoiceCountProvider = StateProvider<int>((ref) => 0);

class PayzoHome extends ConsumerStatefulWidget {
  const PayzoHome({super.key});

  @override
  ConsumerState<PayzoHome> createState() => _PayzoHomeState();
}

class _PayzoHomeState extends ConsumerState<PayzoHome> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.watch(fetchIncomeAndExpenses);
    ref.watch(getInvoiceData);
    ref.watch(pendingBillListProvider);
    ref.watch(getBillData);
    ref.watch(pendingInvoicesProvider); // preload pending invoices here
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    ref.read(speedDialProvider.notifier).close();
  }

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scaffold(
          extendBody: true,
          backgroundColor: AppColors.backgroundColorGrey,
          body: ReusableListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: <Widget>[
              AccountNameWidget(),
              PayzoSwipableTopBar(),
              PayzoAppBarTotalRecievePayCard(),
              CashFlowWidget(),
              IncomeAndExpensesWidget(),
              ReusableSizedBox(height: 15),
            ],
          ),
          floatingActionButton: const CustomFabMenu(),
        ),
      ),
    );
  }
}