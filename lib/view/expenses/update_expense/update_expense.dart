import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_invoice/get_customer_list_repo.dart';
import 'package:payzo_books/data/repository/add_invoice/get_tax_list_repo.dart';
import 'package:payzo_books/data/repository/add_product/get_all_account_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_all_bills_repository.dart';
import 'package:payzo_books/view/expenses/expense_edit_screen.dart';
import 'package:payzo_books/view/expenses/repo/expense_details_repo.dart';

class UpdateExpenseScreen extends ConsumerStatefulWidget {
  final int expenseId;

  const UpdateExpenseScreen({
    Key? key,
    required this.expenseId,
  }) : super(key: key);

  @override
  ConsumerState<UpdateExpenseScreen> createState() =>
      _UpdateExpenseScreenState();
}

class _UpdateExpenseScreenState extends ConsumerState<UpdateExpenseScreen> {
  bool _isLoadingData = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllRequiredData();
    });
  }

  Future<void> _loadAllRequiredData() async {
    try {
      setState(() {
        _isLoadingData = true;
        _errorMessage = null;
      });

      print('🔄 Loading all required data for expense edit...');

      // Load all APIs in parallel
      await Future.wait([
        // 1. Branch List
        ref.read(fetchBranchListProvider.future),

        // 2. Expense Account List
        ref.read(getChartOfAccountsProvider.future),

        // 3. All Accounts (for Paid Through)
        ref.read(fetchAccountListProvider.future),

        // 4. Customer List - CORRECT provider name
        ref.read(getCustomerListProvider.future),

        // 5. Vendor List - CORRECT provider name
        ref.read(getVendorListProvider.future),

        // 6. Tax List
        ref.read(fetchAllTaxesProvider.future),

        // 7. Currency List - CORRECT provider name
        ref.read(fetchPriceCurrencyProvider.future),

        // 8. Expense Details
        ref.read(getExpenseDetailsProvider(widget.expenseId).future),
      ]);

      print('✅ All required data loaded successfully');

      setState(() {
        _isLoadingData = false;
      });
    } catch (e) {
      print('❌ Error loading required data: $e');
      setState(() {
        _isLoadingData = false;
        _errorMessage = 'Error loading data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingData) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Update Expense'),
          backgroundColor: const Color(0xFF1976D2),
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading expense data...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Update Expense'),
          backgroundColor: const Color(0xFF1976D2),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text(_errorMessage!),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadAllRequiredData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final expenseDetailsAsync =
        ref.watch(getExpenseDetailsProvider(widget.expenseId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Expense'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: expenseDetailsAsync.when(
        data: (expenseDetails) {
          // Check if response exists
          if (expenseDetails.response == null) {
            return const Center(
              child: Text('No expense details found'),
            );
          }

          // Use ExpenseEditScreen - NO expenseData parameter needed
          return ExpenseEditScreen(
            expenseId: widget.expenseId,
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 64),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(getExpenseDetailsProvider(widget.expenseId));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
