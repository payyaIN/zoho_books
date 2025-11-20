// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:payzo_books/view/expenses/controller/expense_export_controller.dart';
// import 'package:share_plus/share_plus.dart';

// class ExpenseExportScreen extends ConsumerStatefulWidget {
//   const ExpenseExportScreen({Key? key}) : super(key: key);

//   @override
//   ConsumerState<ExpenseExportScreen> createState() =>
//       _ExpenseExportScreenState();
// }

// class _ExpenseExportScreenState extends ConsumerState<ExpenseExportScreen> {
//   final _fileNameController = TextEditingController(text: 'Expense');
//   final _passwordController = TextEditingController();
//   bool _isPasswordProtected = false;

//   @override
//   void dispose() {
//     _fileNameController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final exportState = ref.watch(expenseExportControllerProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Export Expenses'),
//         backgroundColor: const Color(0xFF1976D2),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Card(
//               elevation: 4,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Export Settings',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // File Name
//                     TextField(
//                       controller: _fileNameController,
//                       decoration: const InputDecoration(
//                         labelText: 'File Name',
//                         border: OutlineInputBorder(),
//                         prefixIcon: Icon(Icons.description),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Password Protection Switch
//                     SwitchListTile(
//                       title: const Text('Password Protection'),
//                       subtitle: const Text('Protect file with password'),
//                       value: _isPasswordProtected,
//                       onChanged: (value) {
//                         setState(() {
//                           _isPasswordProtected = value;
//                         });
//                       },
//                       activeColor: const Color(0xFF1976D2),
//                     ),

//                     // Password Field (if enabled)
//                     if (_isPasswordProtected) ...[
//                       const SizedBox(height: 16),
//                       TextField(
//                         controller: _passwordController,
//                         obscureText: true,
//                         decoration: const InputDecoration(
//                           labelText: 'Password',
//                           border: OutlineInputBorder(),
//                           prefixIcon: Icon(Icons.lock),
//                           helperText: 'Password must be at least 6 characters',
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Export Button
//             if (exportState.isLoading)
//               const Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircularProgressIndicator(),
//                     SizedBox(height: 16),
//                     Text('Exporting expenses...'),
//                   ],
//                 ),
//               )
//             else
//               ElevatedButton.icon(
//                 onPressed: () => _handleExport(context, ref),
//                 icon: const Icon(Icons.file_download),
//                 label: const Text('Export to Excel'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1976D2),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   textStyle: const TextStyle(fontSize: 18),
//                 ),
//               ),

//             // Error Message
//             if (exportState.errorMessage != null) ...[
//               const SizedBox(height: 16),
//               Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: Colors.red[50],
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: Colors.red),
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.error, color: Colors.red),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Text(
//                         exportState.errorMessage!,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _handleExport(BuildContext context, WidgetRef ref) async {
//     // Validate inputs
//     if (_fileNameController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a file name'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     if (_isPasswordProtected && _passwordController.text.length < 6) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Password must be at least 6 characters'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     final controller = ref.read(expenseExportControllerProvider.notifier);

//     // Export based on password protection setting
//     final response = _isPasswordProtected
//         ? await controller.exportWithPassword(
//             password: _passwordController.text,
//             fileName: _fileNameController.text.trim(),
//           )
//         : await controller.exportWithoutPassword(
//             fileName: _fileNameController.text.trim(),
//           );

//     if (response != null && response.response != null && context.mounted) {
//       // Decode base64 and save file
//       final bytes = base64Decode(response.response!.excelData ?? '');
//       final directory = await getApplicationDocumentsDirectory();
//       final fileName = response.response!.excelFileName ??
//           '${_fileNameController.text}.xlsx';
//       final file = File('${directory.path}/$fileName');
//       await file.writeAsBytes(bytes);

//       // Show success dialog with options
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Export Successful'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text('Your expense data has been exported successfully.'),
//               const SizedBox(height: 16),
//               Text(
//                 'File: $fileName',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 'Location: ${file.path}',
//                 style: const TextStyle(fontSize: 12, color: Colors.grey),
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//             ElevatedButton.icon(
//               onPressed: () async {
//                 Navigator.pop(context);
//                 await Share.shareXFiles([XFile(file.path)]);
//               },
//               icon: const Icon(Icons.share),
//               label: const Text('Share'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF1976D2),
//               ),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      appBar: AppBar(
        title: const Text('Export Expenses'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
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
                      activeColor: const Color(0xFF1976D2),
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
                icon: const Icon(Icons.file_download),
                label: const Text('Export to Excel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
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
