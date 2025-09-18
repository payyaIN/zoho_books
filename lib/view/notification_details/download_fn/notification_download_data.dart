import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:payzo_books/data/repository/rfq/download_rfq_repo.dart';
import 'package:payzo_books/import_data.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:payzo_books/data/repository/purchase_order/download_order_details.dart';
import 'package:payzo_books/data/repository/quotes_api/download_quotes.dart';

Future<void> downloadRfqPdf(
    WidgetRef ref, BuildContext context, int rfqId) async {
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
    final downloadResult = await ref.read(downloadRfqPdfProvider(rfqId).future);

    Navigator.of(context).pop();

    final status = downloadResult.status?.toLowerCase() ?? '';
    if (status == 'success') {
      final savedFile = await downloadResult.savePdf();

      if (savedFile != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('RFQ downloaded successfully'),
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
        showErrorSnackBar(context, 'Failed to save RFQ');
      }
    } else {
      showErrorSnackBar(context,
          'Failed to download RFQ: ${downloadResult.message ?? 'Unknown error'}');
    }
  } catch (e) {
    Navigator.of(context).pop();
    showErrorSnackBar(context, 'Error downloading RFQ: $e');
  }
}

Future<void> downloadOrderPdf(
    WidgetRef ref, BuildContext context, int orderId) async {
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
        await ref.read(downloadOrderPdfProvider(orderId).future);

    if (context.mounted) {
      Navigator.of(context).pop();
    }

    if (downloadResult.status?.toLowerCase() == 'success') {
      final savedFile = await downloadResult.savePdf();

      if (savedFile != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order downloaded successfully'),
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
      } else if (context.mounted) {
        showErrorSnackBar(context, 'Failed to save Order');
      }
    } else if (context.mounted) {
      showErrorSnackBar(context,
          'Failed to download Order: ${downloadResult.message ?? "Unknown error"}');
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context).pop();
      showErrorSnackBar(context, 'Error downloading Order: $e');
    }
  }
}

Future<void> downloadQuotePdf(
    WidgetRef ref, BuildContext context, int quoteId) async {
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
        await ref.read(downloadQuotePdfProvider(quoteId).future);

    if (context.mounted) {
      Navigator.of(context).pop();
    }

    if (downloadResult.status?.toLowerCase() == 'success') {
      final savedFile = await downloadResult.savePdf();

      if (savedFile != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Quote downloaded successfully'),
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
      } else if (context.mounted) {
        showErrorSnackBar(context, 'Failed to save Quote');
      }
    } else if (context.mounted) {
      showErrorSnackBar(context,
          'Failed to download Quote: ${downloadResult.message ?? "Unknown error"}');
    }
  } catch (e) {
    if (context.mounted) {
      Navigator.of(context).pop();
      showErrorSnackBar(context, 'Error downloading Quote: $e');
    }
  }
}

void showPermissionDeniedDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Permission Required'),
      content: Text(
          'Storage permission is required to download files. Please grant the permission in app settings.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('OK'),
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
