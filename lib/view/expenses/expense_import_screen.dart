// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:payzo_books/view/expenses/controller/expense_import_controller.dart';

// class ExpenseImportScreen extends ConsumerWidget {
//   const ExpenseImportScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final importState = ref.watch(expenseImportControllerProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Import Expenses'),
//         backgroundColor: const Color(0xFF1976D2),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Step Indicator
//             _buildStepIndicator(importState.currentStep),
//             const SizedBox(height: 24),

//             // Step Content
//             Expanded(
//               child: _buildStepContent(context, ref, importState),
//             ),

//             // Navigation Buttons
//             if (importState.isLoading)
//               const Center(child: CircularProgressIndicator())
//             else
//               _buildNavigationButtons(context, ref, importState),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStepIndicator(ImportStep currentStep) {
//     return Row(
//       children: [
//         _buildStepCircle(
//             '1', currentStep.index >= ImportStep.downloadSample.index),
//         Expanded(
//             child: _buildStepLine(
//                 currentStep.index > ImportStep.downloadSample.index)),
//         _buildStepCircle('2', currentStep.index >= ImportStep.chooseFile.index),
//         Expanded(
//             child: _buildStepLine(
//                 currentStep.index > ImportStep.chooseFile.index)),
//         _buildStepCircle('3', currentStep.index >= ImportStep.review.index),
//       ],
//     );
//   }

//   Widget _buildStepCircle(String number, bool isActive) {
//     return Container(
//       width: 40,
//       height: 40,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: isActive ? const Color(0xFF1976D2) : Colors.grey[300],
//       ),
//       child: Center(
//         child: Text(
//           number,
//           style: TextStyle(
//             color: isActive ? Colors.white : Colors.grey[600],
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStepLine(bool isActive) {
//     return Container(
//       height: 2,
//       color: isActive ? const Color(0xFF1976D2) : Colors.grey[300],
//     );
//   }

//   Widget _buildStepContent(
//       BuildContext context, WidgetRef ref, ExpenseImportState state) {
//     switch (state.currentStep) {
//       case ImportStep.downloadSample:
//         return _buildDownloadSampleStep(context, ref);
//       case ImportStep.chooseFile:
//         return _buildChooseFileStep(context, ref, state);
//       case ImportStep.review:
//         return _buildReviewStep(context, ref, state);
//     }
//   }

//   Widget _buildDownloadSampleStep(BuildContext context, WidgetRef ref) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.file_download,
//               size: 80,
//               color: Color(0xFF1976D2),
//             ),
//             const SizedBox(height: 24),
//             const Text(
//               'Download Sample File',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Download our sample Excel file to see the required format for importing expenses.',
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 32),
//             ElevatedButton.icon(
//               onPressed: () async {
//                 final controller =
//                     ref.read(expenseImportControllerProvider.notifier);
//                 final response = await controller.downloadSampleFile();

//                 if (response != null && response.response != null) {
//                   // Decode base64 and save file
//                   final bytes =
//                       base64Decode(response.response!.excelData ?? '');
//                   final directory = await getApplicationDocumentsDirectory();
//                   final file = File(
//                       '${directory.path}/${response.response!.excelFileName}');
//                   await file.writeAsBytes(bytes);

//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Sample file saved to: ${file.path}'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                 }
//               },
//               icon: const Icon(Icons.download),
//               label: const Text('Download Sample File'),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF1976D2),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildChooseFileStep(
//       BuildContext context, WidgetRef ref, ExpenseImportState state) {
//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (state.selectedFile == null) ...[
//               const Icon(
//                 Icons.upload_file,
//                 size: 80,
//                 color: Color(0xFF1976D2),
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'Choose File to Import',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               const Text(
//                 'Select an Excel file (.xlsx) containing expense data.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final result = await FilePicker.platform.pickFiles(
//                     type: FileType.custom,
//                     allowedExtensions: ['xlsx'],
//                   );

//                   if (result != null && result.files.single.path != null) {
//                     final file = File(result.files.single.path!);
//                     ref
//                         .read(expenseImportControllerProvider.notifier)
//                         .setSelectedFile(file);
//                   }
//                 },
//                 icon: const Icon(Icons.folder_open),
//                 label: const Text('Choose File'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF1976D2),
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                 ),
//               ),
//             ] else ...[
//               const Icon(
//                 Icons.check_circle,
//                 size: 80,
//                 color: Colors.green,
//               ),
//               const SizedBox(height: 24),
//               const Text(
//                 'File Selected',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 state.selectedFile!.path.split('/').last,
//                 style: const TextStyle(fontSize: 16),
//               ),
//               const SizedBox(height: 32),
//               ElevatedButton.icon(
//                 onPressed: () async {
//                   final result = await FilePicker.platform.pickFiles(
//                     type: FileType.custom,
//                     allowedExtensions: ['xlsx'],
//                   );

//                   if (result != null && result.files.single.path != null) {
//                     final file = File(result.files.single.path!);
//                     ref
//                         .read(expenseImportControllerProvider.notifier)
//                         .setSelectedFile(file);
//                   }
//                 },
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Change File'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.orange,
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildReviewStep(
//       BuildContext context, WidgetRef ref, ExpenseImportState state) {
//     final validation = state.validationResult;

//     return Card(
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               validation?.error == false ? Icons.check_circle : Icons.error,
//               size: 80,
//               color: validation?.error == false ? Colors.green : Colors.red,
//             ),
//             const SizedBox(height: 24),
//             Text(
//               validation?.message ?? 'Validation Result',
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             if (validation != null) ...[
//               _buildValidationStat('Valid Rows',
//                   '${validation.response?.validRowCount ?? 0}', Colors.green),
//               _buildValidationStat('Failed Rows',
//                   '${validation.response?.failedRowCount ?? 0}', Colors.red),
//               _buildValidationStat(
//                   'Unmapped Fields',
//                   '${validation.response?.unmappedFieldCount ?? 0}',
//                   Colors.orange),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildValidationStat(String label, String value, Color color) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontSize: 16),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Text(
//               value,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavigationButtons(
//       BuildContext context, WidgetRef ref, ExpenseImportState state) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         if (state.currentStep.index > 0)
//           TextButton(
//             onPressed: () {
//               ref.read(expenseImportControllerProvider.notifier).goToStep(
//                     ImportStep.values[state.currentStep.index - 1],
//                   );
//             },
//             child: const Text('Back'),
//           )
//         else
//           const SizedBox(),
//         ElevatedButton(
//           onPressed: () async {
//             final controller =
//                 ref.read(expenseImportControllerProvider.notifier);

//             if (state.currentStep == ImportStep.downloadSample) {
//               controller.goToStep(ImportStep.chooseFile);
//             } else if (state.currentStep == ImportStep.chooseFile) {
//               final success = await controller.validateFile();
//               if (!success && context.mounted) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(
//                     content: Text(state.errorMessage ?? 'Validation failed'),
//                     backgroundColor: Colors.red,
//                   ),
//                 );
//               }
//             } else if (state.currentStep == ImportStep.review) {
//               final success = await controller.importFile();
//               if (context.mounted) {
//                 if (success) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Import successful!'),
//                       backgroundColor: Colors.green,
//                     ),
//                   );
//                   Navigator.pop(context);
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text(state.errorMessage ?? 'Import failed'),
//                       backgroundColor: Colors.red,
//                     ),
//                   );
//                 }
//               }
//             }
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF1976D2),
//             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//           ),
//           child: Text(
//             state.currentStep == ImportStep.review ? 'Import' : 'Next',
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:payzo_books/view/expenses/controller/expense_import_controller.dart';

/// Import steps enum
enum ImportStep { configure, mapFields, preview }

class ExpenseImportScreen extends ConsumerStatefulWidget {
  const ExpenseImportScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ExpenseImportScreen> createState() =>
      _ExpenseImportScreenState();
}

class _ExpenseImportScreenState extends ConsumerState<ExpenseImportScreen> {
  ImportStep _currentStep = ImportStep.configure;

  @override
  Widget build(BuildContext context) {
    final importState = ref.watch(expenseImportControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Import Expenses'),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: Column(
        children: [
          // Step Indicator
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                _buildStepIndicator(1, 'Configure', _currentStep.index >= 0),
                _buildStepLine(_currentStep.index >= 1),
                _buildStepIndicator(2, 'Map Fields', _currentStep.index >= 1),
                _buildStepLine(_currentStep.index >= 2),
                _buildStepIndicator(3, 'Preview', _currentStep.index >= 2),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _buildStepContent(importState),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepNumber, String label, bool isActive) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? const Color(0xFF1976D2) : Colors.grey[300],
            ),
            child: Center(
              child: Text(
                '$stepNumber',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.grey[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF1976D2) : Colors.grey[600],
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(bool isActive) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        color: isActive ? const Color(0xFF1976D2) : Colors.grey[300],
      ),
    );
  }

  Widget _buildStepContent(ExpenseImportState state) {
    switch (_currentStep) {
      case ImportStep.configure:
        return _buildConfigureStep(state);
      case ImportStep.mapFields:
        return _buildMapFieldsStep(state);
      case ImportStep.preview:
        return _buildPreviewStep(state);
    }
  }

  // Step 1: Configure - Upload file and download sample
  Widget _buildConfigureStep(ExpenseImportState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  if (state.selectedFile == null) ...[
                    const Icon(
                      Icons.upload_file,
                      size: 80,
                      color: Color(0xFF1976D2),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Choose File to Import',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Select an Excel file (.xlsx) containing expense data.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['xlsx'],
                        );

                        if (result != null &&
                            result.files.single.path != null) {
                          final file = File(result.files.single.path!);
                          ref
                              .read(expenseImportControllerProvider.notifier)
                              .setSelectedFile(file);
                        }
                      },
                      icon: const Icon(Icons.folder_open),
                      label: const Text('Choose File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1976D2),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                    ),
                  ] else ...[
                    const Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Colors.green,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'File Selected',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.selectedFile!.path.split('/').last,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () async {
                            final result = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['xlsx'],
                            );

                            if (result != null &&
                                result.files.single.path != null) {
                              final file = File(result.files.single.path!);
                              ref
                                  .read(
                                      expenseImportControllerProvider.notifier)
                                  .setSelectedFile(file);
                            }
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Change File'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: state.isLoading
                              ? null
                              : () async {
                                  // Validate file and move to next step
                                  final controller = ref.read(
                                      expenseImportControllerProvider.notifier);
                                  final success =
                                      await controller.validateFile();

                                  if (success && mounted) {
                                    setState(() {
                                      _currentStep = ImportStep.mapFields;
                                    });
                                  }
                                },
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Next'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1976D2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Download Sample File Button
          ElevatedButton.icon(
            onPressed: state.isLoading
                ? null
                : () async {
                    final controller =
                        ref.read(expenseImportControllerProvider.notifier);
                    final response = await controller.downloadSampleFile();

                    if (response != null &&
                        response.response != null &&
                        context.mounted) {
                      final bytes =
                          base64Decode(response.response!.excelData ?? '');
                      final directory =
                          await getApplicationDocumentsDirectory();
                      final file = File(
                          '${directory.path}/${response.response!.excelFileName}');
                      await file.writeAsBytes(bytes);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sample file saved to: ${file.path}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.download),
            label: const Text('Download Sample File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),

          // Error message
          if (state.errorMessage != null) ...[
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
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // Step 2: Map Fields
  Widget _buildMapFieldsStep(ExpenseImportState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Map Fields',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Review the suggested field mappings below. The system has automatically matched your Excel columns to expense fields.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Display field mappings
          Expanded(
            child: state.fieldMappings != null
                ? ListView.builder(
                    itemCount: state.fieldMappings!.length,
                    itemBuilder: (context, index) {
                      final mapping =
                          state.fieldMappings!.entries.toList()[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: const Icon(Icons.arrow_forward,
                              color: Color(0xFF1976D2)),
                          title: Text(
                            mapping.key,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Maps to: ${mapping.value}'),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('No field mappings available'),
                  ),
          ),

          const SizedBox(height: 16),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentStep = ImportStep.configure;
                  });
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
              ),
              ElevatedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        // Preview data
                        final controller =
                            ref.read(expenseImportControllerProvider.notifier);
                        final success = await controller.previewData();

                        if (success && mounted) {
                          setState(() {
                            _currentStep = ImportStep.preview;
                          });
                        }
                      },
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Preview'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Step 3: Preview and Import
  Widget _buildPreviewStep(ExpenseImportState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Preview Data',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Review the data to be imported. Click "Import" to proceed.',
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 24),

          // Display preview data
          Expanded(
            child: state.previewData != null
                ? ListView.builder(
                    itemCount: (state.previewData as List).length,
                    itemBuilder: (context, index) {
                      final item = state.previewData![index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Expense ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Divider(),
                              ...item.entries.map(
                                (e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          e.key,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text('${e.value}'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('No preview data available'),
                  ),
          ),

          const SizedBox(height: 16),

          // Navigation buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentStep = ImportStep.mapFields;
                  });
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                ),
              ),
              ElevatedButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () async {
                        // Final import
                        final controller =
                            ref.read(expenseImportControllerProvider.notifier);
                        final success = await controller.importFile();

                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Expenses imported successfully!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                icon: state.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Icon(Icons.upload),
                label: Text(state.isLoading ? 'Importing...' : 'Import'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
