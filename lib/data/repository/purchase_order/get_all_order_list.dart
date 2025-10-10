import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/purchase_order/get_all_orders_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

import '../../../import_data.dart';

class GetAllOrdersRepo {
  final BaseApiService _apiService;
  GetAllOrdersRepo(this._apiService);

  Future<GetAllOrdersListModel> fetchOrders({
    required int pageNo,
    required int rowPerPage,
  }) async {
    try {
      final result = await _apiService.postApi(
        url: "http://81.208.173.149/pb-process-service/order/getAllOrders?pageNo=$pageNo&RowPerPage=$rowPerPage",
        body: {
          "requestCriteria": {},
          "sortingCriteria": {},
          "rowPerPage": rowPerPage,
          "pageNo": pageNo,
        },
        fromJson: (json) {
          print(" Orders response received");
          return GetAllOrdersListModel.fromJson(json);
        },
      );
      return result;
    } catch (e) {
      print(" Error fetching orders: $e");
      return GetAllOrdersListModel(
        count: 0,
        orderData: [],
        totalCount: 0,
      );
    }
  }
}

final getAllOrdersRepoProvider = Provider<GetAllOrdersRepo>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllOrdersRepo(apiService);
});

final getOrdersDataProvider = FutureProvider.family<GetAllOrdersListModel, Map<String, int>>((ref, params) async {
  final repo = ref.read(getAllOrdersRepoProvider);
  return await repo.fetchOrders(
    pageNo: params['pageNo'] ?? 0,
    rowPerPage: params['rowPerPage'] ?? 15,
  );
});

// USAGE:
// final ordersAsyncValue = ref.watch(getOrdersDataProvider({'pageNo': 0, 'rowPerPage': 15}));
