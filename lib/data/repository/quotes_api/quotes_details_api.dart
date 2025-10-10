import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/models/quotes_model/quotes_details_model.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/import_data.dart';

class GetQuoteDetailsRepository {
  final BaseApiService _apiService;
  GetQuoteDetailsRepository(this._apiService);

  Future<QuotesDetailsModel> fetchQuoteDetailsData(int quoteId) async {
    try {
      print('Fetching quote details for quoteId: $quoteId');

      final result = await _apiService.getApi(
        url:
            "http://81.208.173.149/pb-process-service/quotation/getQuotationByQuoteId?quoteId=$quoteId",
        fromJson: (json) {
          print('Quote detail API response received for quoteId $quoteId');
          return QuotesDetailsModel.fromJson(json);
        },
      );

      print('Quote detail result for quoteId $quoteId:');
      print('- Quote ID: ${result.quoteId}');
      print('- Quote Name: ${result.quoteName}');
      print('- Quote Total: ${result.quoteProductTotal}');

      return result;
    } catch (e) {
      print('Error fetching quote details for quoteId $quoteId: $e');

      return QuotesDetailsModel();
    }
  }
}

final getQuoteDetailsData = Provider<GetQuoteDetailsRepository>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return GetQuoteDetailsRepository(apiService);
});

final getQuoteDetailsProvider =
    FutureProvider.family<QuotesDetailsModel, int>((ref, quoteId) async {
  print('getQuoteDetailsProvider called for quoteId: $quoteId');
  final repository = ref.read(getQuoteDetailsData);
  final result = await repository.fetchQuoteDetailsData(quoteId);
  print('Quote details fetched for quoteId $quoteId');
  return result;
});
//how to use:
// class QuoteDetailsScreen extends ConsumerWidget {
//   final int quoteId;
//
//   const QuoteDetailsScreen({super.key, required this.quoteId});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final quoteDetailsAsync = ref.watch(getQuoteDetailsProvider(quoteId));
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Quote Details')),
//       body: quoteDetailsAsync.when(
//         data: (quote) {
//           return ListView(
//             padding: const EdgeInsets.all(16),
//             children: [
//               Text('Quote Name: ${quote.quoteName ?? "-"}'),
//               Text('Quote ID: ${quote.quoteId}'),
//               Text('Posted By: ${quote.quotePostedBy ?? "-"}'),
//               Text('Currency: ${quote.quoteCurrency ?? "-"}'),
//               const SizedBox(height: 20),
//               Text('Product Details:', style: TextStyle(fontWeight: FontWeight.bold)),
//               ...quote.productDetails?.map((prod) => ListTile(
//                 title: Text(prod.productName ?? 'No Name'),
//                 subtitle: Text('Qty: ${prod.quantity}, Total: ${prod.productTotal}'),
//               )) ??
//                   [Text('No product details')],
//             ],
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, stack) => Center(child: Text('Error: $e')),
//       ),
//     );
//   }
// }
