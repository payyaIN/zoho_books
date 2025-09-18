import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/add_product/get_asset_details_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';


class GetAssetDetailsRepo {
  final BaseApiService apiService;
  GetAssetDetailsRepo(this.apiService);

  Future<GetAssetDetailsModel> fetchChartOfAccounts() {
    return apiService.getApi(
      url: 'http://158.101.247.195/pb-item-service/v1/items/fetchAssetCategoryTypes',
      fromJson: (json) => GetAssetDetailsModel.fromJson(json),
    );
  }
}

final getAssetDetailsProvider = Provider<GetAssetDetailsRepo>((ref) {
  return GetAssetDetailsRepo(ref.read(apiServiceProvider));
});

final fetchAssertDetailsProvider = FutureProvider<GetAssetDetailsModel>((ref) {
  return ref.read(getAssetDetailsProvider).fetchChartOfAccounts();
});
