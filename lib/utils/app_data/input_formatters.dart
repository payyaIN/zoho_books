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
  /// ✅ Saudi Building Number — exactly 4 digits
  static final saudiBuildingNumber = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(4),
  ];

  /// ✅ Only decimal numbers (accepts digits + one dot + decimal places)
  static final onlyDecimalNumbers = [
    // allow single characters: digits and dot — don't anchor to whole-string
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
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

  /// ✅ Arabic only (no numbers, symbols, or other languages)
  static final onlyArabic = [
    _ArabicOnlyTextInputFormatter(),
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
    final oldText = oldValue.text;
    var newText = newValue.text;

    // Reject if more than one dot
    if (newText.indexOf('.') != newText.lastIndexOf('.')) {
      return oldValue;
    }

    // If user typed '.' as the first character, make it '0.'
    if (newText == '.') {
      newText = '0.';
    }

    // If there's a dot, ensure decimal part length <= decimalRange
    final dotIndex = newText.indexOf('.');
    if (dotIndex >= 0) {
      final decimals = newText.substring(dotIndex + 1);
      if (decimals.length > decimalRange) {
        return oldValue;
      }
    }

    // Compute selection offset adjustment (keep caret friendly)
    int selectionIndex = newValue.selection.end;
    final lengthDiff = newText.length - newValue.text.length;
    selectionIndex = (selectionIndex + lengthDiff).clamp(0, newText.length);

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}


/// ✅ Custom Formatter — Arabic only (no numbers, symbols, or other languages)
class _ArabicOnlyTextInputFormatter extends TextInputFormatter {
  static final _arabicRegex = RegExp(
    r'^[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\s]+$',
  );

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    if (newValue.text.isEmpty) return newValue;

    if (_arabicRegex.hasMatch(newValue.text)) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}
