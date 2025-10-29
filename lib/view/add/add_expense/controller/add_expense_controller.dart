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
import 'package:payzo_books/view/expenses/repo/expense_repo.dart';

import '../../../../data/other_providers/price_currency_proider.dart';
import '../../../../data/repository/add_bills/get_price_currency_repository.dart';
import '../../../../import_data.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:mime/mime.dart';

import '../../../../utils/app_data/shared_preference_key.dart';

class AddExpenseController extends StateNotifier<bool> {
  final Ref ref;

  AddExpenseController(this.ref) : super(false);

  // --------------- submitExpense ---------------
  // Replace the existing submitExpense with this implementation
  Future<void> submitExpense(BuildContext context, WidgetRef ref) async {
    state = true;
    try {
      // --- read controllers & providers (from the providers you supplied) ---
      final amount = ref.read(amountControllerProvider).text.trim();
      final reference = ref.read(referenceControllerProvider).text.trim();
      final notes = ref.read(notesControllerProvider).text.trim();
      final exemptionReason =
          ref.read(expensesExemptionReasonControllerProvider).text.trim();
      final expenseInfo = ref.read(expenseInfoControllerProvider).text.trim();

      final branchId = ref.read(branchIdProvider);
      final currencyId = ref.read(expenseCurrencyIdProvider);
      final date = ref.read(dateProvider);
      final expenseAccountId = ref.read(expenseAccountIdProvider);
      final paidThroughId = ref.read(paidThroughIdProvider);

      final vendorId = ref.read(vendorIdProvider);
      final taxId = ref.read(taxIdProvider);
      final customerId = ref.read(customerIdProvider);
      final files = ref.read(expenseAttachmentProvider); // List<File>

      final product = ref.read(productTypeProvider);
      final int claimableFlag = (product.isClaimable ?? false) ? 1 : 0;

      // Clear previous errors
      ref.read(branchErrorProvider.notifier).state = null;
      ref.read(dateErrorProvider.notifier).state = null;
      ref.read(expenseAccountErrorProvider.notifier).state = null;
      ref.read(amountErrorProvider.notifier).state = null;
      ref.read(paidThroughErrorProvider.notifier).state = null;

      // Validation
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
        ref.read(expenseAccountErrorProvider.notifier).state =
            "Expense account is required.";
        hasError = true;
      }
      if (amount.isEmpty || double.tryParse(amount) == null) {
        ref.read(amountErrorProvider.notifier).state =
            "Enter a valid expense amount.";
        hasError = true;
      }
      if (paidThroughId == null || paidThroughId == 0) {
        ref.read(paidThroughErrorProvider.notifier).state =
            "Paid through account is required.";
        hasError = true;
      }
      if (hasError) {
        showPayzoSnackBar(
            context: context,
            ref: ref,
            message: "Please fill all the required fields.",
            type: PayzoSnackType.error);
        return;
      }

      // Resolve tax info (use taxJsonProvider if set; respect exemption flag)
      final rawTaxJson = ref.read(taxJsonProvider) ?? {};
      final bool showExemption = ref.read(showExemptionReasonProvider) ?? false;
      final resolvedTaxId = ref.read(taxIdProvider) ?? rawTaxJson['taxId'];
      final resolvedTaxType = showExemption
          ? 'non-taxable'
          : (rawTaxJson['taxType'] as String?) ?? 'default';

      final String dateString =
          date != null ? DateFormat('yyyy-MM-dd').format(date) : '';

      // Build payload exactly like working web example
      final Map<String, dynamic> payload = {
        'file': null,
        'expenseAccountId': expenseAccountId,
        'paidThroughAccountId': paidThroughId,
        'expenseAmount': amount,
        'currency': currencyId,
        'expenseDescription': notes.isEmpty ? null : notes,
        'vendorId': vendorId,
        'vendorAccount': null,
        'customerDto': {
          'customerId': customerId,
          'curtomerChartOfAccountId': null,
          'billable': false,
          'markUpby': null,
          'projectId': 1,
        },
        'branch': branchId,
        'date': dateString,
        'reference': reference.isEmpty ? null : reference,
        'tax': {
          'taxId': resolvedTaxId,
          'taxType': resolvedTaxType,
        },
        'exemptionReason': exemptionReason ?? '',
        'isModalShown': 1,
        'expenseInfo': expenseInfo.isEmpty ? null : expenseInfo,
        'claimable': claimableFlag,
      };

      // Build request
      final baseUrl = 'http://81.208.173.149';
      final uri =
          Uri.parse('$baseUrl/pb-accounting-service/api/expense/record');
      final request = http.MultipartRequest('POST', uri);

      // Attach JSON 'data' part as filename 'blob' with Content-Type: application/json
      final String jsonString = jsonEncode(payload);
      final http.MultipartFile jsonPart = http.MultipartFile.fromString(
        'data',
        jsonString,
        filename: 'blob',
        contentType: MediaType('application', 'json'),
      );
      request.files.add(jsonPart);

      // Attach files (expenseAttachmentProvider) - expecting List<File>
      if (files != null && files.isNotEmpty) {
        for (final f in files) {
          try {
            if (f == null) continue;
            if (f is File) {
              final filename = f.path.split(Platform.pathSeparator).last;
              final mime = lookupMimeType(f.path) ?? 'application/octet-stream';
              final mtParts = mime.split('/');
              if (mtParts.length == 2) {
                request.files.add(await http.MultipartFile.fromPath(
                    'file', f.path,
                    filename: filename,
                    contentType: MediaType(mtParts[0], mtParts[1])));
              } else {
                request.files.add(await http.MultipartFile.fromPath(
                    'file', f.path,
                    filename: filename));
              }
            }
          } catch (fileErr) {
            // ignore single file error and continue
            debugPrint('⚠️ attach-file skipped: $fileErr');
          }
        }
      }

      // Headers: read from global providers (replace names if different)
      final token =
          SharedPreferencesHelper.getString(SharedPreferenceKey.accessToken) ??
              '';
      final companyId = '1';
      final countryCode = 'AE';

      if (token.isNotEmpty) request.headers['Authorization'] = 'Bearer $token';
      if (companyId != null)
        request.headers['company-id'] = companyId.toString();
      request.headers['country-code'] = countryCode.toString();
      request.headers['Accept'] = 'application/json';

      debugPrint(
          "📦 Submitting multipart (data=blob JSON + file(s)). JSON: $jsonString");

      final streamedResp = await request.send();
      final resp = await http.Response.fromStream(streamedResp);

      debugPrint('📨 Response (${resp.statusCode}): ${resp.body}');

      if (resp.statusCode >= 200 && resp.statusCode < 300) {
        final decoded = jsonDecode(resp.body);
        final apiResp = AddExpenseApiResponse.fromJson(decoded);
        debugPrint(
            "✅ Expense submitted successfully: ${apiResp.message ?? 'OK'}");

        showPayzoSnackBar(
            context: context,
            ref: ref,
            message: "Expense recorded successfully.",
            type: PayzoSnackType.success);
        ref.invalidate(getExpenseDataWithPagination);
        // Refresh list & navigate (keep your flow)
        await ref
            .read(expensesPaginationStateProvider.notifier)
            .fetchExpenses();
        await Navigator.pushNamed(context, RouteNames.expensesListing);

        // Clear form
        clearForm();
      } else {
        String serverMsg = resp.body;
        try {
          final decoded = jsonDecode(resp.body);
          serverMsg = decoded['message']?.toString() ?? resp.body;
        } catch (_) {}
        debugPrint('❌ POST failed ${resp.statusCode}: $serverMsg');
        showPayzoSnackBar(
            context: context,
            ref: ref,
            message: "Failed: $serverMsg",
            type: PayzoSnackType.error);
      }
    } catch (e, st) {
      debugPrint("❌ Error submitting expense: $e\n$st");
      showPayzoSnackBar(
          context: context,
          ref: ref,
          message: "Something went wrong. Try again.",
          type: PayzoSnackType.error);
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
      ref.read(expenseCurrencyProvider.notifier).state =
          currency.currencyValue ?? 'SAR';
      ref.read(expenseCurrencyIdProvider.notifier).state =
          currency.currencyId?.toInt();
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

  // --------------- calculateTotal ---------------
  void calculateTotal(BuildContext context, WidgetRef ref) {
    // read amount text and parse (entered amount is tax-INCLUSIVE)
    final amountText = ref.read(amountControllerProvider).text.trim();
    final enteredAmount =
        double.tryParse(amountText.replaceAll(',', '')) ?? 0.0;

    // figure out taxRate (priority: taxJson.taxRate -> taxJson.rate -> lookup by taxId)
    double taxRate = 0.0;
    String? selectedTaxName = ref.read(taxProvider);
    final taxJsonRaw = ref.read(taxJsonProvider) ?? {};

    // 1) Try direct taxRate from taxJson (this will be present when user selected a tax)
    if (taxJsonRaw.containsKey('taxRate')) {
      final dynamic r = taxJsonRaw['taxRate'];
      taxRate = (r is num) ? r.toDouble() : (double.tryParse('$r') ?? 0.0);
    } else if (taxJsonRaw.containsKey('rate')) {
      final dynamic r = taxJsonRaw['rate'];
      taxRate = (r is num) ? r.toDouble() : (double.tryParse('$r') ?? 0.0);
    } else {
      // fallback: lookup rate from fetched taxes provider (if available)
      final taxAsync = ref.read(fetchAllTaxesProvider);
      taxAsync.when(
        data: (taxResponse) {
          try {
            final List<dynamic> all = [
              ...taxResponse.defaultTax,
              ...taxResponse.others,
            ];
            final selId = ref.read(taxIdProvider);
            if (selId != null) {
              final match = all.firstWhere(
                (t) => (t.taxId?.toInt() ?? t.taxId) == selId,
                orElse: () => null,
              );
              if (match != null) {
                if (match.tcdTaxRate != null) {
                  taxRate = (match.tcdTaxRate is num)
                      ? match.tcdTaxRate.toDouble()
                      : double.tryParse('${match.tcdTaxRate}') ?? 0.0;
                } else if (match.taxRate != null) {
                  taxRate = (match.taxRate is num)
                      ? match.taxRate.toDouble()
                      : double.tryParse('${match.taxRate}') ?? 0.0;
                } else if (match.rate != null) {
                  taxRate = (match.rate is num)
                      ? match.rate.toDouble()
                      : double.tryParse('${match.rate}') ?? 0.0;
                }
                selectedTaxName ??=
                    match.taxName ?? match.name ?? selectedTaxName;
              }
            }
          } catch (_) {}
        },
        loading: () => {},
        error: (_, __) => {},
      );
    }

    // Force zero if non-taxable/exempt/zero name
    final taxType = ref.read(taxTypeProvider);
    final showExemption = ref.read(showExemptionReasonProvider);
    if (taxType == 'non-taxable' || showExemption == true) {
      taxRate = 0.0;
    }
    if (selectedTaxName != null &&
        selectedTaxName!.toLowerCase().contains('zero')) {
      taxRate = 0.0;
    }

    // treat enteredAmount as tax-INCLUSIVE amount
    double baseAmount;
    double taxAmount;
    double totalAmount;

    if (taxRate == 0.0) {
      baseAmount = enteredAmount;
      taxAmount = 0.0;
      totalAmount = enteredAmount;
    } else {
      // Base = Amount / (1 + TaxRate/100)
      baseAmount = enteredAmount / (1 + (taxRate / 100.0));
      baseAmount = double.parse(baseAmount.toStringAsFixed(2));
      // Tax = Amount - Base
      taxAmount = double.parse((enteredAmount - baseAmount).toStringAsFixed(2));
      totalAmount = double.parse(enteredAmount.toStringAsFixed(2));
    }

    // update providers
    ref.read(addExpenseSubtotalProvider.notifier).state = baseAmount;
    ref.read(addExpenseTaxAmountProvider.notifier).state = taxAmount;
    ref.read(addExpenseTotalProvider.notifier).state = totalAmount;
    ref.read(addExpenseSelectedTaxNameProvider.notifier).state =
        selectedTaxName;

    debugPrint(
        '🧮 (inclusive) Entered: $enteredAmount, taxRate: $taxRate%, base: $baseAmount, tax: $taxAmount, total: $totalAmount');
  }

  /// Try multiple possible property names at runtime and return a double rate.
  double _extractRateFromDynamic(dynamic dyn) {
    try {
      // If the runtime object has tcdTaxRate (as in DefaultTax) prefer that.
      final candidateList = <dynamic>[
        // common names based on your API and models
        dyn.tcdTaxRate,
        dyn.tcdTaxRateValue, // just in case
        dyn.taxRate,
        dyn.rate,
        dyn.tcdTaxRateStr, // if some models use strings
        dyn.tax_percent, // improbable, but harmless to try
      ];

      for (final c in candidateList) {
        if (c == null) continue;
        if (c is num) return c.toDouble();
        if (c is String) {
          final parsed = double.tryParse(c.replaceAll(',', ''));
          if (parsed != null) return parsed;
        }
      }
    } catch (_) {
      // Accessing a missing getter on some dynamic implementations can throw;
      // we ignore and return 0.0 as fallback.
    }
    return 0.0;
  }

  // --------------- showTaxSelector ---------------
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
                // include rate into the entries so selection immediately has rate
                final List<Map<String, dynamic>> allTaxEntries = [
                  ...taxResponse.defaultTax.map((e) {
                    final dyn = e as dynamic;
                    // attempt to read several possible fields at runtime
                    final double resolvedRate = _extractRateFromDynamic(dyn);
                    return {
                      'name': dyn.taxName ?? dyn.tcdTaxName ?? dyn.name,
                      'id': dyn.taxId ?? dyn.tcdTaxId ?? dyn.id,
                      'type': dyn.taxType ?? dyn.tcdTaxType,
                      'rate': resolvedRate,
                    };
                  }),
                  ...taxResponse.others.map((e) {
                    final dyn = e as dynamic;
                    final double resolvedRate = _extractRateFromDynamic(dyn);
                    return {
                      'name': dyn.taxName ?? dyn.tcdTaxName ?? dyn.name,
                      'id': dyn.taxId ?? dyn.tcdTaxId ?? dyn.id,
                      'type': dyn.taxType ?? dyn.tcdTaxType,
                      'rate': resolvedRate,
                    };
                  }),
                ];

                final taxNames =
                    allTaxEntries.map((e) => e['name'] as String).toList();

                return ReusableCountryBottomSheet(
                  title: 'Select Tax',
                  items: taxNames,
                  onSelect: (selectedName) {
                    final selected = allTaxEntries.firstWhere(
                      (entry) => entry['name'] == selectedName,
                      orElse: () => allTaxEntries.first,
                    );

                    // apply selection...
                    ref.read(taxProvider.notifier).state = selected['name'];
                    ref.read(taxIdProvider.notifier).state = selected['id'];
                    ref.read(showExemptionReasonProvider.notifier).state =
                        selected['type'] == 'non-taxable';
                    ref.read(taxJsonProvider.notifier).state = {
                      'taxId': selected['id'],
                      'taxType': selected['type'],
                      'taxRate': selected['rate'],
                    };
                    ref.read(addExpenseSelectedTaxNameProvider.notifier).state =
                        selected['name'];

                    // recalc totals now taxJson has the numeric taxRate
                    calculateTotal(context, ref);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) =>
                  Center(child: Text("Failed to load tax: $err")),
            );
          },
        );
      },
    );
  }
}
