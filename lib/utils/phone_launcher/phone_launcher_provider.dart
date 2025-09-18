import 'package:payzo_books/import_data.dart';

final phoneLauncherProvider = Provider<PhoneLauncher>((ref) {
  return PhoneLauncher();
});

class PhoneLauncher {
  Future<void> makePhoneCall(String phoneNumber) async {
    final String cleanPhone = phoneNumber.replaceAll(RegExp(r'\s+'), '');
    final Uri phoneUri = Uri.parse('tel:$cleanPhone');

    try {
      if (!await canLaunchUrl(phoneUri)) {
        print('Cannot launch phone app');
        return;
      }

      await launchUrl(
        phoneUri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      print('Error launching phone call: $e');
    }
  }

  Future<void> sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': '',
      },
    );

    try {
      print('Attempting to launch: ${emailLaunchUri.toString()}');

      final result = await launchUrl(
        emailLaunchUri,
        mode: LaunchMode.externalApplication,
      );

      print('Launch result: $result');
    } catch (e) {
      print('Error launching email: $e');

      try {
        final String simpleMailto = 'mailto:$email';
        print('Trying alternate format: $simpleMailto');

        await launchUrl(
          Uri.parse(simpleMailto),
          mode: LaunchMode.externalApplication,
        );
      } catch (e) {
        print('Alternative email launch also failed: $e');
      }
    }
  }

  Future<void> sendSms(String phoneNumber) async {
    final String cleanPhoneNumber =
        phoneNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    try {
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: cleanPhoneNumber,
      );

      print('Attempting to launch SMS with URI: $smsUri');

      await launchUrl(
        smsUri,
        mode: LaunchMode.externalNonBrowserApplication,
      );
    } catch (e) {
      print('Error launching SMS: $e');

      try {
        final Uri altUri = Uri.parse('smsto:$cleanPhoneNumber');
        await launchUrl(
          altUri,
          mode: LaunchMode.externalNonBrowserApplication,
        );
      } catch (e) {
        print('Alternative SMS launch also failed: $e');
      }
    }
  }
}
