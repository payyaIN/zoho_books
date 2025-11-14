import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/add/add_expense/add_expense.dart';
import 'package:payzo_books/view/add/add_invoice/views/add_invoice_new.dart';
import 'package:payzo_books/view/expenses/expenses_listing_screen.dart';
import 'package:payzo_books/view/login_screen/mfa_otp_screen.dart';
import 'package:payzo_books/view/two_step_verification/two_step_verification_screen.dart';

class AppRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case RouteNames.initialRoute:
        return MaterialPageRoute(
            builder: (_) => MonitorConnectionView(child: SplashScreen()),
            settings: routeSettings);
      case RouteNames.loginScreen:
        return MaterialPageRoute(
            builder: (_) => MonitorConnectionView(child: LoginScreen()),
            settings: routeSettings);
      case RouteNames.homeScreen:
        return MaterialPageRoute(
            builder: (_) => MonitorConnectionView(child: const MainScreen()),
            settings: routeSettings);
      case RouteNames.twostepverification:
        return MaterialPageRoute(
            builder: (_) =>
                MonitorConnectionView(child: const TwoStepVerificationScreen()),
            settings: routeSettings);
      case RouteNames.notificationScreen:
        return MaterialPageRoute(
            builder: (_) =>
                MonitorConnectionView(child: const NotificationPage()),
            settings: routeSettings);
      case RouteNames.addCustomer:
        return MaterialPageRoute(
            builder: (_) => MonitorConnectionView(child: const AddCustomer()),
            settings: routeSettings);
      case RouteNames.addVendor:
        return MaterialPageRoute(
            builder: (_) => MonitorConnectionView(child: const AddVendor()),
            settings: routeSettings);
      case RouteNames.addProduct:
        return MaterialPageRoute(
            builder: (_) => MonitorConnectionView(child: const AddProduct()),
            settings: routeSettings);
      // builder: (_) => const AddProduct(), settings: routeSettings);
      case RouteNames.moreScreen:
        return MaterialPageRoute(
            builder: (_) => const MoreScreen(), settings: routeSettings);
      case RouteNames.vendorScreen:
        return MaterialPageRoute(
            builder: (_) => VendorScreen(), settings: routeSettings);
      case RouteNames.addBills:
        return MaterialPageRoute(
            builder: (_) => AddBills(), settings: routeSettings);

      case RouteNames.addInvoice:
        return MaterialPageRoute(
            builder: (_) => AddInvoiceNew(), settings: routeSettings);
      case RouteNames.editProduct:
        return MaterialPageRoute(
            builder: (_) => ProductDetailPage(), settings: routeSettings);
      case RouteNames.billDetailsScreen:
        return MaterialPageRoute(
            builder: (_) => BillDetailPage(), settings: routeSettings);
      case RouteNames.customerDetailsPage:
        return MaterialPageRoute(
            builder: (_) => CustomerDetailPage(), settings: routeSettings);
      case RouteNames.customerScreen:
        return MaterialPageRoute(
            builder: (_) => CustomerScreen(), settings: routeSettings);
      case RouteNames.vendorDetailsPage:
        return MaterialPageRoute(
            builder: (_) => VendorDetailPage(), settings: routeSettings);
      case RouteNames.notificationDetailsPage:
        return MaterialPageRoute(
            builder: (_) => NotificationDetailsPage(), settings: routeSettings);
      case RouteNames.customerScreen:
        return MaterialPageRoute(
            builder: (_) => CustomerScreen(), settings: routeSettings);
      case RouteNames.invoiceDetailsScreen:
        return MaterialPageRoute(
            builder: (_) => InvoiceDetailPage(), settings: routeSettings);
      case RouteNames.productScreen:
        return MaterialPageRoute(
            builder: (_) => ProductPage(), settings: routeSettings);
      case RouteNames.productDetailPage:
        return MaterialPageRoute(
            builder: (_) => ProductDetailPage(), settings: routeSettings);
      case RouteNames.pendingInvoices:
        return MaterialPageRoute(
            builder: (_) => PendingInvoices(), settings: routeSettings);
      case RouteNames.pendingBills:
        return MaterialPageRoute(
            builder: (_) => PendingBills(), settings: routeSettings);
      case RouteNames.mfaScreen:
        return MaterialPageRoute(
            builder: (_) => MfaOtpScreen(), settings: routeSettings);
      case RouteNames.expensesListing:
        return MaterialPageRoute(
            builder: (_) => ExpensesScreen(), settings: routeSettings);
      case RouteNames.addExpense:
        return MaterialPageRoute(
            builder: (_) => AddExpense(), settings: routeSettings);

      default:
        return null;
    }
  }
}
