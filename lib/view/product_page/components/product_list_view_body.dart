import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/product_page/components/product_item_widget.dart';
import 'package:payzo_books/view/product_page/provider/product_pagination_provider.dart';
import 'package:payzo_books/view/product_page/provider/product_selection.dart';

class ProductListViewBody extends ConsumerStatefulWidget {
  final ProductPaginationState paginationState;
  final ProductSelectionState selectionState;
  final ProductSelectionNotifier selectionNotifier;
  final ScrollController scrollController;
  const ProductListViewBody(
      {super.key,
      required this.paginationState,
      required this.selectionState,
      required this.selectionNotifier,
      required this.scrollController});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductListViewBodyState();
}

class _ProductListViewBodyState extends ConsumerState<ProductListViewBody> {
  @override
  Widget build(BuildContext context) {
    final products = widget.paginationState.filteredProducts;

    if (widget.paginationState.searchQuery.isNotEmpty && products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              "No products match your search",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Try a different search term",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: ListView.builder(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: products.length +
            (widget.paginationState.hasNextPage &&
                    widget.paginationState.searchQuery.isEmpty
                ? 1
                : 0),
        itemBuilder: (context, index) {
          if (index == products.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  color: AppColors.appMainColor,
                ),
              ),
            );
          }

          return productItemWidget(
              product: products[index],
              index: index,
              selectionState: widget.selectionState,
              selectionNotifier: widget.selectionNotifier,
              ref: ref);
        },
      ),
    );
  }
}
