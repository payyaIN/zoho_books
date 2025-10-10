import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/document_type_model/document_type_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';

class GetDocumentTypesRepository {
  final BaseApiService _apiService;
  GetDocumentTypesRepository(this._apiService);

  Future<List<DocumentTypeModel>> fetchDocumentTypes() async {
    try {
      return await _apiService.getListApi(
        url:
            'http://81.208.173.149/pb-common-service/api/company/getDocumenyTypes',
        fromJson: (json) => DocumentTypeModel.fromJson(json),
      );
    } catch (e) {
      print('Error fetching document types: $e');
      return [];
    }
  }
}

final getDocumentTypesRepositoryProvider =
    Provider<GetDocumentTypesRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetDocumentTypesRepository(apiService);
});

final documentTypesProvider =
    FutureProvider<List<DocumentTypeModel>>((ref) async {
  final repository = ref.read(getDocumentTypesRepositoryProvider);
  return repository.fetchDocumentTypes();
});
