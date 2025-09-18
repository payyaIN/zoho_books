import 'package:payzo_books/import_data.dart';

String getBillAndInvoiceStatusText(int? billStatus) {
  switch (billStatus) {
    case 0:
      return "NOT GENERATED";
    case 1:
      return "PENDING";
    case 2:
      return "REJECTED";
    case 3:
      return "OPEN";
    case 4:
      return "OVERDUE";
    case 5:
      return "PROCESSING";
    case 6:
      return "PAID";
    case 7:
      return "DRAFT";
    case 8:
      return "PARTIALLY PAID";
    default:
      return "PENDING";
  }
}

Color getStatusColor(String billStatus) {
  switch (billStatus) {
    case "PENDING":
      return Colors.orange;
    case "OPEN":
    case "PAID":
      return Colors.green;
    case "PARTIALLY PAID":
      return Colors.green;
    case "DRAFT":
      return Colors.blue;
    case "NOT GENERATED":
      return Colors.purple;
    case "REJECTED":
      return Colors.red;
    case "OVERDUE":
      return Colors.deepOrange;
    case "PROCESSING":
      return Colors.blueGrey;
    default:
      return Colors.grey;
  }
}

Color getIntStatusColor(int? billStatus) {
  switch (billStatus) {
    case 0:
      return Colors.purple;
    case 1:
      return Colors.orange;
    case 2:
      return Colors.red;
    case 3:
      return Colors.green;
    case 4:
      return Colors.deepOrange;
    case 5:
      return Colors.blueGrey;
    case 6:
      return Colors.green;
    case 7:
      return Colors.blue;
    case 8:
      return Colors.green;

    default:
      return Colors.grey;
  }
}

Color getStatusBackgroundColor(String status) {
  return getStatusColor(status).withOpacity(0.1);
}

String getNotificationStatusText(String message) {
  final msg = message.toLowerCase();

  if (msg.contains('rejected')) {
    return 'REJECTED';
  } else if (msg.contains('waiting for the approval')) {
    return 'PENDING';
  } else if (msg.contains('onboarded')) {
    return 'OPEN';
  } else if (msg.contains('completed')) {
    return 'APPROVED';
  } else {
    return 'UNKNOWN';
  }
}

Color getNotificationStatusColor(int status) {
  switch (status) {
    case 0:
      return Colors.orange;
    case 1:
      return Colors.green;
    case 2:
      return Colors.red;
    case 3:
      return Colors.green;
    default:
      return Colors.grey;
  }
}
