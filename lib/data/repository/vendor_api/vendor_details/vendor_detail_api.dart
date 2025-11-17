import 'package:payzo_books/data/models/vendor_model_list/vendor_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetVendorDetailsRepository {
  final BaseApiService _apiService;
  GetVendorDetailsRepository(this._apiService);

  Future<VendorModel> fetchVendorDetailsData(int partyId) async {
    try {
      print('Fetching vendor details for partyId: $partyId');

      final result = await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-process-service/api/process/viewParty?partyId=$partyId",
        fromJson: (json) {
          print('Vendor detail API response received for partyId $partyId');
          return VendorModel.fromMap(json);
        },
      );

      print('Vendor detail result for partyId $partyId:');
      print('- Has error: ${result.error}');
      print('- Response count: ${result.response.response.length}');

      if (result.response.response.isNotEmpty) {
        print(
            '- First vendor name: ${result.response.response.first.companyName}');
      } else {
        print('- No vendor details found in response');
      }

      return result;
    } catch (e) {
      print('Error fetching vendor details for partyId $partyId: $e');

      return VendorModel(
        error: true,
        errorMsg: 'Failed to load vendor details: $e',
        response: ResponseData(response: [], totalRecord: 0),
        status: false,
        transactionId: "",
      );
    }
  }
}

final getVendorsDetailsData = Provider<GetVendorDetailsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetVendorDetailsRepository(apiService);
});

final getVendorDetailsProvider =
    FutureProvider.family<VendorModel, int>((ref, partyId) async {
  print('getVendorDetailsProvider called for partyId: $partyId');
  final repository = ref.read(getVendorsDetailsData);
  final result = await repository.fetchVendorDetailsData(partyId);
  print(
      'Vendor details fetched for partyId $partyId: ${result.response.response.length} vendors found');
  return result;
});
// import 'package:payzo_books/data/models/vendor_model/vendor_model.dart';
// import 'package:payzo_books/data/services/base_api_service.dart';
// import 'package:payzo_books/import_data.dart';
// import 'dart:math' show min;

// class GetVendorDetailsRepository {
//   final BaseApiService _apiService;
//   GetVendorDetailsRepository(this._apiService);

//   Future<VendorModel> fetchVendorDetailsData(int partyId,
//       {int retryCount = 2}) async {
//     for (int attempt = 0; attempt < retryCount; attempt++) {
//       try {
//         print(
//             'Fetching vendor details for partyId: $partyId (attempt ${attempt + 1})');

//         final result = await _apiService.getApi(
//           url:
//               "http://81.208.173.149/pb-process-service/api/process/viewParty?partyId=$partyId",
//           fromJson: (json) {
//             print('Vendor detail API response received for partyId $partyId');
//             print('Response structure: ${json.keys.join(", ")}');

//             if (json.containsKey("response")) {
//               final responsePreview = json["response"].toString();
//               print(
//                   'Response preview: ${responsePreview.substring(0, min(200, responsePreview.length))}...');
//             } else {
//               print('WARNING: Response does not contain "response" key');
//             }

//             return VendorModel.fromMap(json);
//           },
//         );

//         print('Vendor detail result for partyId $partyId:');
//         print('- Has error: ${result.error}');
//         print('- Error message: ${result.errorMsg ?? "None"}');
//         print('- Response count: ${result.response.response.length}');

//         if (result.response.response.isNotEmpty) {
//           print(
//               '- First vendor name: ${result.response.response.first.companyName}');
//           return result;
//         } else {
//           print(
//               '- No vendor details found in response - attempt ${attempt + 1}');
//           if (attempt == retryCount - 1) {
//             return result;
//           }
//           await Future.delayed(Duration(milliseconds: 800));
//         }
//       } catch (e) {
//         print('Error fetching vendor details for partyId $partyId: $e');

//         if (attempt == retryCount - 1) {
//           return VendorModel(
//             error: true,
//             errorMsg:
//                 'Failed to load vendor details after ${attempt + 1} attempts: $e',
//             response: ResponseData(response: [], totalRecord: 0),
//             status: false,
//             transactionId: "",
//           );
//         }

//         await Future.delayed(Duration(milliseconds: 800));
//       }
//     }
//     return VendorModel(
//       error: true,
//       errorMsg: 'Failed to load vendor details: unknown error',
//       response: ResponseData(response: [], totalRecord: 0),
//       status: false,
//       transactionId: "",
//     );
//   }
// }

// final getVendorsDetailsData = Provider<GetVendorDetailsRepository>((ref) {
//   final apiService = ref.read(apiServiceProvider);
//   return GetVendorDetailsRepository(apiService);
// });

// final getVendorDetailsProvider =
//     FutureProvider.family<VendorModel, int>((ref, partyId) async {
//   print('getVendorDetailsProvider called for partyId: $partyId');
//   final repository = ref.read(getVendorsDetailsData);
//   final result = await repository.fetchVendorDetailsData(partyId);
//   print(
//       'Vendor details fetched for partyId $partyId: ${result.response.response.length} vendors found');
//   return result;
// });
