import 'package:payzo_books/data/models/quotes_model/quotes_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

import '../../../import_data.dart';

class GetAllQuotesRepo {
  final BaseApiService _apiService;
  GetAllQuotesRepo(this._apiService);

  Future<QuotesListModel> fetchQuotes(
      {required int pageNo, required int rowPerPage}) async {
    try {
      return await _apiService.postApi(
        url:
            "http://81.208.173.149/pb-process-service/quotation/getAllQuotation?pageNo=$pageNo&RowPerPage=$rowPerPage",
        body: {
          "requestCriteria": {"quoteId": "", "qteIsVerified": ""},
          "sortingCriteria": {},
          "rowPerPage": rowPerPage,
          "pageNo": pageNo,
        },
        fromJson: (json) {
          print("Quotes response received");
          return QuotesListModel.fromJson(json);
        },
      );
    } catch (e) {
      print("Error in fetching quotes: $e");
      return QuotesListModel(
        fileName: '',
        data: '',
        html: '',
        type: '',
        message: 'Error occurred',
        status: 'false',
      );
    }
  }
}

final getAllQuotesRepoProvider = Provider<GetAllQuotesRepo>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetAllQuotesRepo(apiService);
});

final getQuotesDataProvider =
    FutureProvider.family<QuotesListModel, Map<String, int>>(
        (ref, params) async {
  final repo = ref.read(getAllQuotesRepoProvider);
  return await repo.fetchQuotes(
    pageNo: params['pageNo'] ?? 0,
    rowPerPage: params['rowPerPage'] ?? 15,
  );
});
//use this
//final quotesAsyncValue = ref.watch(getQuotesDataProvider({'pageNo': 0, 'rowPerPage': 15}));
