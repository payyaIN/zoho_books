import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/purchase_order/get_order_details_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetOrderDetailsRepository {
  final BaseApiService _apiService;
  GetOrderDetailsRepository(this._apiService);

  Future<GetOrderDetailsModel> fetchOrderDetailsData(int orderId) async {
    try {
      print('Fetching order details for orderId: $orderId');

      final result = await _apiService.getApi(
        url:
        "http://81.208.173.149/pb-process-service/order/getOrderByOrderId?orderId=$orderId",
        fromJson: (json) {
          print('Order detail API response received for orderId $orderId');
          return GetOrderDetailsModel.fromJson(json);
        },
      );

      print('Order detail result for orderId $orderId:');
      print('- Order ID: ${result.poId}');
      print('- Order Name: ${result.poName}');
      print('- Order Total: ${result.poProductTotal}');

      return result;
    } catch (e) {
      print('Error fetching order details for orderId $orderId: $e');
      return GetOrderDetailsModel();
    }
  }
}

final getOrderDetailsData = Provider<GetOrderDetailsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetOrderDetailsRepository(apiService);
});

final getOrderDetailsProvider =
FutureProvider.family<GetOrderDetailsModel, int>((ref, orderId) async {
  print('getOrderDetailsProvider called for orderId: $orderId');
  final repository = ref.read(getOrderDetailsData);
  final result = await repository.fetchOrderDetailsData(orderId);
  print('Order details fetched for orderId $orderId');
  return result;
});
//how to use

// class OrderDetailsScreen extends ConsumerWidget {
//   final int orderId;
//   const OrderDetailsScreen({super.key, required this.orderId});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final orderAsyncValue = ref.watch(getOrderDetailsProvider(orderId));
//
//     return Scaffold(
//       appBar: AppBar(title: const Text("Order Details")),
//       body: orderAsyncValue.when(
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, stack) => Center(child: Text('Error: $e')),
//         data: (order) => ListView(
//           padding: const EdgeInsets.all(16),
//           children: [
//             Text('Order Name: ${order.poName ?? "-"}'),
//             Text('Order ID: ${order.poId ?? "-"}'),
//             Text('Currency: ${order.poCurrency ?? "-"}'),
//             Text('Posted By: ${order.poPostedBy ?? "-"}'),
//             Text('Order Date: ${order.poOrderDate ?? "-"}'),
//             const SizedBox(height: 20),
//             Text('Product Details:', style: const TextStyle(fontWeight: FontWeight.bold)),
//             ...(order.productDetails?.map((product) => ListTile(
//               title: Text(product.productName ?? "No Name"),
//               subtitle: Text('Qty: ${product.quantity}, Total: ${product.productTotal}'),
//             )) ??
//                 [const Text("No Product Details")]),
//           ],
//         ),
//       ),
//     );
//   }
// }
