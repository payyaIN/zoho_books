import 'package:payzo_books/data/models/invoice_model/invoice_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';
import 'dart:developer' as developer;

// class GetAllInvoiceRepository {
//   final BaseApiService _apiService;

//   GetAllInvoiceRepository(this._apiService);

//   Future<InvoiceModel> fetchInvoiceData({
//     int pageNo = 0,
//     int rowsPerPage = 15,
//     String? searchQuery,
//   }) async {
//     try {
//       print(
//           'Fetching invoice list data (page: $pageNo, rows: $rowsPerPage, search: $searchQuery)...');

//       final Map<String, dynamic> requestBody;

//       if (searchQuery != null && searchQuery.isNotEmpty) {
//         requestBody = {
//           "requestCriteria": {
//             "invoiceId": "",
//             "invoiceCustomerId": "",
//             "invoiceStatus": "",
//             "invoiceRecurringId": "",
//             "invoiceIsVerified": "",
//             "invoiceNumber": searchQuery,
//             "invoiceCreatedBy": null,
//             "invoiceDateFrom": null,
//             "invoiceDateTo": null,
//             "invoiceAmountMin": 0,
//             "invoiceAmountMax": null,
//             "invoicAgreementFeeId": ""
//           },
//           "sortingCriteria": {"field": "invoiceCreatedDate", "order": "-1"},
//           "rowPerPage": rowsPerPage,
//           "pageNo": pageNo
//         };
//         print('Searching invoices by Number: "$searchQuery"');
//       } else {
//         requestBody = {
//           "requestCriteria": {
//             "invoiceId": "",
//             "invoiceNumber": "",
//             "invoiceStatus": "",
//             "invoiceRecurringId": ""
//           },
//           "sortingCriteria": {"field": "invoiceCreatedDate", "order": "-1"},
//           "rowPerPage": rowsPerPage,
//           "pageNo": pageNo
//         };
//       }

//       return await _apiService.postApi(
//         url: "http://158.101.247.195/pb-process-service/invoice/getAllInvoice",
//         body: requestBody,
//         fromJson: (json) {
//           print('Invoice list API response received');
//           return InvoiceModel.fromMap(json);
//         },
//       );
//     } catch (e) {
//       print('Error fetching invoice data: $e');
//       return InvoiceModel(
//         count: 0,
//         totalCount: 0,
//         invoiceData: [],
//       );
//     }
//   }
// }

// final getAllInvoicesData = Provider<GetAllInvoiceRepository>((ref) {
//   final apiService = ref.read(apiServiceProvider);
//   return GetAllInvoiceRepository(apiService);
// });

// class InvoicePaginationParams {
//   final int pageNo;
//   final int rowsPerPage;
//   final String? searchQuery;

//   InvoicePaginationParams({
//     this.pageNo = 0,
//     this.rowsPerPage = 15,
//     this.searchQuery,
//   });

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;
//     if (other.runtimeType != runtimeType) return false;
//     return other is InvoicePaginationParams &&
//         other.pageNo == pageNo &&
//         other.rowsPerPage == rowsPerPage &&
//         other.searchQuery == searchQuery;
//   }

//   @override
//   int get hashCode =>
//       pageNo.hashCode ^ rowsPerPage.hashCode ^ (searchQuery?.hashCode ?? 0);
// }

// final getInvoiceDataWithPagination =
//     FutureProvider.family<InvoiceModel, InvoicePaginationParams>(
//         (ref, params) async {
//   print(
//       'getInvoiceData provider called with page ${params.pageNo}, rows ${params.rowsPerPage}, search: ${params.searchQuery}');
//   final repository = ref.read(getAllInvoicesData);
//   final result = await repository.fetchInvoiceData(
//     pageNo: params.pageNo,
//     rowsPerPage: params.rowsPerPage,
//     searchQuery: params.searchQuery,
//   );
//   print(
//       'Invoice data fetched: ${result.invoiceData?.length ?? 0} invoices found of ${result.totalCount} total');
//   return result;
// });

// final getInvoiceData = FutureProvider<InvoiceModel>((ref) async {
//   print('getInvoiceData provider called with default pagination');
//   final params = InvoicePaginationParams();
//   return ref.watch(getInvoiceDataWithPagination(params).future);
// });

// final getInvoiceDataOfAll = FutureProvider<InvoiceModel>((ref) async {
//   final repository = ref.read(getAllInvoicesData);
//   final result =
//       await repository.fetchInvoiceData(pageNo: 0, rowsPerPage: 1000);
//   return result;
// });

// final pendingInvoicesProvider = Provider<List<InvoiceData>>((ref) {
//   final response = ref.watch(getInvoiceDataOfAll).asData?.value;

//   if (response == null || response.invoiceData == null) {
//     print('No invoice data found');
//     return [];
//   }

//   final pending = response.invoiceData!.where((invoice) {
//     print(
//         '🔍 Invoice: ${invoice.invoiceNumber}, Status: ${invoice.invoiceStatus}, Verified: ${invoice.isInvoiceverified}');
//     return invoice.invoiceStatus == 1 && invoice.isInvoiceverified == 0;
//   }).toList();

//   print('Pending Invoices Count: ${pending.length}');
//   return pending;
// });

class GetAllInvoiceRepository {
  final BaseApiService _apiService;
  GetAllInvoiceRepository(this._apiService);

  Future<InvoiceModel> fetchInvoiceData({
    int pageNo = 0,
    int rowsPerPage = 15,
    String? searchQuery,
  }) async {
    try {
      developer.log(
          'INVOICE API REQUEST: PageNo=$pageNo, RowsPerPage=$rowsPerPage, Query=$searchQuery',
          name: 'InvoiceAPI');

      final Map<String, dynamic> requestBody;

      if (searchQuery != null && searchQuery.isNotEmpty) {
        requestBody = {
          "requestCriteria": {
            "invoiceId": "",
            "invoiceCustomerId": "",
            "invoiceStatus": "",
            "invoiceRecurringId": "",
            "invoiceIsVerified": "",
            "invoiceNumber": searchQuery,
            "invoiceCreatedBy": "",
            "invoiceDateFrom": "",
            "invoiceDateTo": "",
            "invoiceAmountMin": "",
            "invoiceAmountMax": "",
            "invoicAgreementFeeId": ""
          },
          "sortingCriteria": {"field": "invoiceCreatedDate", "order": "-1"},
          "rowPerPage": rowsPerPage,
          "pageNo": pageNo
        };
        developer.log('Searching invoices by Invoice Number: "$searchQuery"',
            name: 'InvoiceAPI');
      } else {
        requestBody = {
          "requestCriteria": {
            "invoiceId": "",
            "invoiceCustomerId": "",
            "invoiceStatus": "",
            "invoiceRecurringId": "",
            "invoiceIsVerified": "",
            "invoiceNumber": "",
            "invoiceCreatedBy": "",
            "invoiceDateFrom": "",
            "invoiceDateTo": "",
            "invoiceAmountMin": "",
            "invoiceAmountMax": "",
            "invoicAgreementFeeId": ""
          },
          "sortingCriteria": {"field": "invoiceCreatedDate", "order": "-1"},
          "rowPerPage": rowsPerPage,
          "pageNo": pageNo
        };
      }

      developer.log('INVOICE API REQUEST BODY: ${requestBody.toString()}',
          name: 'InvoiceAPI');

      return await _apiService.postApi(
        url: "http://158.101.247.195/pb-process-service/invoice/getAllInvoice",
        body: requestBody,
        fromJson: (json) {
          developer.log('INVOICE API RESPONSE RECEIVED', name: 'InvoiceAPI');
          return InvoiceModel.fromMap(json);
        },
      );
    } catch (e) {
      developer.log('ERROR fetching invoice data: $e',
          name: 'InvoiceAPI', error: e);
      return InvoiceModel(
        count: 0,
        totalCount: 0,
        invoiceData: [],
      );
    }
  }
}

final getAllInvoiceData = Provider<GetAllInvoiceRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllInvoiceRepository(apiService);
});

// final getAllInvoicesData = Provider<GetAllInvoiceRepository>((ref) {
//   final apiService = ref.read(apiServiceProvider);
//   return GetAllInvoiceRepository(apiService);
// });

class InvoicePaginationParams {
  final int pageNo;
  final int rowsPerPage;
  final String? searchQuery;

  InvoicePaginationParams({
    this.pageNo = 0,
    this.rowsPerPage = 15,
    this.searchQuery,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is InvoicePaginationParams &&
        other.pageNo == pageNo &&
        other.rowsPerPage == rowsPerPage &&
        other.searchQuery == searchQuery;
  }

  @override
  int get hashCode =>
      pageNo.hashCode ^ rowsPerPage.hashCode ^ (searchQuery?.hashCode ?? 0);
}

final getInvoiceDataWithPagination =
    FutureProvider.family<InvoiceModel, InvoicePaginationParams>(
        (ref, params) async {
  developer.log(
      'getInvoiceData provider called with page ${params.pageNo}, rows ${params.rowsPerPage}, search: ${params.searchQuery}',
      name: 'InvoiceProvider');

  final repository = ref.read(getAllInvoiceData);

  final result = await repository.fetchInvoiceData(
    pageNo: params.pageNo,
    rowsPerPage: params.rowsPerPage,
    searchQuery: params.searchQuery,
  );

  developer.log(
      'Invoice data fetched: ${result.invoiceData?.length ?? 0} invoices found of ${result.totalCount} total',
      name: 'InvoiceProvider');
  return result;
});

final getInvoiceData = FutureProvider<InvoiceModel>((ref) async {
  developer.log('getInvoiceData provider called with default pagination',
      name: 'InvoiceProvider');
  final params = InvoicePaginationParams();
  return ref.watch(getInvoiceDataWithPagination(params).future);
});

final getInvoiceDataOfAll = FutureProvider<InvoiceModel>((ref) async {
  final repository = ref.read(getAllInvoiceData);
  final result =
      await repository.fetchInvoiceData(pageNo: 0, rowsPerPage: 1000);
  return result;
});

final pendingInvoicesProvider = Provider<List<InvoiceData>>((ref) {
  final response = ref.watch(getInvoiceDataOfAll).asData?.value;

  if (response == null || response.invoiceData == null) {
    print('No invoice data found');
    return [];
  }

  final pending = response.invoiceData!.where((invoice) {
    print(
        '🔍 Invoice: ${invoice.invoiceNumber}, Status: ${invoice.invoiceStatus}, Verified: ${invoice.isInvoiceverified}');
    return invoice.invoiceStatus == 1 && invoice.isInvoiceverified == 0;
  }).toList();

  print('Pending Invoices Count: ${pending.length}');
  return pending;
});
