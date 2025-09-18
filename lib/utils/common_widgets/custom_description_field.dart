import 'package:flutter/material.dart';

import '../../import_data.dart';

class CustomDescriptionField extends StatelessWidget {
  final String title;
  final String? errorText;
  final TextEditingController controller;
  final int maxLines;
  final bool required;
  final bool enabled;
  final void Function(String)? onChanged;

  const CustomDescriptionField({
    super.key,
    required this.title,
    required this.controller,
    this.maxLines = 4,
    this.onChanged,
    this.errorText,this.required=false,this.enabled=true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ReusableRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ReusableText(
              text: title,
              fontFamily: 'SF Pro Display',
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: Color.fromRGBO(51, 51, 51, 1),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            enabled: enabled,
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            onChanged: onChanged,
            decoration: InputDecoration(
              errorText: errorText,
              contentPadding: const EdgeInsets.all(10),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
