import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/reusable_appbar.dart';
import 'package:payzo_books/view/expenses/controller/expense_export_controller.dart';
import 'package:payzo_books/view/expenses/model/expense_export_download_model.dart';

class ExpenseExportScreen extends ConsumerStatefulWidget {
  const ExpenseExportScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ExpenseExportScreen> createState() =>
      _ExpenseExportScreenState();
}

class _ExpenseExportScreenState extends ConsumerState<ExpenseExportScreen> {
  final _fileNameController = TextEditingController(text: 'Expense');
  final _passwordController = TextEditingController();
  bool _isPasswordProtected = false;

  @override
  void dispose() {
    _fileNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exportState = ref.watch(expenseExportControllerProvider);

    return Scaffold(
      appBar: reusableAppBar(
        title: "Export Expenses",
        context: context,
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.white60,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Export Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // File Name
                    TextField(
                      controller: _fileNameController,
                      decoration: const InputDecoration(
                        labelText: 'File Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password Protection Switch
                    SwitchListTile(
                      title: const Text('Password Protection'),
                      subtitle: const Text('Protect file with password'),
                      value: _isPasswordProtected,
                      onChanged: (value) {
                        setState(() {
                          _isPasswordProtected = value;
                        });
                      },
                      activeColor: AppColors.appMainColor,
                    ),

                    // Password Field (if enabled)
                    if (_isPasswordProtected) ...[
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                          helperText: 'Password must be at least 6 characters',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Export Button
            if (exportState.isLoading)
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Exporting expenses...'),
                  ],
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () => _handleExport(context, ref),
                icon: const Icon(Icons.file_download, color: Colors.white),
                label: ReusableText(
                  text: 'Export to Excel',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.btnTextColor,
                  fontFamily: 'SF Pro Display',
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appMainColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),

            // Error Message
            if (exportState.errorMessage != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        exportState.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleExport(BuildContext context, WidgetRef ref) async {
    // Validate inputs
    if (_fileNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a file name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isPasswordProtected && _passwordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must be at least 6 characters'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final controller = ref.read(expenseExportControllerProvider.notifier);

    // Export based on password protection setting
    final response = _isPasswordProtected
        ? await controller.exportWithPassword(
            password: _passwordController.text,
            fileName: _fileNameController.text.trim(),
          )
        : await controller.exportWithoutPassword(
            fileName: _fileNameController.text.trim(),
          );

    if (response != null && response.response != null && context.mounted) {
      // Create download model
      final downloadModel = ExpenseExportDownloadModel(
        fileName: response.response!.excelFileName ?? 'Expense.xlsx',
        data: response.response!.excelData ?? '',
        status: 'success',
      );

      // Save to Download folder
      final file = await downloadModel.saveToDownloadFolder();

      if (file != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'File saved to: ${file.path}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OK',
              textColor: Colors.white,
              onPressed: () {},
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save file'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
