import 'package:flutter/services.dart';

class PayzoInputFormatters {
  /// ✅ Only alphabets (uppercase, lowercase) and spaces
  static final onlyAlphabets = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
  ];

  /// ✅ Only digits
  static final onlyDigits = [
    FilteringTextInputFormatter.digitsOnly,
  ];

  /// ✅ Saudi VAT Number: 15 digits
  static final saudiVatNumber = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(15),
  ];

  /// ✅ Saudi CR Number: 10 digits
  static final saudiCrNumber = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];

  /// ✅ Only decimal numbers (accepts digits + one dot + decimal places)
  static final onlyDecimalNumbers = [
    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
    _SmartDecimalFormatter(decimalRange: 2),
  ];

  /// ✅ Alphanumeric (letters and numbers only)
  static final alphanumeric = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
  ];

  /// ✅ No special characters (letters, numbers, space only)
  static final noSpecialChars = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
  ];

  /// ✅ Email input (letters, numbers, @, ., _, -, +)
  static final email = [
    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._\-+]')),
  ];

  /// ✅ Street: letters, digits, space, comma, dot, dash
  static final street = [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s,.\-]")),
  ];

  /// ✅ City: letters, space, dash only
  static final city = [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s\-]")),
  ];

  /// ✅ Zip: digits and dash (for formats like 12345-6789)
  static final zip = [
    FilteringTextInputFormatter.allow(RegExp(r"[0-9\-]")),
  ];

  /// ✅ Only 5 digits
  static final onlyFiveDigits = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(5),
  ];

  /// ✅ Mobile number: 9 digits, starts with 5
  static final mobileNumber = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(9),
  ];

  /// ✅ HSN Code: only digits, max 12 characters
  static final hsnCode = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(12),
  ];

}

/// ✅ Smart Decimal Formatter (smooth decimal typing experience)
class _SmartDecimalFormatter extends TextInputFormatter {
  final int decimalRange;

  _SmartDecimalFormatter({this.decimalRange = 2});

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text;

    // Prevent double dots
    if (text.indexOf('.') != text.lastIndexOf('.')) {
      return oldValue;
    }

    // Auto add 0 if starts with .
    if (text.startsWith('.')) {
      text = '0$text';
    }

    // Limit decimals
    if (text.contains('.') &&
        text.substring(text.indexOf('.') + 1).length > decimalRange) {
      return oldValue;
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
