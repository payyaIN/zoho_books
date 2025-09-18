import 'package:payzo_books/data/models/bill_model/bill_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';
import 'dart:developer' as developer;

class GetAllBillRepository {
  final BaseApiService _apiService;
  GetAllBillRepository(this._apiService);

  Future<BillModel> fetchBillData({
    int pageNo = 0,
    int rowsPerPage = 15,
    String? searchQuery,
  }) async {
    try {
      final int pageOffset = pageNo * rowsPerPage;

      developer.log(
          'BILL API REQUEST: PageIndex=$pageNo, Offset=$pageOffset, Rows=$rowsPerPage, Query=$searchQuery',
          name: 'BillsAPI');

      final Map<String, dynamic> requestBody;

      if (searchQuery != null && searchQuery.isNotEmpty) {
        requestBody = {
          "requestCriteria": {
            "billId": "",
            "billInvoiceNumber": searchQuery,
            "billStatus": "",
            "billRecurringId": "",
            "billIsVerified": "",
            "billDateFrom": null,
            "billDateTo": null,
            "billTotalAmountMin": 0,
            "billTotalAmountMax": null
          },
          "sortingCriteria": {"field": "billCreatedDate", "order": "-1"},
          "rowPerPage": rowsPerPage,
          "pageNo": pageOffset
        };
        developer.log('Searching bills by Reference No: "$searchQuery"',
            name: 'BillsAPI');
      } else {
        requestBody = {
          "requestCriteria": {
            "billId": "",
            "billInvoiceNumber": "",
            "billStatus": "",
            "billRecurringId": "",
            "billIsVerified": "",
            "billDateFrom": null,
            "billDateTo": null,
            "billTotalAmountMin": 0,
            "billTotalAmountMax": null
          },
          "sortingCriteria": {"field": "billCreatedDate", "order": "-1"},
          "rowPerPage": rowsPerPage,
          "pageNo": pageOffset
        };
      }

      developer.log('BILL API REQUEST BODY: ${requestBody.toString()}',
          name: 'BillsAPI');

      var result = await _apiService.postApi(
        url: "http://158.101.247.195/pb-process-service/bill/getAllBill",
        body: requestBody,
        fromJson: (json) {
          developer.log(
              'BILL API RESPONSE RECEIVED for page offset $pageOffset',
              name: 'BillsAPI');

          if (json is Map<String, dynamic>) {
            final count = json['count'];
            final totalCount = json['totalCount'];
            final billData = json['billData'];

            developer.log(
                'RESPONSE STATS: count=$count, totalCount=$totalCount, billData.length=${billData?.length ?? 0}',
                name: 'BillsAPI');

            if (billData is List && billData.isNotEmpty) {
              developer.log(
                  'FIRST BILL: ID=${billData[0]['billId']}, Ref=${billData[0]['billInvoiceNumber']}',
                  name: 'BillsAPI');
              developer.log(
                  'LAST BILL: ID=${billData[billData.length - 1]['billId']}, Ref=${billData[billData.length - 1]['billInvoiceNumber']}',
                  name: 'BillsAPI');
            }
          }

          return BillModel.fromMap(json);
        },
      );

      developer.log(
          'PROCESSED MODEL: count=${result.count}, totalCount=${result.totalCount}, billData.length=${result.billData?.length ?? 0}',
          name: 'BillsAPI');

      return result;
    } catch (e) {
      developer.log('ERROR fetching bill data: $e', name: 'BillsAPI', error: e);

      return BillModel(
        count: 0,
        totalCount: 0,
        billData: [],
      );
    }
  }
}

final getAllBillsData = Provider<GetAllBillRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllBillRepository(apiService);
});

class BillPaginationParams {
  final int pageNo;
  final int rowsPerPage;
  final String? searchQuery;

  BillPaginationParams({
    this.pageNo = 0,
    this.rowsPerPage = 15,
    this.searchQuery,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is BillPaginationParams &&
        other.pageNo == pageNo &&
        other.rowsPerPage == rowsPerPage &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode =>
      pageNo.hashCode ^ rowsPerPage.hashCode ^ (searchQuery?.hashCode ?? 0);
}

final getBillDataWithPagination =
    FutureProvider.family<BillModel, BillPaginationParams>((ref, params) async {
  developer.log(
      'getBillData provider called with page ${params.pageNo}, rows ${params.rowsPerPage}, search: ${params.searchQuery}',
      name: 'BillsProvider');

  final repository = ref.read(getAllBillsData);
  final result = await repository.fetchBillData(
    pageNo: params.pageNo,
    rowsPerPage: params.rowsPerPage,
    searchQuery: params.searchQuery,
  );

  developer.log(
      'Bill data fetched: ${result.billData?.length ?? 0} bills found of ${result.totalCount} total',
      name: 'BillsProvider');
  return result;
});

final getBillData = FutureProvider<BillModel>((ref) async {
  developer.log('getBillData provider called with default pagination',
      name: 'BillsProvider');
  final params = BillPaginationParams();
  return ref.watch(getBillDataWithPagination(params).future);
});

final pendingBillListProvider = Provider<List<BillData>>((ref) {
  final asyncBillModel = ref.watch(getBillData);

  return asyncBillModel.maybeWhen(
    data: (billModel) {
      final pendingBills = billModel.billData
              ?.where(
                  (bill) => bill.billStatus == 1 && bill.isBillVerified == 0)
              .toList() ??
          [];
      developer.log("Pending Bills Count: ${pendingBills.length}",
          name: 'BillsProvider');
      return pendingBills;
    },
    orElse: () => [],
  );
});
