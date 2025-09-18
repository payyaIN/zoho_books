import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/repository/add_bills/get_branch_list_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_price_currency_repository.dart';
import 'package:payzo_books/data/repository/add_bills/get_vendor_list_repository.dart';
import 'package:payzo_books/data/repository/add_invoice/get_customer_list_repo.dart';
import 'package:payzo_books/data/repository/add_product/get_all_account_list_repository.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/reusable_add_image_widget.dart';
import 'package:payzo_books/view/add/add_expense/widgets/expense_document_picker.dart';
import '../../../data/repository/add_invoice/get_tax_list_repo.dart';

class AddExpense extends ConsumerStatefulWidget {
  const AddExpense({super.key});

  @override
  ConsumerState<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends ConsumerState<AddExpense> {

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
        ref.read(expenseCurrencyProvider.notifier).state = currency.currencyValue ?? 'SAR';
        ref.read(expenseCurrencyIdProvider.notifier).state = currency.currencyId?.toInt();
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
  }


  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Scaffold(
        appBar: reusableAppBar(
          title: 'Add Expenses',
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
                ExpenseDocumentPicker(),
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
