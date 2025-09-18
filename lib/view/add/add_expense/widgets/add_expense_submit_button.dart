import 'package:flutter/material.dart';

import '../../../../import_data.dart';

class AddExpenseSubmitButton extends ConsumerWidget {
  const AddExpenseSubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final isLoading = ref.watch(addExpenseProvider);
    return SafeArea(
      child: PayzoFormSubmitTwoButtons(
        cancelText: 'Clear',
        saveText: isLoading ? 'Saving...' : 'Save',
        cancelOnPressed: () {
          ref.read(addExpenseProvider.notifier).clearForm();
        },
        saveOnPressed: () {
          ref.read(addExpenseProvider.notifier).submitExpense(context,ref);
        },
      ),
    );
  }
}
