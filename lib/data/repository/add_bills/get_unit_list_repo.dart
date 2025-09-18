import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/repository/add_bills/get_unit_list_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class UnitRepository {
  final BaseApiService apiService;
  UnitRepository(this.apiService);

  Future<List<Unit>> fetchUnits() {
    const url = 'http://158.101.247.195/pb-process-service/rfq/getUnitList';
    return apiService.getListApi(
      url: url,
      fromJson: (json) => Unit.fromJson(json),
    );
  }
}

final unitRepoProvider = Provider<UnitRepository>((ref) {
  final api = ref.read(apiServiceProvider);
  return UnitRepository(api);
});

final fetchUnitListProvider = FutureProvider<List<Unit>>((ref) {
  return ref.read(unitRepoProvider).fetchUnits();
});
