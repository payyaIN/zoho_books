import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:payzo_books/view/expenses/repo/expense_update_delete_repository.dart';

class ExpenseEditScreen extends ConsumerStatefulWidget {
  final int expenseId;

  const ExpenseEditScreen({
    Key? key,
    required this.expenseId,
  }) : super(key: key);

  @override
  ConsumerState<ExpenseEditScreen> createState() => _ExpenseEditScreenState();
}

class _ExpenseEditScreenState extends ConsumerState<ExpenseEditScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _amountController = TextEditingController();
  final _referenceController = TextEditingController();
  final _notesController = TextEditingController();
  final _expenseInfoController = TextEditingController();

  // State variables
  DateTime? _selectedDate;
  int? _selectedBranchId;
  int? _selectedExpenseAccountId;
  int? _selectedPaidThroughId;
  int? _selectedVendorId;
  int? _selectedCustomerId;
  int? _selectedTaxId;
  int? _selectedCurrencyId;
  File? _selectedFile;
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _referenceController.dispose();
    _notesController.dispose();
    _expenseInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Expense'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Date Picker
                    InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.calendar_today),
                        ),
                        child: Text(
                          _selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                              : 'Select date',
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Branch Dropdown (placeholder - would load from API)
                    DropdownButtonFormField<int>(
                      value: _selectedBranchId,
                      decoration: const InputDecoration(
                        labelText: 'Branch *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      items: const [], // Load from branch API
                      onChanged: (value) {
                        setState(() {
                          _selectedBranchId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a branch';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Expense Account Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedExpenseAccountId,
                      decoration: const InputDecoration(
                        labelText: 'Expense Account *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_balance),
                      ),
                      items: const [], // Load from expense account API
                      onChanged: (value) {
                        setState(() {
                          _selectedExpenseAccountId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select an expense account';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Amount
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Amount *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter amount';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Currency Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedCurrencyId,
                      decoration: const InputDecoration(
                        labelText: 'Currency',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.currency_exchange),
                      ),
                      items: const [], // Load from currency API
                      onChanged: (value) {
                        setState(() {
                          _selectedCurrencyId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Paid Through Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedPaidThroughId,
                      decoration: const InputDecoration(
                        labelText: 'Paid Through *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.payment),
                      ),
                      items: const [], // Load from paid through API
                      onChanged: (value) {
                        setState(() {
                          _selectedPaidThroughId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select paid through account';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Vendor Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedVendorId,
                      decoration: const InputDecoration(
                        labelText: 'Vendor',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.store),
                      ),
                      items: const [], // Load from vendor API
                      onChanged: (value) {
                        setState(() {
                          _selectedVendorId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Customer Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedCustomerId,
                      decoration: const InputDecoration(
                        labelText: 'Customer',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      items: const [], // Load from customer API
                      onChanged: (value) {
                        setState(() {
                          _selectedCustomerId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Tax Dropdown
                    DropdownButtonFormField<int>(
                      value: _selectedTaxId,
                      decoration: const InputDecoration(
                        labelText: 'Tax',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.receipt),
                      ),
                      items: const [], // Load from tax API
                      onChanged: (value) {
                        setState(() {
                          _selectedTaxId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Reference
                    TextFormField(
                      controller: _referenceController,
                      decoration: const InputDecoration(
                        labelText: 'Reference',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.numbers),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.notes),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Expense Info
                    TextFormField(
                      controller: _expenseInfoController,
                      decoration: const InputDecoration(
                        labelText: 'Expense Info',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.info),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // File Picker
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.attach_file),
                        title: Text(
                          _selectedFile != null
                              ? _selectedFile!.path.split('/').last
                              : 'Attach File (Optional)',
                        ),
                        trailing: _selectedFile != null
                            ? IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  setState(() {
                                    _selectedFile = null;
                                  });
                                },
                              )
                            : null,
                        onTap: () => _pickFile(),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    ElevatedButton(
                      onPressed: _handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Update Expense'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare expense data
      final expenseData = {
        'expenseId': widget.expenseId.toString(),
        'file': null,
        'expenseAccountId': _selectedExpenseAccountId,
        'paidThroughAccountId': _selectedPaidThroughId,
        'expenseAmount': _amountController.text,
        'currency': _selectedCurrencyId,
        'expenseDescription': _notesController.text,
        'vendorId': _selectedVendorId,
        'vendorAccount': null,
        'customerDto': {
          'customerId': _selectedCustomerId,
          'curtomerChartOfAccountId': null,
          'billable': false,
          'markUpby': null,
          'projectId': 1,
        },
        'branch': _selectedBranchId,
        'date': _selectedDate?.toIso8601String(),
        'reference': _referenceController.text,
        'tax': {
          'taxId': _selectedTaxId,
          'taxType': 'default',
        },
        'isModalShown': 0,
        'exemptionReason': null,
        'expenseInfo': _expenseInfoController.text,
        'claimable': 1,
      };

      final repository = ref.read(expenseUpdateDeleteRepositoryProvider);
      final response = await repository.updateExpense(
        expenseId: widget.expenseId,
        expenseData: expenseData,
        file: _selectedFile,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (response['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(response['message'] ?? 'Expense updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to update expense'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
