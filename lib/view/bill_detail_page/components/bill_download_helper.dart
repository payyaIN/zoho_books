import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_file/open_file.dart';
import 'package:payzo_books/data/repository/bills_api/download_bill.dart';
import 'package:payzo_books/import_data.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadBillPdf(
    WidgetRef ref, BuildContext context, int billId) async {
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
        await ref.read(downloadBillPdfProvider(billId).future);

    Navigator.of(context).pop();

    if (downloadResult.isSuccess) {
      final savedFile = await downloadResult.savePdf();

      if (savedFile != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bill downloaded successfully'),
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
        showErrorSnackBar(context, 'Failed to save bill');
      }
    } else {
      showErrorSnackBar(context, 'Failed to download bill');
    }
  } catch (e) {
    Navigator.of(context).pop();
    showErrorSnackBar(context, 'Error downloading bill: $e');
  }
}
