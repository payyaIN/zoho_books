import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/rfq_model/get_rfq_details.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetRfqDetailsRepository {
  final BaseApiService _apiService;
  GetRfqDetailsRepository(this._apiService);

  Future<RfqDetails> fetchRfqDetails(int rfqId) async {
    try {
      print('Fetching RFQ details for rfqId: $rfqId');

      final result = await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-process-service/rfq/getRfqByRfqId?rfqId=$rfqId",
        fromJson: (json) {
          print('RFQ API response received for rfqId: $rfqId');
          return GetRfqDetails.fromJson(json).rfqDetails!;
        },
      );

      print('RFQ Name: ${result.rfqName}');
      print('Total Amount: ${result.rfqTotalAmt}');
      return result;
    } catch (e) {
      print('Error fetching RFQ details for rfqId $rfqId: $e');
      return RfqDetails();
    }
  }
}

final getRfqDetailsData = Provider<GetRfqDetailsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetRfqDetailsRepository(apiService);
});

final getRfqDetailsProvider =
    FutureProvider.family<RfqDetails, int>((ref, rfqId) async {
  print('getRfqDetailsProvider called for rfqId: $rfqId');
  final repository = ref.read(getRfqDetailsData);
  final result = await repository.fetchRfqDetails(rfqId);
  print('RFQ details fetched for rfqId $rfqId');
  return result;
});

//how to use?
// class RfqDetailsScreen extends ConsumerWidget {
//   final int rfqId;
//   const RfqDetailsScreen({super.key, required this.rfqId});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final rfqAsyncValue = ref.watch(getRfqDetailsProvider(rfqId));
//
//     return Scaffold(
//       appBar: AppBar(title: Text('RFQ Details')),
//       body: rfqAsyncValue.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (err, stack) => Center(child: Text('Error: $err')),
//         data: (rfq) => Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text("RFQ Name: ${rfq.rfqName ?? 'N/A'}", style: const TextStyle(fontSize: 18)),
//               const SizedBox(height: 8),
//               Text("Total Amount: ${rfq.rfqTotalAmt?.toStringAsFixed(2) ?? '0.00'} CHF"),
//               const SizedBox(height: 8),
//               Text("Created By: ${rfq.rfqCreatedBy ?? 'Unknown'}"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
