import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path/path.dart' as path;

class BillDownloadModel {
  final String fileName;
  final String data;
  final String type;
  final String status;

  BillDownloadModel({
    required this.fileName,
    required this.data,
    required this.type,
    required this.status,
  });

  List<int> get pdfBytes => base64Decode(data);

  bool get isSuccess => status == 'success';

  factory BillDownloadModel.empty() => BillDownloadModel(
        fileName: '',
        data: '',
        type: 'application/pdf',
        status: 'error',
      );

  Future<File?> savePdf() async {
    try {
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

      Directory? directory;
      if (Platform.isAndroid) {
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

      String sanitizedFileName =
          fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_.]'), '_');

      if (!sanitizedFileName.toLowerCase().endsWith('.pdf')) {
        sanitizedFileName += '.pdf';
      }

      final filePath = path.join(directory.path, sanitizedFileName);

      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      print('File saved at: $filePath');
      return file;
    } catch (e) {
      print('Error saving PDF: $e');
      return null;
    }
  }

  factory BillDownloadModel.fromMap(Map<String, dynamic> json) {
    return BillDownloadModel(
      fileName: json['fileName'] ?? '',
      data: json['data'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'data': data,
      'type': type,
      'status': status,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'BillDownloadModel(fileName: $fileName, type: $type, status: $status, dataLength: ${data.length})';
  }
}
