import 'package:intl/intl.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_invoice/get_customer_list_repo.dart';
import 'package:payzo_books/data/repository/add_invoice/get_tax_list_repo.dart';
import 'package:payzo_books/data/repository/add_product/get_all_account_list_repository.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/utils/common_widgets/reusable_bottom_sheet.dart';
import 'package:payzo_books/utils/common_widgets/reusable_snackbar.dart';
import 'package:payzo_books/view/add/add_expense/model/add_expense_api_response.dart';
import 'package:payzo_books/view/expenses/provider/expense_pagination_provider.dart';

import '../../../../data/other_providers/price_currency_proider.dart';
import '../../../../data/repository/add_bills/get_price_currency_repository.dart';
import '../../../../import_data.dart';

class AddExpenseController extends StateNotifier<bool> {
  final Ref ref;

  AddExpenseController(this.ref) : super(false);

  Future<void> submitExpense(BuildContext context, WidgetRef ref) async {
    state = true;

    try {
      // Controllers
      final amount = ref.read(amountControllerProvider).text.trim();
      final reference = ref.read(referenceControllerProvider).text.trim();
      final notes = ref.read(notesControllerProvider).text.trim();
      final exemptionReason = ref.read(expensesExemptionReasonControllerProvider).text.trim();

      // Required fields
      final branchId = ref.read(branchIdProvider);
      final currencyId = ref.read(expenseCurrencyIdProvider);
      final date = ref.read(dateProvider);
      final expenseAccountId = ref.read(expenseAccountIdProvider);
      final paidThroughId = ref.read(paidThroughIdProvider);

      // Optional/extra fields
      final vendorId = ref.read(vendorIdProvider);
      final taxId = ref.read(taxIdProvider);
      final customerId = ref.read(customerIdProvider);
      final files = ref.read(expenseAttachmentProvider);

      // === ✅ Clear previous errors ===
      ref.read(branchErrorProvider.notifier).state = null;
      ref.read(dateErrorProvider.notifier).state = null;
      ref.read(expenseAccountErrorProvider.notifier).state = null;
      ref.read(amountErrorProvider.notifier).state = null;
      ref.read(paidThroughErrorProvider.notifier).state = null;

      // === ❌ Validation ===
      bool hasError = false;

      if (branchId == null) {
        ref.read(branchErrorProvider.notifier).state = "Branch is required.";
        hasError = true;
      }

      if (date == null) {
        ref.read(dateErrorProvider.notifier).state = "Date is required.";
        hasError = true;
      }

      if (expenseAccountId == null || expenseAccountId == 0) {
        ref.read(expenseAccountErrorProvider.notifier).state = "Expense account is required.";
        hasError = true;
      }

      if (amount.isEmpty || double.tryParse(amount) == null) {
        ref.read(amountErrorProvider.notifier).state = "Enter a valid expense amount.";
        hasError = true;
      }

      if (paidThroughId == null || paidThroughId == 0) {
        ref.read(paidThroughErrorProvider.notifier).state = "Paid through account is required.";
        hasError = true;
      }

      if (hasError) {
        showPayzoSnackBar(
          context: context,
          ref: ref,
          message: "Please fill all the required fields.",
          type: PayzoSnackType.error,
        );
        return;
      }

      // === ✅ Payload ===
      final payload = {
        'branch': branchId,
        'currency': currencyId,
        'date': date?.toIso8601String(),
        'expenseAccountId': expenseAccountId,
        'expenseAmount': amount,
        'expenseDescription': notes,
        'reference': reference,
        'paidThroughAccountId': paidThroughId,
        'vendorId': vendorId,
        'vendorAccount': null,
        'exemptionReason': exemptionReason,
        'tax': {
          'taxId': taxId,
          'taxType': ref.read(showExemptionReasonProvider) ? 'non-taxable' : 'standard-rate',
        },
        'customerDto': {
          'customerId': customerId,
          'curtomerChartOfAccountId': null,
          'billable': false,
          'markUpby': null,
          'projectId': 1,
        },
      };

      print("📦 Submitting Expense Payload: $payload");

      final api = ref.read(apiServiceProvider);
      final response = await api.postFileAsJson(
        url: 'http://158.101.247.195/pb-accounting-service/api/expense/record',
        body: payload,
        files: files,
        fromJson: (json) => AddExpenseApiResponse.fromJson(json),
      );

      print("✅ Expense submitted successfully: $response");

      showPayzoSnackBar(
        context: context,
        ref: ref,
        message: "Expense recorded successfully.",
        type: PayzoSnackType.success,
      );
      await ref.read(expensesPaginationStateProvider.notifier).fetchExpenses();
      await Navigator.pushNamed(context, RouteNames.expensesListing);
      clearForm();
    } catch (e) {
      print("❌ Error submitting expense: $e");
      showPayzoSnackBar(
        context: context,
        ref: ref,
        message: "Something went wrong. Try again.",
        type: PayzoSnackType.error,
      );
    } finally {
      state = false;
    }
  }







  void clearForm() async {
    print("🧼 Clearing form...");

    // Clear text fields
    ref.read(amountControllerProvider).clear();
    ref.read(referenceControllerProvider).clear();
    ref.read(notesControllerProvider).clear();
    ref.read(expensesExemptionReasonControllerProvider).clear();

    // Clear dropdowns and IDs
    ref.read(branchProvider.notifier).state = null;
    ref.read(branchIdProvider.notifier).state = null;
    ref.read(dateProvider.notifier).state = null;
    ref.read(expenseAccountProvider.notifier).state = null;
    ref.read(expenseAccountIdProvider.notifier).state = null;
    ref.read(paidThroughProvider.notifier).state = null;
    ref.read(paidThroughIdProvider.notifier).state = null;
    ref.read(vendorProvider.notifier).state = null;
    ref.read(vendorIdProvider.notifier).state = null;
    ref.read(taxProvider.notifier).state = null;
    ref.read(taxIdProvider.notifier).state = null;
    ref.read(taxTypeProvider.notifier).state = null;
    ref.read(taxJsonProvider.notifier).state = {};
    ref.read(showExemptionReasonProvider.notifier).state = false;
    ref.read(customerProvider.notifier).state = null;
    ref.read(customerIdProvider.notifier).state = null;
    ref.read(expenseAttachmentProvider.notifier).state = [];

    // Set default currency
    final currencyData = await ref.read(fetchPriceCurrencyProvider.future);
    if (currencyData.isNotEmpty) {
      final currency = currencyData.first;
      ref.read(expenseCurrencyProvider.notifier).state = currency.currencyValue ?? 'SAR';
      ref.read(expenseCurrencyIdProvider.notifier).state = currency.currencyId?.toInt();
    }
    // === 📅 Date
    ref.read(dateProvider.notifier).state = DateTime.now();

    print("🔄 Form reset with default currency.");
  }


  void setBranch(String value) {
    ref.read(branchProvider.notifier).state = value;
    print("✅ Branch selected: $value");
  }

  //ui methods

  // Format date for UI
  String formatDate(DateTime? date) {
    if (date == null) return 'Tap to select';
    return DateFormat('dd MMM yyyy').format(date);
  }

  // Date picker with future date constraint
  Future<void> showDatePickerAndSet(BuildContext context) async {
    await ref.read(focusUtilsProvider).unfocusAndDelay();

    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 30)),
      firstDate: now,
      lastDate: DateTime(now.year + 10),
    );

    if (selected != null) {
      ref.read(dateProvider.notifier).state = selected;
      print("📅 Date selected: ${formatDate(selected)}");
    }
  }

  void showExpenseAccountSelector(BuildContext context, WidgetRef ref) async {
    await ref.read(focusUtilsProvider).unfocusAndDelay();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final accountAsync = ref.watch(getChartOfAccountsProvider);

            return accountAsync.when(
              data: (accountResponse) {
                final accounts = accountResponse.response;

                final labels = accounts
                    .map((e) => e.label ?? '')
                    .where((label) => label.isNotEmpty)
                    .toList();

                return ReusableCountryBottomSheet(
                  title: 'Select Expense Account',
                  items: labels,
                  onSelect: (selectedLabel) {
                    final selectedAccount = accounts.firstWhere(
                      (acc) => acc.label == selectedLabel,
                      orElse: () => accounts.first,
                    );

                    // Save label in state (for UI)
                    ref.read(expenseAccountProvider.notifier).state =
                        selectedAccount.label ?? '';
                    ref.read(expenseAccountIdProvider.notifier).state =
                        selectedAccount.value ?? 0;
                    // Optional: If you want to store the value (ID) too
                    // ref.read(selectedAccountIdProvider.notifier).state =
                    //     selectedAccount.value;

                    print(
                        "💼 Expense Account selected: ${selectedAccount.label}");
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Failed to load accounts: $err')),
            );
          },
        );
      },
    );
  }

  void showCurrencySelector(BuildContext context, WidgetRef ref) async {
    await ref.read(focusUtilsProvider).unfocusAndDelay();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final currencyAsync = ref.watch(fetchPriceCurrencyProvider);

            return currencyAsync.when(
              data: (currencyList) {
                final currencyNames = currencyList
                    .map((e) => e.currencyValue ?? '')
                    .where((e) => e.isNotEmpty)
                    .toList();

                return ReusableCountryBottomSheet(
                  title: 'Select Currency',
                  items: currencyNames,
                  onSelect: (selectedCurrency) {
                    final selected = currencyList.firstWhere(
                      (c) => c.currencyValue == selectedCurrency,
                      orElse: () => currencyList.first,
                    );

                    ref.read(expenseCurrencyProvider.notifier).state =
                        selected.currencyValue ?? 'SAR';
                    ref.read(expenseCurrencyIdProvider.notifier).state =
                        selected.currencyId?.toInt();
                    print("💱 Selected Currency: ${selected.currencyValue}");
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Failed to load currencies: $err')),
            );
          },
        );
      },
    );
  }

  void showPaidThroughSelector(BuildContext context, WidgetRef ref) async {
    await ref.read(focusUtilsProvider).unfocusAndDelay();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final accountAsync = ref.watch(getChartOfAccountsProvider);

            return accountAsync.when(
              data: (accountResponse) {
                final accounts = accountResponse.response;

                final labels = accounts
                    .map((e) => e.label ?? '')
                    .where((label) => label.isNotEmpty)
                    .toList();

                return ReusableCountryBottomSheet(
                  title: 'Select Paid Through',
                  items: labels,
                  onSelect: (selectedLabel) {
                    final selectedAccount = accounts.firstWhere(
                      (acc) => acc.label == selectedLabel,
                      orElse: () => accounts.first,
                    );

                    ref.read(paidThroughProvider.notifier).state =
                        selectedAccount.label ?? '';
                    ref.read(paidThroughIdProvider.notifier).state =
                        selectedAccount.value ?? 0;

                    print("💳 Paid Through selected: ${selectedAccount.label}");
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Failed to load accounts: $err')),
            );
          },
        );
      },
    );
  }

  void showBranchSelector(BuildContext context, WidgetRef ref) async {
    await ref.read(focusUtilsProvider).unfocusAndDelay();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final branchAsync = ref.watch(fetchBranchListProvider);
            return branchAsync.when(
              data: (data) {
                final branches = data.data
                        ?.map((b) => b.namePrimary ?? '')
                        .where((name) => name.isNotEmpty)
                        .toList() ??
                    [];

                return ReusableCountryBottomSheet(
                  title: 'Select Branch',
                  items: branches,
                  onSelect: (selectedName) {
                    final selectedBranch = data.data?.firstWhere(
                      (b) => b.namePrimary == selectedName,
                      orElse: () => data.data!.first,
                    );

                    if (selectedBranch != null) {
                      ref.read(branchProvider.notifier).state =
                          selectedBranch.namePrimary ?? '';
                      ref.read(branchIdProvider.notifier).state =
                          selectedBranch.branchId ?? 0;

                      setBranch(selectedBranch.namePrimary ?? '');
                    }
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Failed to load branches: $err')),
            );
          },
        );
      },
    );
  }

  void showVendorSelector(BuildContext context, WidgetRef ref) async {
    await ref.read(focusUtilsProvider).unfocusAndDelay();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final vendorAsync = ref.watch(getVendorList);

            return vendorAsync.when(
              data: (vendorListResponse) {
                final vendors = vendorListResponse.response?.response ?? [];

                final displayNames = vendors
                    .map((v) => v.displayName ?? '')
                    .where((name) => name.isNotEmpty)
                    .toList();

                return ReusableCountryBottomSheet(
                  title: 'Select Vendor',
                  items: displayNames,
                  onSelect: (selectedName) {
                    final selectedVendor = vendors.firstWhere(
                      (v) => v.displayName == selectedName,
                      orElse: () => vendors.first,
                    );

                    ref.read(vendorProvider.notifier).state =
                        selectedVendor.displayName ?? '';
                    ref.read(vendorIdProvider.notifier).state =
                        selectedVendor.partyId ?? 0;

                    print("🏢 Vendor selected: ${selectedVendor.displayName}");
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text('Failed to load vendors: $err')),
            );
          },
        );
      },
    );
  }

  void showCustomerSelector(BuildContext context, WidgetRef ref) async {
    await ref.read(focusUtilsProvider).unfocusAndDelay();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final customerAsync = ref.watch(fetchCustomerListProvider);

            return customerAsync.when(
              data: (customers) {
                final names = customers
                    .map((c) => c.displayName ?? '')
                    .where((name) => name.isNotEmpty)
                    .toList();

                return ReusableCountryBottomSheet(
                  title: 'Select Customer',
                  items: names,
                  onSelect: (selectedName) {
                    final selectedCustomer = customers.firstWhere(
                      (c) => c.displayName == selectedName,
                      orElse: () => customers.first,
                    );

                    ref.read(customerProvider.notifier).state =
                        selectedCustomer.displayName ?? '';
                    ref.read(customerIdProvider.notifier).state =
                        selectedCustomer.partyId ?? 0;

                    print(
                        "👤 Customer selected: ${selectedCustomer.displayName}");
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text("Failed to load customers: $err")),
            );
          },
        );
      },
    );
  }

  void showTaxSelector(BuildContext context, WidgetRef ref) async {
    await ref.read(focusUtilsProvider).unfocusAndDelay();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final taxAsync = ref.watch(fetchAllTaxesProvider);

            return taxAsync.when(
              data: (taxResponse) {
                final List<Map<String, dynamic>> allTaxEntries = [
                  ...taxResponse.defaultTax.map((e) => {
                    'name': e.taxName,
                    'id': e.taxId,
                    'type': e.taxType,
                  }),
                  ...taxResponse.others.map((e) => {
                    'name': e.taxName,
                    'id': e.taxId,
                    'type': e.taxType,
                  }),
                ];

                final taxNames = allTaxEntries.map((e) => e['name'] as String).toList();

                return ReusableCountryBottomSheet(
                  title: 'Select Tax',
                  items: taxNames,
                    onSelect: (selectedName) {
                      final selected = allTaxEntries.firstWhere(
                            (entry) => entry['name'] == selectedName,
                        orElse: () => allTaxEntries.first,
                      );

                      // Store individual pieces
                      ref.read(taxProvider.notifier).state = selected['name'];
                      ref.read(taxIdProvider.notifier).state = selected['id'];
                      ref.read(showExemptionReasonProvider.notifier).state =
                          selected['type'] == 'non-taxable';

                      // ✅ Store complete tax object for the payload
                      ref.read(taxJsonProvider.notifier).state = {
                        "taxId": selected['id'],
                        "taxType": selected['type'],
                      };

                      print("📌 Tax Selected: ${selected['name']}");
                      print("🆔 Tax ID: ${selected['id']}");
                      print("📃 Tax Type: ${selected['type']}");
                      print("🧾 Show Exemption Reason: ${selected['type'] == 'non-taxable'}");
                    }
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text("Failed to load tax: $err")),
            );
          },
        );
      },
    );
  }
}
