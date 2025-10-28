import 'package:intl/intl.dart';

String formatDate(String? apiDate) {
  if (apiDate == null || apiDate.trim().isEmpty) return 'NA';

  DateTime? parsedDate;

  // Try ISO format first
  try {
    parsedDate = DateTime.parse(apiDate);
  } catch (_) {
    // If not ISO, try other common patterns
    final possibleFormats = [
      'dd MMM yyyy',   // 21 Nov 2025
      'dd MMMM yyyy',  // 21 November 2025
      'yyyy-MM-dd',    // 2025-11-21
      'dd/MM/yyyy',    // 21/11/2025
      'MM/dd/yyyy',    // 11/21/2025
    ];

    for (final pattern in possibleFormats) {
      try {
        parsedDate = DateFormat(pattern).parseLoose(apiDate);
        break;
      } catch (_) {}
    }
  }

  // Fallback if parsing failed
  if (parsedDate == null) return 'NA';

  // Output format
  return DateFormat('dd/MM/yyyy').format(parsedDate);
}
