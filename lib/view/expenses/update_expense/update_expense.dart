import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_invoice/get_customer_list_repo.dart';
import 'package:payzo_books/data/repository/add_invoice/get_tax_list_repo.dart';
import 'package:payzo_books/data/repository/add_product/get_all_account_list_repository.dart';
import 'package:payzo_books/data/other_providers/price_currency_proider.dart';
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
    // Call all necessary APIs when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAllRequiredData();
    });
  }

  /// Load all required data before showing edit screen
  /// Based on the API flow documented in expense_detail_page_api_called_before_and_after_edit_function.txt
  Future<void> _loadAllRequiredData() async {
    try {
      setState(() {
        _isLoadingData = true;
        _errorMessage = null;
      });

      print('🔄 Loading all required data for expense edit...');

      // Load all APIs in parallel for better performance
      await Future.wait([
        // 1. Get Branch List
        ref.read(fetchBranchListProvider.future),

        // 2. Get Expense Account List
        ref.read(getChartOfAccountsProvider.future),

        // 3. Get All Accounts (includes Paid Through accounts)
        ref.read(fetchAccountListProvider.future),

        // 4. Get Customer List
        ref.read(getCustomerListProvider.future),

        // 5. Get Vendor List
        ref.read(getVendorListProvider.future),

        // 6. Get Tax List
        ref.read(fetchAllTaxesProvider.future),

        // 7. Get Currency List
        ref.read(getPriceCurrencyProvider.future),

        // 8. Get Expense Details (this will be used to populate the form)
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

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If still loading initial data, show loading screen
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
              Text(
                'Loading expense data...',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Please wait...',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // If there was an error loading initial data
    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Update Expense'),
          backgroundColor: const Color(0xFF1976D2),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _loadAllRequiredData();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Watch expense details
    final expenseDetailsAsync =
        ref.watch(getExpenseDetailsProvider(widget.expenseId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Expense'),
        backgroundColor: const Color(0xFF1976D2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: expenseDetailsAsync.when(
        data: (expenseDetails) {
          if (expenseDetails.response == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.orange,
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No expense details found',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          // Use ExpenseEditScreen to show the edit form
          return ExpenseEditScreen(
            expenseId: widget.expenseId,
            expenseData: expenseDetails.response!,
          );
        },
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading expense details...'),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading expense: $error',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Invalidate and refetch
                        ref.invalidate(
                            getExpenseDetailsProvider(widget.expenseId));
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Go Back'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
