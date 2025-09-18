import 'package:payzo_books/data/models/recurring_invoice_model/all_recurring_invoice_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetAllRecurringInvoiceRepository {
  final BaseApiService _apiService;
  GetAllRecurringInvoiceRepository(this._apiService);

  Future<GetAllRecurringInvoiceModel> fetchRecurringInvoices({
    String recInvId = "",
    String recInvOrderNumber = "",
    String recInvStatus = "",
    String field = "recInvCreatedDate",
    String order = "-1",
    int rowPerPage = 15,
    int pageNo = 0,
  }) async {
    try {
      print('Fetching recurring invoices: page $pageNo, rows $rowPerPage');

      final body = {
        "requestCriteria": {
          "recInvId": recInvId,
          "recInvOrderNumber": recInvOrderNumber,
          "recInvStatus": recInvStatus
        },
        "sortingCriteria": {"field": field, "order": order},
        "rowPerPage": rowPerPage,
        "pageNo": pageNo
      };

      return await _apiService.postApi(
        url: "api/getAllRecurringInvoice",
        body: body,
        fromJson: (json) {
          print('Recurring invoice API response received');
          return GetAllRecurringInvoiceModel.fromMap(json);
        },
      );
    } catch (e) {
      print('Error fetching recurring invoices: $e');
      return GetAllRecurringInvoiceModel.empty();
    }
  }
}

final getAllRecurringInvoiceRepository =
    Provider<GetAllRecurringInvoiceRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllRecurringInvoiceRepository(apiService);
});

final getAllRecurringInvoiceData =
    FutureProvider<GetAllRecurringInvoiceModel>((ref) async {
  print('getAllRecurringInvoiceData provider called with default parameters');
  final repository = ref.read(getAllRecurringInvoiceRepository);
  final result = await repository.fetchRecurringInvoices();
  print('Recurring invoices fetched: ${result.recInvoiceData.length} invoices');
  return result;
});

final getRecurringInvoiceWithPaginationProvider = FutureProvider.family<
    GetAllRecurringInvoiceModel,
    RecurringInvoicePaginationParams>((ref, params) async {
  print(
      'getRecurringInvoiceWithPaginationProvider called with page: ${params.pageNo}, rows: ${params.rowPerPage}');
  final repository = ref.read(getAllRecurringInvoiceRepository);
  final result = await repository.fetchRecurringInvoices(
    recInvId: params.recInvId,
    recInvOrderNumber: params.recInvOrderNumber,
    recInvStatus: params.recInvStatus,
    field: params.field,
    order: params.order,
    rowPerPage: params.rowPerPage,
    pageNo: params.pageNo,
  );
  print(
      'Recurring invoices fetched with pagination: ${result.recInvoiceData.length} invoices');
  return result;
});

class RecurringInvoicePaginationParams {
  final String recInvId;
  final String recInvOrderNumber;
  final String recInvStatus;
  final String field;
  final String order;
  final int rowPerPage;
  final int pageNo;

  RecurringInvoicePaginationParams({
    this.recInvId = "",
    this.recInvOrderNumber = "",
    this.recInvStatus = "",
    this.field = "recInvCreatedDate",
    this.order = "-1",
    this.rowPerPage = 15,
    this.pageNo = 0,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecurringInvoicePaginationParams &&
        other.recInvId == recInvId &&
        other.recInvOrderNumber == recInvOrderNumber &&
        other.recInvStatus == recInvStatus &&
        other.field == field &&
        other.order == order &&
        other.rowPerPage == rowPerPage &&
        other.pageNo == pageNo;
  }

  @override
  int get hashCode =>
      recInvId.hashCode ^
      recInvOrderNumber.hashCode ^
      recInvStatus.hashCode ^
      field.hashCode ^
      order.hashCode ^
      rowPerPage.hashCode ^
      pageNo.hashCode;
}
