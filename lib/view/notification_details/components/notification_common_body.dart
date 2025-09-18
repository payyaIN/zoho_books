import 'package:flutter/material.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/common_widgets/status_color_widget.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';

SingleChildScrollView notificationDetailBody({
  required BuildContext context,
  required double totalAmount,
  required String currency,
  required String entityName,
  required int verificationStatus,
  required VoidCallback printOnTap,
  VoidCallback? approveOnTap,
  VoidCallback? rejectOnTap,
  required String documentTitle,
  required String documentNumber,
  required DateTime? documentDate,
  required DateTime? documentDueDate,
  required String fourthFieldLabel,
  required String fourthFieldValue,
  required List<dynamic> productDetails,
  required double subTotal,
  required NotificationData? notification,
  double? taxAmount,
  String? customerNote,
  String? reference,
}) {
  final calculatedTaxAmount = taxAmount ?? (totalAmount - subTotal);

  return SingleChildScrollView(
    physics: BouncingScrollPhysics(),
    child: Column(
      children: [
        ReusableContainer(
          color: Colors.white,
          child: Column(
            children: [
              // Status indicator
              // Container(
              //   margin:
              //       const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              //   alignment: Alignment.centerRight,
              //   child: Container(
              //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              //     decoration: BoxDecoration(
              //       color: _getStatusColor(verificationStatus),
              //       borderRadius: BorderRadius.circular(20),
              //     ),
              //     child: Text(
              //       getStatusText(verificationStatus),
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold,
              //         fontSize: 12,
              //       ),
              //     ),
              //   ),
              // ),

              Text(
                formatCurrency(totalAmount, currency),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              Text(
                entityName,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: shouldShowOnlyPrintButton(verificationStatus)
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          actionButton(Icons.print, 'Print PDF',
                              onTap: printOnTap),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (approveOnTap != null)
                            actionButton(
                              Icons.thumb_up,
                              'Approve',
                              onTap: approveOnTap,
                            ),
                          if (rejectOnTap != null)
                            actionButton(Icons.thumb_down, 'Reject',
                                onTap: rejectOnTap),
                          actionButton(
                            Icons.print,
                            'Print PDF',
                            onTap: printOnTap,
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
        const SizedBox(height: 20),
        billDataNotification(
            context: context,
            statusText: getNotificationStatusText(notification!.message
                .toString()), //  getBillAndInvoiceStatusText(verificationStatus),
            statusColor: getNotificationStatusColor(
                verificationStatus), //getIntStatusColor(verificationStatus),
            leftText1: documentTitle,
            leftText2: "Date",
            leftText3: "Due Date",
            leftText4: fourthFieldLabel,
            rightText1: documentNumber,
            rightText2: _formatDateString(documentDate),
            rightText3: _formatDateString(documentDueDate),
            rightText4: fourthFieldValue),
        if (reference != null && reference.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22, top: 15),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Reference",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.loginTextColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    reference,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (customerNote != null &&
            customerNote.isNotEmpty &&
            customerNote != 'N/A')
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22, top: 15),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Notes",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.loginTextColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    customerNote,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (productDetails.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 22, top: 15),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Products",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.loginTextColor,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: productDetails.length,
                    separatorBuilder: (context, index) => Divider(),
                    itemBuilder: (context, index) {
                      final item =
                          productDetails[index] as Map<String, dynamic>;
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(item['productName'] ?? 'Unknown Product'),
                        trailing: Text(formatCurrency(
                            (item['productTotal'] ?? 0.0).toDouble(),
                            currency)),
                        subtitle: Text(
                            '${item['quantity'] ?? 0} x ${formatCurrency((item['unitPrice'] ?? 0.0).toDouble(), currency)}'),
                      );
                    },
                  ),
                  PayzoDivider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Sub Total'),
                    trailing: Text(
                      formatCurrency(subTotal, currency),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  PayzoDivider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Tax'),
                    trailing: Text(
                      formatCurrency(calculatedTaxAmount, currency),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  PayzoDivider(),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      formatCurrency(totalAmount, currency),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        SizedBox(height: 20),
        if (notification?.message != null)
          buildNotificationMessageBox(notification!),
        SizedBox(height: 40),
      ],
    ),
  );
}

String _formatDateString(DateTime? date) {
  if (date == null) return 'N/A';
  return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
}
