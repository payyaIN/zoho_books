import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/purchase_order/download_order_details_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import '../../../import_data.dart';

class DownloadOrderRepository {
  final BaseApiService _apiService;
  DownloadOrderRepository(this._apiService);

  Future<OrderDownloadModel> downloadOrderPdf(int poId) async {
    try {
      print('Fetching order PDF for poId: $poId');

      final result = await _apiService.getApi(
        url:
        "http://158.101.247.195/pb-process-service/order/downloadPoPdf?poId=$poId",
        fromJson: (json) {
          print('Order PDF API response received for poId $poId');
          return OrderDownloadModel.fromJson(json);
        },
      );

      print('Order PDF result for poId $poId:');
      print('- File Name: ${result.fileName}');
      print('- Status: ${result.status}');
      print('- Type: ${result.type}');
      print('- Data: ${result.data?.substring(0, 50)}...');

      return result;
    } catch (e) {
      print('Error downloading order PDF for poId $poId: $e');
      return OrderDownloadModel.empty(); // Ensure your model has an empty() method
    }
  }
}
final downloadOrderRepositoryProvider = Provider<DownloadOrderRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return DownloadOrderRepository(apiService);
});

final downloadOrderPdfProvider = FutureProvider.family<OrderDownloadModel, int>((ref, poId) async {
  print('downloadOrderPdfProvider called for poId: $poId');
  final repository = ref.read(downloadOrderRepositoryProvider);
  final result = await repository.downloadOrderPdf(poId);
  print('Order PDF fetched for poId $poId');
  return result;
});
//how to use:
// class OrderPdfScreen extends ConsumerWidget {
//   final int poId;
//
//   const OrderPdfScreen({super.key, required this.poId});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final orderPdfAsync = ref.watch(downloadOrderPdfProvider(poId));
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Order PDF')),
//       body: orderPdfAsync.when(
//         data: (orderPdf) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('File Name: ${orderPdf.fileName ?? "-"}'),
//                 Text('Status: ${orderPdf.status ?? "-"}'),
//                 Text('Type: ${orderPdf.type ?? "-"}'),
//                 ElevatedButton(
//                   onPressed: () {
//                     // TODO: decode base64 and download file or open viewer
//                   },
//                   child: Text('Download PDF'),
//                 ),
//               ],
//             ),
//           );
//         },
//         loading: () => Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text('Error: $e')),
//       ),
//     );
//   }
// }
