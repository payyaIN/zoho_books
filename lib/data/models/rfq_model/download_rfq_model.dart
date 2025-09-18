import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path/path.dart' as path;

class RfqDownloadModel {
  final String? fileName;
  final String? data;
  final String? type;
  final String? status;
  final String? message;

  RfqDownloadModel({
    this.fileName = '',
    this.data = '',
    this.type = '',
    this.status = '',
    this.message = '',
  });

  List<int> get pdfBytes => data != null ? base64Decode(data!) : [];

  bool get isSuccess => status?.toLowerCase() == 'success';

  factory RfqDownloadModel.empty() => RfqDownloadModel(
        fileName: '',
        data: '',
        type: 'application/pdf',
        status: 'error',
        message: 'Empty model',
      );

  Future<File?> savePdf() async {
    try {
      if (data == null || data!.isEmpty) {
        print('PDF data is empty');
        return null;
      }

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

      String sanitizedFileName = fileName != null && fileName!.isNotEmpty
          ? fileName!.replaceAll(RegExp(r'[^a-zA-Z0-9_.]'), '_')
          : 'rfq_document.pdf';

      if (!sanitizedFileName.toLowerCase().endsWith('.pdf')) {
        sanitizedFileName += '.pdf';
      }

      final filePath = path.join(directory.path, sanitizedFileName);

      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      print('RFQ File saved at: $filePath');
      return file;
    } catch (e) {
      print('Error saving RFQ PDF: $e');
      return null;
    }
  }

  factory RfqDownloadModel.fromJson(Map<String, dynamic> json) {
    return RfqDownloadModel(
      fileName: json['fileName'],
      data: json['data'],
      type: json['type'],
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'data': data,
      'type': type,
      'status': status,
      'message': message,
    };
  }

  @override
  String toString() {
    return 'RfqDownloadModel(fileName: $fileName, type: $type, status: $status, dataLength: ${data?.length ?? 0})';
  }
}
