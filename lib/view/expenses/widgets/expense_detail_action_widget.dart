import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/view/expenses/expene_export_screen.dart';
import 'package:payzo_books/view/expenses/expense_edit_screen.dart';
import 'package:payzo_books/view/expenses/expense_import_screen.dart';
import 'package:payzo_books/view/expenses/repo/expense_update_delete_repository.dart';

class ExpenseDetailActionsWidget extends ConsumerWidget {
  final int expenseId;
  final VoidCallback? onDeleted;

  const ExpenseDetailActionsWidget({
    Key? key,
    required this.expenseId,
    this.onDeleted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton(
            context,
            icon: Icons.file_upload,
            label: 'Import',
            color: const Color(0xFF1976D2),
            onTap: () => _showImport(context),
          ),
          _buildActionButton(
            context,
            icon: Icons.file_download,
            label: 'Export',
            color: const Color(0xFF388E3C),
            onTap: () => _showExport(context),
          ),
          _buildActionButton(
            context,
            icon: Icons.edit,
            label: 'Edit',
            color: const Color(0xFFF57C00),
            onTap: () => _showEdit(context, ref),
          ),
          _buildActionButton(
            context,
            icon: Icons.delete,
            label: 'Delete',
            color: const Color(0xFFD32F2F),
            onTap: () => _showDeleteConfirmation(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showImport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExpenseImportScreen(),
      ),
    );
  }

  void _showExport(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExpenseExportScreen(),
      ),
    );
  }

  void _showEdit(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExpenseEditScreen(expenseId: expenseId),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Confirm Delete'),
          ],
        ),
        content: const Text(
          'Are you sure you want to delete this expense? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _handleDelete(context, ref);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Deleting expense...'),
              ],
            ),
          ),
        ),
      ),
    );

    try {
      final repository = ref.read(expenseUpdateDeleteRepositoryProvider);
      final response = await repository.deleteExpense(expenseId);

      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog

        if (response['status'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(response['message'] ?? 'Expense deleted successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Call the callback if provided
          onDeleted?.call();

          // Navigate back
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response['message'] ?? 'Failed to delete expense'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
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
