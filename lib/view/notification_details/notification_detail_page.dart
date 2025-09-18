import 'package:payzo_books/data/repository/purchase_order/get_order_details.dart';
import 'package:payzo_books/data/repository/quotes_api/quotes_details_api.dart';
import 'package:payzo_books/data/repository/rfq/get_rfq_details.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/notification_details/components/notification_common_body.dart';
import 'package:payzo_books/view/notification_details/components/other_widgts.dart';
import 'package:payzo_books/view/notification_details/download_fn/notification_download_data.dart';

class NotificationDetailsPage extends ConsumerWidget {
  final String? typeId;
  final String? processId;
  final int? invoiceId;
  final int? partyId;

  const NotificationDetailsPage(
      {Key? key, this.typeId, this.processId, this.invoiceId, this.partyId})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(getNotificationsProvider);
    final notificationId = ref.watch(selectedNotificationIdProvider);

    NotificationData? selectedNotification;
    if (notificationsAsync.hasValue && notificationId != null) {
      for (var notification in notificationsAsync.value!.data) {
        if (notification.id == notificationId) {
          selectedNotification = notification;
          break;
        }
      }
      if (selectedNotification == null &&
          notificationsAsync.value!.data.isNotEmpty) {
        selectedNotification = notificationsAsync.value!.data.first;
      }
    } else if (notificationsAsync.hasValue &&
        notificationsAsync.value!.data.isNotEmpty) {
      selectedNotification = notificationsAsync.value!.data.first;
    }

    if (selectedNotification == null && notificationsAsync.hasValue) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBgColor,
        body: SafeArea(
          child: Center(child: Text("Notification not found")),
        ),
      );
    }

    int? processIdValue = selectedNotification?.processId;

    bool isInvoice = false;
    bool isBill = false;
    bool isRfq = false;
    bool isQuote = false;
    bool isOrder = false;

    if (selectedNotification != null) {
      final message = selectedNotification.message?.toLowerCase() ?? '';
      isInvoice = message.contains('invoice');
      isBill = message.contains('bill');
      isRfq = message.contains('rfq');
      isQuote = message.contains('quote') || message.contains('quotation');
      isOrder = message.contains('order') || message.contains('po');
    }

    final billDetailsAsync = isBill && processIdValue != null
        ? ref.watch(getBillDetailsProvider(processIdValue))
        : null;
    final invoiceDetailsAsync = isInvoice && processIdValue != null
        ? ref.watch(getInvoiceDetailsProvider(processIdValue))
        : null;
    final rfqDetailsAsync = isRfq && processIdValue != null
        ? ref.watch(getRfqDetailsProvider(processIdValue))
        : null;
    final quoteDetailsAsync = isQuote && processIdValue != null
        ? ref.watch(getQuoteDetailsProvider(processIdValue))
        : null;
    final orderDetailsAsync = isOrder && processIdValue != null
        ? ref.watch(getOrderDetailsProvider(processIdValue))
        : null;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      appBar: reusableAppBar(
          title: _getNotificationTypeTitle(
              isInvoice, isBill, isRfq, isQuote, isOrder),
          showBackButton: true,
          context: context),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.refresh(getNotificationsProvider.future),
          child: notificationsAsync.when(
            data: (_) {
              if (isInvoice && invoiceDetailsAsync != null) {
                return invoiceDetailsAsync.when(
                  data: (invoiceDetail) {
                    final invoiceProductDetails =
                        invoiceDetail.productDetails?.map((item) {
                              return {
                                'productName':
                                    item.productName ?? 'Unknown Product',
                                'productTotal': item.productTotal ?? 0.0,
                                'quantity': item.quantity ?? 0,
                                'unitPrice': item.unitPrice ?? 0.0,
                              };
                            }).toList() ??
                            [];

                    final subTotal = invoiceDetail.invoiceAmount ?? 0.0;
                    final totalAmount = invoiceDetail.invoiceTotalAmount ?? 0.0;
                    final taxAmount = totalAmount - subTotal;

                    DateTime? invoiceDate;
                    DateTime? invoiceDueDate;

                    try {
                      invoiceDate = invoiceDetail.invoiceDate;
                    } catch (e) {
                      print('Error processing invoice date: $e');
                    }

                    try {
                      invoiceDueDate = invoiceDetail.invoiceDueDate;
                    } catch (e) {
                      print('Error processing invoice due date: $e');
                    }

                    return notificationDetailBody(
                      context: context,
                      totalAmount: totalAmount,
                      currency: invoiceDetail.invoiceCurrency ?? 'USD',
                      entityName:
                          invoiceDetail.invoiceCustomerName ?? 'Customer',
                      verificationStatus: invoiceDetail.isInvoiceverified ?? 0,
                      printOnTap: () => downloadInvoicePdf(
                          ref, context, invoiceDetail.invoiceId ?? 0),
                      approveOnTap: invoiceDetail.isInvoiceverified == 1 ||
                              invoiceDetail.isInvoiceverified == 2
                          ? null
                          : () async {
                              int parsedTypeId =
                                  int.tryParse(typeId ?? '4') ?? 4;
                              await approveInvoiceFromNotification(
                                  context, ref, parsedTypeId, processIdValue!);
                              if (context.mounted) {
                                ref.refresh(
                                    getInvoiceDetailsProvider(processIdValue));
                              }
                            },
                      rejectOnTap: invoiceDetail.isInvoiceverified == 1 ||
                              invoiceDetail.isInvoiceverified == 2
                          ? null
                          : () async {
                              int parsedTypeId =
                                  int.tryParse(typeId ?? '4') ?? 4;
                              await promptAndRejectInvoice(
                                  context, ref, parsedTypeId, processIdValue!);
                              if (context.mounted) {
                                ref.refresh(
                                    getInvoiceDetailsProvider(processIdValue));
                              }
                            },
                      documentTitle: "Invoice#",
                      documentNumber: invoiceDetail.invoiceNumber ?? 'N/A',
                      documentDate: invoiceDate,
                      documentDueDate: invoiceDueDate,
                      fourthFieldLabel: "Currency",
                      fourthFieldValue: invoiceDetail.invoiceCurrency ?? 'USD',
                      productDetails: invoiceProductDetails,
                      subTotal: subTotal,
                      notification: selectedNotification,
                      taxAmount: taxAmount,
                      reference: invoiceDetail.invoiceOrderNumber,
                      customerNote: invoiceDetail.invoiceCustomerNotes,
                    );
                  },
                  loading: () => Center(
                      child: CircularProgressIndicator(
                          color: AppColors.appMainColor)),
                  error: (error, stack) => buildErrorView(
                      error: error,
                      errorMessage: "Error loading invoice details",
                      onRetry: () => ref
                          .refresh(getInvoiceDetailsProvider(processIdValue!))),
                );
              } else if (isBill && billDetailsAsync != null) {
                return billDetailsAsync.when(
                  data: (billDetail) {
                    final billProductDetails =
                        billDetail.productDetails?.map((item) {
                              return {
                                'productName':
                                    item.productName ?? 'Unknown Product',
                                'productTotal': item.productTotal ?? 0.0,
                                'quantity': item.quantity ?? 0,
                                'unitPrice': item.unitPrice ?? 0.0,
                              };
                            }).toList() ??
                            [];

                    return notificationDetailBody(
                      context: context,
                      totalAmount: billDetail.billTotalAmount ?? 0.0,
                      currency: billDetail.billCurrency ?? 'USD',
                      entityName: billDetail.billVenderName ?? 'Vendor',
                      verificationStatus: billDetail.isBillVerified ?? 0,
                      printOnTap: () =>
                          downloadBillPdf(ref, context, billDetail.billId ?? 0),
                      approveOnTap: billDetail.isBillVerified == 1 ||
                              billDetail.isBillVerified == 2
                          ? null
                          : () async {
                              int parsedTypeId =
                                  int.tryParse(typeId ?? '4') ?? 4;
                              await approveBillFromNotification(context, ref,
                                  parsedTypeId, processIdValue ?? 1);
                              if (context.mounted) {
                                ref.refresh(getBillDetailsProvider(
                                    processIdValue ?? 1));
                              }
                            },
                      rejectOnTap: billDetail.isBillVerified == 1 ||
                              billDetail.isBillVerified == 2
                          ? null
                          : () async {
                              int parsedTypeId =
                                  int.tryParse(typeId ?? '4') ?? 4;
                              await promptAndRejectBill(context, ref,
                                  parsedTypeId, processIdValue ?? 1);
                              if (context.mounted) {
                                ref.refresh(getBillDetailsProvider(
                                    processIdValue ?? 1));
                              }
                            },
                      documentTitle: "Bill#",
                      documentNumber: billDetail.billInvoiceNumber ?? 'N/A',
                      documentDate: billDetail.billDate,
                      documentDueDate: billDetail.billDueDate,
                      fourthFieldLabel: "Branch",
                      fourthFieldValue: "Main Branch",
                      productDetails: billProductDetails,
                      subTotal: billDetail.billAmount ?? 0.0,
                      notification: selectedNotification,
                      taxAmount: (billDetail.billTotalAmount ?? 0.0) -
                          (billDetail.billAmount ?? 0.0),
                      reference: billDetail.billOrderNumber,
                      customerNote: billDetail.billCustomerNotes,
                    );
                  },
                  loading: () => Center(
                      child: CircularProgressIndicator(
                          color: AppColors.appMainColor)),
                  error: (error, stack) => buildErrorView(
                      error: error,
                      errorMessage: "Error loading bill details",
                      onRetry: () =>
                          ref.refresh(getBillDetailsProvider(processIdValue!))),
                );
              } else if (isQuote && quoteDetailsAsync != null) {
                return quoteDetailsAsync.when(
                  data: (quoteDetail) {
                    final quoteProductDetails =
                        quoteDetail.productDetails?.map((item) {
                              return {
                                'productName':
                                    item.productName ?? 'Unknown Product',
                                'productTotal': item.productTotal ?? 0.0,
                                'quantity': item.quantity ?? 0,
                                'unitPrice': item.unitPrice ?? 0.0,
                              };
                            }).toList() ??
                            [];

                    DateTime? quotePostedDate;
                    DateTime? quoteExpDate;

                    try {
                      if (quoteDetail.quotePostedDate != null) {
                        quotePostedDate =
                            DateTime.tryParse(quoteDetail.quotePostedDate!);
                      }
                    } catch (e) {
                      print('Error parsing quote posted date: $e');
                    }

                    try {
                      if (quoteDetail.quoteExpDate != null) {
                        quoteExpDate =
                            DateTime.tryParse(quoteDetail.quoteExpDate!);
                      }
                    } catch (e) {
                      print('Error parsing quote expiration date: $e');
                    }

                    final subTotal =
                        (quoteDetail.quoteProductTotal ?? 0.0).toDouble();
                    final totalAmount =
                        (quoteDetail.quoteProductTotalWithTax ?? 0.0)
                            .toDouble();
                    final taxAmount = totalAmount - subTotal;

                    return notificationDetailBody(
                      context: context,
                      totalAmount: totalAmount,
                      currency: quoteDetail.quoteCurrency ?? 'SAR',
                      entityName: quoteDetail.quoteName ?? 'Quote',
                      verificationStatus:
                          (quoteDetail.qteIsVerified ?? 0).toInt(),
                      printOnTap: () => downloadQuotePdf(
                          ref, context, quoteDetail.quoteId?.toInt() ?? 0),
                      approveOnTap: (quoteDetail.qteIsVerified == 1 ||
                              quoteDetail.qteIsVerified == 2)
                          ? null
                          : () async {
                              int parsedTypeId =
                                  int.tryParse(typeId ?? '4') ?? 4;
                              await approveNotification(
                                context: context,
                                ref: ref,
                                typeId: parsedTypeId,
                                processId: processIdValue ?? 1,
                                itemType: 'Quote',
                                refreshAction: () => ref.refresh(
                                    getQuoteDetailsProvider(processIdValue ?? 1)
                                        .future),
                              );
                              if (context.mounted) {
                                ref.refresh(getQuoteDetailsProvider(
                                    processIdValue ?? 1));
                              }
                            },
                      rejectOnTap: (quoteDetail.qteIsVerified == 1 ||
                              quoteDetail.qteIsVerified == 2)
                          ? null
                          : () async {
                              int parsedTypeId =
                                  int.tryParse(typeId ?? '4') ?? 4;
                              await showRejectReasonDialog(
                                context: context,
                                ref: ref,
                                typeId: parsedTypeId,
                                processId: processIdValue ?? 1,
                                itemType: 'Quote',
                                onRejectWithReason: (reason) async {
                                  return await rejectNotification(
                                    context: context,
                                    ref: ref,
                                    typeId: parsedTypeId,
                                    processId: processIdValue ?? 1,
                                    reason: reason,
                                    itemType: 'Quote',
                                    refreshAction: () => ref.refresh(
                                        getQuoteDetailsProvider(
                                                processIdValue ?? 1)
                                            .future),
                                  );
                                },
                              );
                              if (context.mounted) {
                                ref.refresh(getQuoteDetailsProvider(
                                    processIdValue ?? 1));
                              }
                            },
                      documentTitle: "Quote#",
                      documentNumber: quoteDetail.quoteReference ?? '',
                      documentDate: quotePostedDate,
                      documentDueDate: quoteExpDate,
                      fourthFieldLabel: "Customer Note",
                      fourthFieldValue: quoteDetail.quoteCustomerNote ?? 'N/A',
                      productDetails: quoteProductDetails,
                      subTotal: subTotal,
                      notification: selectedNotification,
                      taxAmount: taxAmount,
                      customerNote: quoteDetail.quoteCustomerNote,
                      reference: quoteDetail.quoteReference,
                    );
                  },
                  loading: () => Center(
                      child: CircularProgressIndicator(
                          color: AppColors.appMainColor)),
                  error: (error, stack) => buildErrorView(
                      error: error,
                      errorMessage: "Error loading Quote details",
                      onRetry: () => ref
                          .refresh(getQuoteDetailsProvider(processIdValue!))),
                );
              } else if (isRfq && rfqDetailsAsync != null) {
                return rfqDetailsAsync.when(
                  // data: (rfqDetail) {
                  //   // Handle RFQ details data
                  //   final rfqDetails = rfqDetail.rfqDetails;
                  //   if (rfqDetails == null) {
                  //     return Center(child: Text("No RFQ details found"));
                  //   }

                  //   // Parse dates
                  //   DateTime? rfqCreatedDate;
                  //   DateTime? rfqExpDate;
                  data: (rfqDetails) {
                    DateTime? rfqCreatedDate;
                    DateTime? rfqExpDate;

                    try {
                      if (rfqDetails.rfqCreatedDate != null &&
                          rfqDetails.rfqCreatedDate!.isNotEmpty) {
                        rfqCreatedDate =
                            DateTime.tryParse(rfqDetails.rfqCreatedDate!);
                      }
                    } catch (e) {
                      print('Error parsing rfqCreatedDate: $e');
                    }

                    try {
                      if (rfqDetails.rfqExpDate != null &&
                          rfqDetails.rfqExpDate!.isNotEmpty) {
                        rfqExpDate = DateTime.tryParse(rfqDetails.rfqExpDate!);
                      }
                    } catch (e) {
                      print('Error parsing rfqExpDate: $e');
                    }

                    final rfqProductDetails =
                        rfqDetails.productDetails?.map((item) {
                              return {
                                'productName':
                                    item.productName ?? 'Unknown Product',
                                'productTotal':
                                    item.totalPrice?.toDouble() ?? 0.0,
                                'quantity': item.quantity?.toInt() ?? 0,
                                'unitPrice': item.unitPrice?.toDouble() ?? 0.0,
                              };
                            }).toList() ??
                            [];

                    final totalAmount =
                        rfqDetails.rfqTotalAmt?.toDouble() ?? 0.0;
                    final subTotal = totalAmount;
                    const taxAmount = 0.0;

                    return notificationDetailBody(
                      context: context,
                      totalAmount: totalAmount,
                      currency: rfqDetails.rfqCurrency ?? 'SAR',
                      entityName: rfqDetails.rfqName ?? 'RFQ',
                      verificationStatus:
                          rfqDetails.rfqIsverified?.toInt() ?? 0,
                      printOnTap: () => downloadRfqPdf(
                          ref, context, rfqDetails.rfqId?.toInt() ?? 0),
                      approveOnTap: (rfqDetails.rfqIsverified == 1 ||
                              rfqDetails.rfqIsverified == 2)
                          ? null
                          : () async {
                              int parsedTypeId =
                                  int.tryParse(typeId ?? '1') ?? 1;
                              await approveNotification(
                                context: context,
                                ref: ref,
                                typeId: parsedTypeId,
                                processId: processIdValue ?? 1,
                                itemType: 'RFQ',
                                refreshAction: () => ref.refresh(
                                    getRfqDetailsProvider(processIdValue ?? 1)
                                        .future),
                              );
                              if (context.mounted) {
                                ref.refresh(
                                    getRfqDetailsProvider(processIdValue ?? 1));
                              }
                            },
                      rejectOnTap: (rfqDetails.rfqIsverified == 1 ||
                              rfqDetails.rfqIsverified == 2)
                          ? null
                          : () async {
                              int parsedTypeId =
                                  int.tryParse(typeId ?? '1') ?? 1;
                              await showRejectReasonDialog(
                                context: context,
                                ref: ref,
                                typeId: parsedTypeId,
                                processId: processIdValue ?? 1,
                                itemType: 'RFQ',
                                onRejectWithReason: (reason) async {
                                  return await rejectNotification(
                                    context: context,
                                    ref: ref,
                                    typeId: parsedTypeId,
                                    processId: processIdValue ?? 1,
                                    reason: reason,
                                    itemType: 'RFQ',
                                    refreshAction: () => ref.refresh(
                                        getRfqDetailsProvider(
                                                processIdValue ?? 1)
                                            .future),
                                  );
                                },
                              );
                              if (context.mounted) {
                                ref.refresh(
                                    getRfqDetailsProvider(processIdValue ?? 1));
                              }
                            },
                      documentTitle: "RFQ#",
                      documentNumber: rfqDetails.rfqReference ?? '',
                      documentDate: rfqCreatedDate,
                      documentDueDate: rfqExpDate,
                      fourthFieldLabel: "Customer Note",
                      fourthFieldValue: rfqDetails.rfqCustomerNote ?? 'N/A',
                      productDetails: rfqProductDetails,
                      subTotal: subTotal,
                      notification: selectedNotification,
                      taxAmount: taxAmount,
                      customerNote: rfqDetails.rfqCustomerNote,
                      reference: rfqDetails.rfqReference,
                    );
                  },
                  loading: () => Center(
                    child: CircularProgressIndicator(
                        color: AppColors.appMainColor),
                  ),
                  error: (error, stack) => buildErrorView(
                    error: error,
                    errorMessage: "Error loading RFQ details",
                    onRetry: () =>
                        ref.refresh(getRfqDetailsProvider(processIdValue!)),
                  ),
                );
              } else if (isOrder && orderDetailsAsync != null) {
                return orderDetailsAsync.when(
                  data: (orderDetail) {
                    final orderProductDetails =
                        orderDetail.productDetails?.map((item) {
                              return {
                                'productName':
                                    item.productName ?? 'Unknown Product',
                                'productTotal': item.productTotal ?? 0.0,
                                'quantity': item.quantity ?? 0,
                                'unitPrice': item.unitPrice ?? 0.0,
                              };
                            }).toList() ??
                            [];

                    DateTime? orderDate;
                    try {
                      if (orderDetail.poOrderDate != null) {
                        orderDate = DateTime.tryParse(orderDetail.poOrderDate!);
                      }
                    } catch (e) {
                      print('Error parsing order date: $e');
                    }

                    final subTotal =
                        (orderDetail.poProductTotal ?? 0.0).toDouble();
                    final totalAmount =
                        (orderDetail.poProductTotalWithTax ?? 0.0).toDouble();
                    final taxAmount = totalAmount - subTotal;

                    return notificationDetailBody(
                      context: context,
                      totalAmount: totalAmount,
                      currency: orderDetail.poCurrency ?? 'SAR',
                      entityName: orderDetail.poName ?? 'Order',
                      verificationStatus:
                          orderDetail.poIsVerified?.toInt() ?? 0,
                      printOnTap: () => downloadOrderPdf(
                          ref, context, orderDetail.poId?.toInt() ?? 0),
                      approveOnTap: orderDetail.poIsVerified == 1 ||
                              orderDetail.poIsVerified == 2
                          ? null
                          : () async {
                              int parsedTypeId =
                                  int.tryParse(typeId ?? '3') ?? 3;
                              await approveNotification(
                                context: context,
                                ref: ref,
                                typeId: parsedTypeId,
                                processId: processIdValue ?? 1,
                                itemType: 'Purchase Order',
                                refreshAction: () => ref.refresh(
                                    getOrderDetailsProvider(processIdValue ?? 1)
                                        .future),
                              );
                              if (context.mounted) {
                                ref.refresh(getOrderDetailsProvider(
                                    processIdValue ?? 1));
                              }
                            },
                      rejectOnTap: orderDetail.poIsVerified == 1 ||
                              orderDetail.poIsVerified == 2
                          ? null
                          : () async {
                              int parsedTypeId =
                                  int.tryParse(typeId ?? '3') ?? 3;
                              await showRejectReasonDialog(
                                context: context,
                                ref: ref,
                                typeId: parsedTypeId,
                                processId: processIdValue ?? 1,
                                itemType: 'Purchase Order',
                                onRejectWithReason: (reason) async {
                                  return await rejectNotification(
                                    context: context,
                                    ref: ref,
                                    typeId: parsedTypeId,
                                    processId: processIdValue ?? 1,
                                    reason: reason,
                                    itemType: 'Purchase Order',
                                    refreshAction: () => ref.refresh(
                                        getOrderDetailsProvider(
                                                processIdValue ?? 1)
                                            .future),
                                  );
                                },
                              );
                              if (context.mounted) {
                                ref.refresh(getOrderDetailsProvider(
                                    processIdValue ?? 1));
                              }
                            },
                      documentTitle: "PO#",
                      documentNumber: orderDetail.poOrdCode ?? '',
                      documentDate: orderDate,
                      documentDueDate: null,
                      fourthFieldLabel: "Reference",
                      fourthFieldValue: orderDetail.poReference ?? 'N/A',
                      productDetails: orderProductDetails,
                      subTotal: subTotal,
                      notification: selectedNotification,
                      taxAmount: taxAmount,
                      reference: orderDetail.poReference,
                      customerNote: orderDetail.poAdditionalDetails,
                    );
                  },
                  loading: () => Center(
                      child: CircularProgressIndicator(
                          color: AppColors.appMainColor)),
                  error: (error, stack) => buildErrorView(
                    error: error,
                    errorMessage: "Error loading Order details",
                    onRetry: () =>
                        ref.refresh(getOrderDetailsProvider(processIdValue!)),
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Unable to load details for this notification",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      if (selectedNotification?.message != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: buildNotificationMessageBox(
                              selectedNotification!),
                        ),
                    ],
                  ),
                );
              }
            },
            loading: () => Center(
                child:
                    CircularProgressIndicator(color: AppColors.appMainColor)),
            error: (error, stack) => buildErrorView(
              error: error,
              errorMessage: "Error loading notification details",
              onRetry: () => ref.refresh(getNotificationsProvider),
            ),
          ),
        ),
      ),
    );
  }

  String _getNotificationTypeTitle(
      bool isInvoice, bool isBill, bool isRfq, bool isQuote, bool isOrder) {
    if (isInvoice) return "Invoice Details";
    if (isBill) return "Bill Details";
    if (isRfq) return "RFQ Details";
    if (isQuote) return "Quote Details";
    if (isOrder) return "Purchase Order Details";
    return "Notification Details";
  }
}
