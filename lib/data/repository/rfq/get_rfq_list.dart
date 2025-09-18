import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/rfq_model/get_all_rfq_list.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import '../../../import_data.dart';

class GetAllRfqRepo {
  final BaseApiService _apiService;
  GetAllRfqRepo(this._apiService);

  Future<GetAllRfqList> fetchAllRfqs({required int pageNo, required int rowPerPage}) async {
    try {
      final result = await _apiService.postApi(
        url: "http://158.101.247.195/pb-process-service/rfq/getAllRfqs?pageNo=$pageNo&RowPerPage=$rowPerPage",
        body: {
          "requestCriteria": {
            "rfqId": "",
            "rfqReference": "",
            "rfqIsverified": ""
          },
          "sortingCriteria": {},
          "rowPerPage": rowPerPage,
          "pageNo": pageNo
        },
        fromJson: (json) {
          print(" RFQ list response received");
          return GetAllRfqList.fromJson(json);
        },
      );
      return result;
    } catch (e) {
      print(" Error fetching RFQ list: $e");
      return GetAllRfqList(rfqData: [], count: 0, totalCount: 0);
    }
  }
}
final getAllRfqRepoProvider = Provider<GetAllRfqRepo>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllRfqRepo(apiService);
});

final getAllRfqListProvider = FutureProvider.family<GetAllRfqList, Map<String, int>>((ref, params) async {
  final repo = ref.read(getAllRfqRepoProvider);
  return await repo.fetchAllRfqs(
    pageNo: params['pageNo'] ?? 0,
    rowPerPage: params['rowPerPage'] ?? 15,
  );
});
//how to use
// final rfqAsyncValue = ref.watch(getAllRfqListProvider({
//   'pageNo': 0,
//   'rowPerPage': 15,
// }));
//
// rfqAsyncValue.when(
// data: (rfqList) {
// final items = rfqList.rfqData ?? [];
// return ListView.builder(
// itemCount: items.length,
// itemBuilder: (context, index) {
// final rfq = items[index];
// return ListTile(
// title: Text(rfq.rfqName ?? 'No Name'),
// subtitle: Text('Created by: ${rfq.rfqCreatedByName ?? 'Unknown'}'),
// );
// },
// );
// },
// loading: () => CircularProgressIndicator(),
// error: (err, stack) => Text('Error: $err'),
// );
