import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/searchbar/provider/search_bar_provider.dart';
import 'package:payzo_books/view/product_page/provider/product_pagination_provider.dart';

class ProductBodyStatus extends ConsumerStatefulWidget {
  const ProductBodyStatus({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductBodyStatusState();
}

class _ProductBodyStatusState extends ConsumerState<ProductBodyStatus> {
  final TextEditingController productSearchController = TextEditingController();

  void productOnChange(String value) {
    ref.read(searchProvider.notifier).updateSearchQuery(value);

    if (ref.read(productPaginationStateProvider.notifier) != null) {
      ref.read(productPaginationStateProvider.notifier).setSearchQuery(value);
    }
  }

  void productOnClear() {
    productSearchController.clear();
    ref.read(searchProvider.notifier).clearSearch();

    if (ref.read(productPaginationStateProvider.notifier) != null) {
      ref.read(productPaginationStateProvider.notifier).setSearchQuery('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BodyStatus(
      controller: productSearchController,
      onChanged: productOnChange,
      onClear: productOnClear,
      hintText: 'Search by product name',
    );
  }
}
