import 'package:payzo_books/utils/common_widgets/reusable_add_image_widget.dart';
import '../../../../import_data.dart';
class ExpenseDocumentPicker extends ConsumerWidget {
  const ExpenseDocumentPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(expenseAttachmentProvider);

    return PayzoMultiFilePickerFormField(
      title: 'Attachments',
      required: true,
      files: files,
      onChanged: (updatedFiles) {
        ref.read(expenseAttachmentProvider.notifier).state = updatedFiles;
      },
    );
  }
}
