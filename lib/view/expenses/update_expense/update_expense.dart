import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_invoice/get_customer_list_repo.dart';
import 'package:payzo_books/data/repository/add_product/get_all_account_list_repository.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/provider/edit_expense_provider.dart';
import 'package:payzo_books/view/expenses/update_expense/expense_document_picker.dart';
import 'package:payzo_books/view/expenses/update_expense/update_expense_total_shower.dart';
import '../../../data/repository/add_invoice/get_tax_list_repo.dart';

class UpdateExpensePage extends ConsumerStatefulWidget {
  const UpdateExpensePage({super.key});

  @override
  ConsumerState<UpdateExpensePage> createState() => _AddExpenseState();
}

class _AddExpenseState extends ConsumerState<UpdateExpensePage> {
  bool _isDataLoaded = false;
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      ref.read(fetchBranchListProvider);
      ref.read(getVendorList);
      ref.read(fetchAllTaxesProvider);
      ref.read(fetchPriceCurrencyProvider);
      ref.read(getChartOfAccountsProvider);
      ref.read(fetchCustomerListProvider);
      //
      // // === 📌 Branch
      // final branchData = await ref.read(fetchBranchListProvider.future);
      // if (branchData.data?.isNotEmpty == true) {
      //   final branch = branchData.data!.first;
      //   ref.read(branchProvider.notifier).state = branch.namePrimary ?? '';
      //   ref.read(branchIdProvider.notifier).state = branch.branchId;
      // }

      // === 💱 Currency
      final currencyData = await ref.read(fetchPriceCurrencyProvider.future);
      if (currencyData.isNotEmpty) {
        final currency = currencyData.first;
        ref.read(expenseCurrencyProvider.notifier).state =
            currency.currencyValue ?? 'SAR';
        ref.read(expenseCurrencyIdProvider.notifier).state =
            currency.currencyId?.toInt();
      }

      // // === 🧾 Tax
      // final taxData = await ref.read(fetchAllTaxesProvider.future);
      // if (taxData.defaultTax.isNotEmpty) {
      //   final tax = taxData.defaultTax.first;
      //   ref.read(taxProvider.notifier).state = tax.taxName ?? '';
      //   ref.read(taxIdProvider.notifier).state = tax.taxId;
      //   ref.read(showExemptionReasonProvider.notifier).state = tax.taxType == 'non-taxable';
      //   ref.read(taxJsonProvider.notifier).state = {
      //     "taxId": tax.taxId,
      //     "taxType": tax.taxType,
      //   };
      // }

      // // === 💼 Expense Account + 💳 Paid Through
      // final accounts = await ref.read(getChartOfAccountsProvider.future);
      // if (accounts.response.length >= 2) {
      //   final expense = accounts.response[0];
      //   final paidThrough = accounts.response[1];
      //
      //   ref.read(expenseAccountProvider.notifier).state = expense.label ?? '';
      //   ref.read(expenseAccountIdProvider.notifier).state = expense.value;
      //
      //   ref.read(paidThroughProvider.notifier).state = paidThrough.label ?? '';
      //   ref.read(paidThroughIdProvider.notifier).state = paidThrough.value;
      // }

      // // === 🏢 Vendor
      // final vendorData = await ref.read(getVendorList.future);
      // final vendor = vendorData.response?.response?.first;
      // if (vendor != null) {
      //   ref.read(vendorProvider.notifier).state = vendor.displayName ?? '';
      //   ref.read(vendorIdProvider.notifier).state = vendor.partyId;
      // }
      //
      // // === 👤 Customer
      // final customers = await ref.read(fetchCustomerListProvider.future);
      // if (customers.isNotEmpty) {
      //   final customer = customers.first;
      //   ref.read(customerProvider.notifier).state = customer.displayName ?? '';
      //   ref.read(customerIdProvider.notifier).state = customer.partyId;
      // }

      // === 📅 Date
      ref.read(dateProvider.notifier).state = DateTime.now();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExpenseData();
    });
  }

  Future<void> _loadExpenseData() async {
    if (_isDataLoaded) return;

    try {
      // Fetch expense details
      final expenseDetails =
          await ref.read(getExpenseDetailsProvider(widget.expenseId).future);

      if (expenseDetails.response != null) {
        final data = expenseDetails.response!;

        // Set edit mode
        ref.read(editExpenseModeProvider.notifier).state = true;
        ref.read(editExpenseIdProvider.notifier).state = widget.expenseId;

        // Populate text controllers
        if (data.expenseAmount != null) {
          ref.read(amountControllerProvider).text =
              data.expenseAmount.toString();
        }
        if (data.reference != null) {
          ref.read(referenceControllerProvider).text = data.reference!;
        }
        if (data.expenseDescription != null) {
          ref.read(notesControllerProvider).text = data.expenseDescription!;
        }

        // Set date
        if (data.date != null) {
          try {
            ref.read(dateProvider.notifier).state = DateTime.parse(data.date!);
          } catch (e) {
            print('Error parsing date: $e');
          }
        }

        // Set branch
        if (data.branchId != null) {
          ref.read(branchIdProvider.notifier).state = data.branchId;
          ref.read(branchProvider.notifier).state = data.branch ?? '';
        }

        // Set currency
        if (data.currencyId != null) {
          ref.read(expenseCurrencyIdProvider.notifier).state = data.currencyId;
          ref.read(expenseCurrencyProvider.notifier).state =
              data.currency ?? '';
        }

        // Set expense account
        if (data.expenseAccountId != null) {
          ref.read(expenseAccountIdProvider.notifier).state =
              data.expenseAccountId;
          ref.read(expenseAccountProvider.notifier).state =
              data.expenseAccount ?? '';
        }

        // Set paid through account
        if (data.paidThroughAccountId != null) {
          ref.read(paidThroughIdProvider.notifier).state =
              data.paidThroughAccountId;
          ref.read(paidThroughProvider.notifier).state =
              data.paidThroughAccount ?? '';
        }

        // Set vendor
        if (data.vendorId != null) {
          ref.read(vendorIdProvider.notifier).state = data.vendorId;
          ref.read(vendorProvider.notifier).state = data.vendor ?? '';
        }

        // Set customer
        if (data.customerId != null) {
          ref.read(customerIdProvider.notifier).state = data.customerId;
          ref.read(customerProvider.notifier).state = data.customerName ?? '';
        }

        // Set tax
        if (data.taxId != null) {
          ref.read(taxIdProvider.notifier).state = data.taxId;
          ref.read(taxProvider.notifier).state = data.taxName ?? '';
        }

        // Mark as loaded
        setState(() {
          _isDataLoaded = true;
        });
      }
    } catch (e) {
      print('Error loading expense data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading expense data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    // Clear edit mode when leaving
    ref.read(editExpenseModeProvider.notifier).state = false;
    ref.read(editExpenseIdProvider.notifier).state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Scaffold(
        appBar: reusableAppBar(
          title: 'Edit Expenses',
          showBackButton: true,
          context: context,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: ReusableColumn(
              children: [
                const ReusableSizedBox(height: 15),
                const AddExpenseForm(),
                const ReusableSizedBox(height: 15),
                const ExpenseDocumentPicker(),
                const ReusableSizedBox(height: 15),
                const AddExpenseTotalShower(),
                const ReusableSizedBox(height: 15),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const AddExpenseSubmitButton(),
      ),
    );
  }
}
