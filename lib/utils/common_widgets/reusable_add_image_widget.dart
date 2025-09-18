import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:payzo_books/import_data.dart';

class PayzoMultiFilePickerFormField extends StatefulWidget {
  final String title;
  final List<File> files;
  final void Function(List<File> updatedList) onChanged;
  final bool required;

  const PayzoMultiFilePickerFormField({
    super.key,
    required this.title,
    required this.files,
    required this.onChanged,
    this.required = false,
  });

  @override
  State<PayzoMultiFilePickerFormField> createState() =>
      _PayzoMultiFilePickerFormFieldState();
}

class _PayzoMultiFilePickerFormFieldState
    extends State<PayzoMultiFilePickerFormField> {
  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null && result.files.isNotEmpty) {
      final newFiles = result.paths.map((path) => File(path!)).toList();
      final updatedList = [...widget.files, ...newFiles];
      widget.onChanged(updatedList);
    }
  }

  void _removeFile(int index) {
    final updatedList = [...widget.files]..removeAt(index);
    widget.onChanged(updatedList);
  }

  @override
  Widget build(BuildContext context) {
    return FormContainer(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ReusableColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReusableRow(
              children: [
                ReusableText(
                  text: widget.title,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                if (widget.required)
                  const ReusableText(
                    text: ' *',
                    color: Colors.red,
                    fontSize: 14,
                  ),
              ],
            ),
            const ReusableSizedBox(height: 10),
            ReusableContainer(
              padding: const EdgeInsets.all(10),
              borderRadius: BorderRadius.circular(12),
              borderColor: Colors.grey,
              width: double.infinity,
              child: widget.files.isEmpty
                  ? InkWell(
                onTap: _pickFiles,
                child: ReusableColumn(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.cloud_upload_outlined,
                        size: 30, color: Colors.grey),
                    ReusableSizedBox(height: 8),
                    ReusableText(
                      text: 'Tap to upload',
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ],
                ),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.files.length + 1, // +1 for add button
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  if (index == widget.files.length) {
                    return InkWell(
                      onTap: _pickFiles,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final file = widget.files[index];
                  return Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.insert_drive_file,
                                size: 30, color:AppColors.appMainColor),
                            const SizedBox(height: 5),
                            Flexible(
                              child: Text(
                                file.path.split('/').last,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeFile(index),
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
