import 'dart:io';

import 'package:payzo_books/data/models/bill_model/bill_edit_details_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';
import 'dart:developer' as developer;

class BillActionsRepository {
  final BaseApiService _apiService;

  BillActionsRepository(this._apiService);

  Future<BillEditDetailsModel?> fetchBillEditDetails(int billId) async {
    try {
      return await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-process-service/bill/getBillEditDetails?billId=$billId",
        fromJson: (json) {
          return BillEditDetailsModel.fromMap(json);
        },
      );
    } catch (e) {
      developer.log("Error fetching bill edit details: $e",
          name: 'BillActionsRepo');
      return null;
    }
  }

  Future<Map<String, dynamic>> updateBill(Map<String, dynamic> billDto,
      {File? file}) async {
    try {
      return await _apiService.putMultipartWithJson(
        url: "http://81.208.173.149/pb-process-service/bill/editBillWf",
        jsonData: billDto,
        jsonFieldName: "billDto",
        file: file,
        fromJson: (json) => json,
      );
    } catch (e) {
      developer.log("Error updating bill: $e", name: 'BillActionsRepo');
      rethrow;
    }
  }

  Future<dynamic> submitRecurringBill(Map<String, dynamic> recBillDto) async {
    try {
      // Request URL - http://81.208.173.149/pb-process-service/bill/getRecBillModal
      // Request Method - POST
      // Payload - Form Data ... recBillDto ...

      // We can use postMultipartWithBlobJson but it expects 'config' and 'mapping'.
      // We need a generic postMultipartWithJson.
      // Since I added putMultipartWithJson, I should probably add postMultipartWithJson too or use a workaround.
      // But wait, BaseApiService has postMultipartWithFileAndJson which uses 'data' field.
      // If the API expects 'recBillDto', I need to specify the field name.
      // I'll assume I can use a new method or modify the existing one.
      // For now, let's use a custom implementation here or add another method to BaseApiService.
      // I'll add postMultipartWithJson to BaseApiService as well to be consistent.

      return await _apiService.postMultipartWithJson(
        url: "http://81.208.173.149/pb-process-service/bill/getRecBillModal",
        jsonData: recBillDto,
        jsonFieldName: "recBillDto",
        fromJson: (json) => json,
      );
    } catch (e) {
      developer.log("Error submitting recurring bill: $e",
          name: 'BillActionsRepo');
      rethrow;
    }
  }

  Future<bool> deleteBill(int billId) async {
    try {
      // Placeholder API
      // Assuming DELETE method or POST to a delete endpoint
      // http://81.208.173.149/pb-process-service/bill/deleteBill?billId=...

      await _apiService.deleteApi(
        url:
            "http://81.208.173.149/pb-process-service/bill/deleteBill?billId=$billId",
        fromJson: (json) => json,
      );
      return true;
    } catch (e) {
      developer.log("Error deleting bill: $e", name: 'BillActionsRepo');
      return false;
    }
  }
}

final billActionsRepositoryProvider = Provider<BillActionsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return BillActionsRepository(apiService);
});
