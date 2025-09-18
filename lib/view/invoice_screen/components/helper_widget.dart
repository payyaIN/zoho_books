// String getBillAndInvoiceStatusText(int? billStatus, int? isBillVerified) {
//   if (billStatus == null) return "PENDING";

//   switch (billStatus) {
//     case 0:
//       return "DRAFT";
//     case 1:
//       return isBillVerified == 1 ? "OPEN" : "PENDING";
//     case 2:
//       return "PARTIALLY PAID";
//     case 3:
//       return "PAID";
//     case 4:
//       return "REJECTED";
//     default:
//       return "PENDING";
//   }
// }

String truncateTextFn(String? text, int maxLength) {
  if (text == null || text.isEmpty) return "";
  if (text.length <= maxLength) return text;
  return text.substring(0, maxLength) + '...';
}
