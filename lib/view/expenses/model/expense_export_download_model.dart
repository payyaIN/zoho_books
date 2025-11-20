import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path/path.dart' as path;

class ExpenseExportDownloadModel {
  final String fileName;
  final String data;
  final String status;

  ExpenseExportDownloadModel({
    required this.fileName,
    required this.data,
    required this.status,
  });

  List<int> get fileBytes => base64Decode(data);

  bool get isSuccess => status == 'success';

  factory ExpenseExportDownloadModel.empty() => ExpenseExportDownloadModel(
        fileName: '',
        data: '',
        status: 'error',
      );

  /// Save Excel file to Download folder
  Future<File?> saveToDownloadFolder() async {
    try {
      // Request storage permissions
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      final AndroidDeviceInfo? androidInfo =
          Platform.isAndroid ? await deviceInfo.androidInfo : null;

      if (Platform.isAndroid) {
        if (androidInfo!.version.sdkInt >= 30) {
          if (!await Permission.manageExternalStorage.isGranted) {
            var result = await Permission.manageExternalStorage.request();
            if (!result.isGranted) {
              print('Manage External Storage permission not granted');
              return null;
            }
          }
        } else {
          if (!await Permission.storage.isGranted) {
            var result = await Permission.storage.request();
            if (!result.isGranted) {
              print('Storage permission not granted');
              return null;
            }
          }
        }
      }

      // Get Download directory
      Directory? directory;
      if (Platform.isAndroid) {
        // Use the public Download folder
        directory = Directory('/storage/emulated/0/Download');

        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      }

      if (directory == null) {
        print('Could not get storage directory');
        return null;
      }

      // Sanitize filename
      String sanitizedFileName =
          fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_.]'), '_');

      if (!sanitizedFileName.toLowerCase().endsWith('.xlsx')) {
        sanitizedFileName += '.xlsx';
      }

      final filePath = path.join(directory.path, sanitizedFileName);

      // Write file
      final file = File(filePath);
      await file.writeAsBytes(fileBytes);

      print('Expense Excel file saved at: $filePath');
      return file;
    } catch (e) {
      print('Error saving Excel file: $e');
      return null;
    }
  }

  factory ExpenseExportDownloadModel.fromJson(Map<String, dynamic> json) {
    return ExpenseExportDownloadModel(
      fileName: json['fileName'] ?? '',
      data: json['data'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'data': data,
      'status': status,
    };
  }
}
