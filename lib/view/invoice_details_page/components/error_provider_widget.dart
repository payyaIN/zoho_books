import 'package:payzo_books/import_data.dart';

Center errorColumn({
  required Object errorText,
  required VoidCallback onRetry,
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.error_outline, size: 48, color: Colors.red),
        GapSpace.height16,
        const ReusableText(
          text: "Error loading invoice details",
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        GapSpace.height8,
        ReusableText(text: errorText.toString(), textAlign: TextAlign.center),
        GapSpace.height16,
        ElevatedButton(
          onPressed: onRetry,
          child: const ReusableText(text: "Retry"),
        ),
      ],
    ),
  );
}
