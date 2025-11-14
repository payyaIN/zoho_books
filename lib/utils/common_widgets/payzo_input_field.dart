import 'package:flutter/services.dart';
import 'package:payzo_books/import_data.dart';
class PayzoInputField extends StatelessWidget {
  final String label;
  final String? errorText;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final VoidCallback? countryTap;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final String? initialValue;
  final Widget? leading;
  final String? countryFlagCode;
  final bool required;
  final bool enabled;
  final bool? isPrefixText;
  final String? prefixText;
  final List<TextInputFormatter>? inputFormatters;
  final bool? showList;
  final VoidCallback? showListTap;


  const PayzoInputField({
    super.key,
    required this.label,
    this.required = false,
    this.controller,
    this.onTap,
    this.onChanged,
    this.errorText,
    this.keyboardType,
    this.initialValue,
    this.leading,
    this.countryFlagCode,
    this.countryTap,
    this.inputFormatters,
    this.enabled = true,
    this.isPrefixText,
    this.prefixText,
    this.showList=false,
    this.showListTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget? buildLeadingWidget() {
      if (leading != null) return leading;

      if (countryFlagCode != null) {
        return GestureDetector(
          onTap: countryTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: Image.network(
                  'https://flagcdn.com/48x36/${countryFlagCode!.toLowerCase()}.png',
                  width: 30,
                  height: 20,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              const Text('|',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
            ],
          ),
        );
      }

      return null;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: TextFormField(
        enabled: enabled,
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        initialValue: controller == null ? initialValue : null,
        keyboardType: keyboardType ?? TextInputType.text,
        onTap: onTap,
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        style: const TextStyle(
          fontFamily: 'SF Pro Display',
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: Color.fromRGBO(51, 51, 51, 1),
        ),
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromRGBO(51, 51, 51, 1),
              ),
              children: required
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ]
                  : [],
            ),
          ),
          labelStyle: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color.fromRGBO(51, 51, 51, 1),
          ),
          prefixText: isPrefixText == true ? prefixText : null,
          suffix:showList==true?GestureDetector(
            onTap: showList==true?showListTap:null,
            child: Icon(Icons.keyboard_arrow_down,color: const Color.fromRGBO(86, 86, 86, 1),),
          ):null,
          prefixStyle: const TextStyle(
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Color.fromRGBO(51, 51, 51, 1),
          ),
          errorMaxLines: 3,
          errorText: errorText?.isNotEmpty == true ? errorText : null,
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(228, 228, 228, 1)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColors.appMainColor, width: 2),
          ),
          floatingLabelStyle: const TextStyle(color: AppColors.appMainColor),
          prefixIcon: buildLeadingWidget(),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }
}
