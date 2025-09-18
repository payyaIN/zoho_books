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

// import 'package:payzo_books/data/repository/bills_api/bills_api.dart';
// import 'package:payzo_books/data/repository/invoice_api/invoice_detail_api.dart';
// import 'package:payzo_books/import_data.dart';
// import 'package:payzo_books/view/home_page/notifier/speed_dial_notifier.dart';
// import 'package:payzo_books/view/home_page/widgets/income_and_expenses/income_and_expenses_widget.dart';
// import 'package:payzo_books/view/main_screen/notifiers/dashboard_notifier.dart';

// import 'package:payzo_books/utils/app_data/shared_preference_key.dart';
// import 'package:payzo_books/data/services/shared_preference_service.dart';

// final RouteObserver<ModalRoute<void>> routeObserver =
//     RouteObserver<ModalRoute<void>>();
// final pendingInvoiceCountProvider = StateProvider<int>((ref) => 0);

// class PayzoHome extends ConsumerStatefulWidget {
//   const PayzoHome({super.key});

//   @override
//   ConsumerState<PayzoHome> createState() => _PayzoHomeState();
// }

// class _PayzoHomeState extends ConsumerState<PayzoHome> with RouteAware {
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

//     _safelyLoadHomeData();

//     routeObserver.subscribe(this, ModalRoute.of(context)!);
//   }

//   /// Safely loads home screen data only if user is authenticated
//   void _safelyLoadHomeData() {
//     // Check if user has valid auth token before loading any data
//     final accessToken =
//         SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken);

//     if (accessToken == null || accessToken.isEmpty) {
//       print(
//           '❌ No valid auth token found - skipping data load to prevent old data');
//       return;
//     }

//     print('✅ Valid auth token found - safely loading home screen data');

//     // Add a small delay to ensure provider invalidation has completed
//     Future.delayed(Duration(milliseconds: 100), () {
//       if (mounted) {
//         ref.read(fetchIncomeAndExpenses);
//         ref.read(getInvoiceData);
//         ref.read(pendingBillListProvider);
//         ref.read(getBillData);
//         ref.read(pendingInvoicesProvider);

//         print('📊 Home screen data loading initiated for authenticated user');
//       }
//     });
//   }

//   @override
//   void dispose() {
//     routeObserver.unsubscribe(this);
//     super.dispose();
//   }

//   @override
//   void didPopNext() {
//     ref.read(speedDialProvider.notifier).close();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScalingFactor(
//       child: MediaQuery.removePadding(
//         context: context,
//         removeTop: true,
//         child: Scaffold(
//           extendBody: true,
//           backgroundColor: AppColors.backgroundColorGrey,
//           body: ReusableListView(
//             physics: const BouncingScrollPhysics(),
//             shrinkWrap: true,
//             children: <Widget>[
//               AccountNameWidget(),
//               PayzoSwipableTopBar(),
//               PayzoAppBarTotalRecievePayCard(),
//               CashFlowWidget(),
//               IncomeAndExpensesWidget(),
//               ReusableSizedBox(height: 15),
//             ],
//           ),
//           floatingActionButton: const CustomFabMenu(),
//         ),
//       ),
//     );
//   }
// }
