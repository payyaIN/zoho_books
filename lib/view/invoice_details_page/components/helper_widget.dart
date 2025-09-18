import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:payzo_books/data/repository/invoice_api/download_invoice_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:permission_handler/permission_handler.dart';

// String formatCurrency(double amount, String currency) {
//   final formatter = NumberFormat.currency(
//     symbol: currency == 'SAR' ? 'SAR' : '$currency ',
//     decimalDigits: 2,
//   );
//   return formatter.format(amount);
// }

String formatDateFn(DateTime? date) {
  if (date == null) return '';
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatPercentage(double? percentage) {
  if (percentage == null) return 'N/A';
  return '${percentage.toStringAsFixed(2)}%';
}

String truncateText(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
}

Future<void> downloadInvoicePdf(
    WidgetRef ref, BuildContext context, int invoiceId) async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final AndroidDeviceInfo? androidInfo =
      Platform.isAndroid ? await deviceInfo.androidInfo : null;

  if (Platform.isAndroid) {
    if (androidInfo!.version.sdkInt >= 30) {
      if (!await Permission.manageExternalStorage.isGranted) {
        var result = await Permission.manageExternalStorage.request();
        if (!result.isGranted) {
          showPermissionDeniedDialog(context);
          return;
        }
      }
    } else {
      if (!await Permission.storage.isGranted) {
        var result = await Permission.storage.request();
        if (!result.isGranted) {
          showPermissionDeniedDialog(context);
          return;
        }
      }
    }
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Center(
      child: CircularProgressIndicator(
        color: AppColors.appMainColor,
      ),
    ),
  );

  try {
    final downloadResult =
        await ref.read(downloadInvoicePdfProvider(invoiceId).future);
    print('aaaaaaaaaaaaaaaa: $downloadResult $invoiceId');
    Navigator.of(context).pop();

    if (downloadResult.isSuccess) {
      final savedFile = await downloadResult.savePdf();

      if (savedFile != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invoice downloaded successfully'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () async {
                final result = await OpenFile.open(savedFile.path);

                if (result.type != ResultType.done) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Could not open file: ${result.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ),
        );
      } else {
        showErrorSnackBar(context, 'Failed to save invoice');
      }
    } else {
      showErrorSnackBar(context, 'Failed to download invoice');
    }
  } catch (e) {
    Navigator.of(context).pop();
    showErrorSnackBar(context, 'Error downloading invoice: $e');
  }
}

void showPermissionDeniedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Storage Permission Required'),
      content: Text(
        Platform.isAndroid
            ? 'Please grant storage permission in app settings to download invoices.'
            : 'Please grant file access permission to download invoices.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            openAppSettings();
          },
          child: Text('Open Settings'),
        ),
      ],
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
    ),
  );
}

double parseDoubleFn(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    try {
      return double.parse(value);
    } catch (_) {
      return 0.0;
    }
  }
  return 0.0;
}
