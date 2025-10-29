import 'package:payzo_books/data/repository/products_api/product_list_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/product_page/components/product_empty_view.dart';
import 'package:payzo_books/view/product_page/components/product_error_view.dart';
import 'package:payzo_books/view/product_page/components/product_list_view_body.dart';
import 'package:payzo_books/view/product_page/provider/product_pagination_provider.dart';
import 'package:payzo_books/view/product_page/provider/product_selection.dart';

class ProductMainBody extends ConsumerStatefulWidget {
  const ProductMainBody({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProductMainBodyState();
}

class _ProductMainBodyState extends ConsumerState<ProductMainBody> {
  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(productPaginationStateProvider);

    final paginationNotifier =
        ref.read(productPaginationStateProvider.notifier);
    final productSelectionState = ref.watch(productSelectionProvider);
    final productSelectionNotifier =
        ref.read(productSelectionProvider.notifier);

    ref.listen<ProductPaginationState>(productPaginationStateProvider,
        (previous, current) {
      if (previous?.products.length != current.products.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (current.products.isNotEmpty) {
            productSelectionNotifier
                .updateSelectionSize(current.products.length);
          }
        });
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.removeListener(() {});
        scrollController.addListener(() {
          if (scrollController.position.pixels >=
                  scrollController.position.maxScrollExtent * 0.8 &&
              !paginationState.isLoading &&
              paginationState.hasNextPage &&
              paginationState.searchQuery.isEmpty) {
            paginationNotifier.loadMoreProducts();
          }
        });
      }
    });
    // return Expanded(
    //   child: RefreshIndicator(
    //     onRefresh: () async {
    //       paginationNotifier.refresh();
    //     },
    //     child:
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          // ✅ Clear cache before refreshing
          ref.invalidate(getProductDataWithPagination);

          final paginationState = ref.read(productPaginationStateProvider);

          if (paginationState.searchQuery.isNotEmpty) {
            await ref
                .read(productPaginationStateProvider.notifier)
                .setSearchQuery(paginationState.searchQuery);
          } else {
            await ref.read(productPaginationStateProvider.notifier).refresh();
          }
        },
        child: paginationState.isLoading && paginationState.products.isEmpty
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.appMainColor,
                ),
              )
            : paginationState.errorMessage != null &&
                    paginationState.products.isEmpty
                ? productErrorView(
                    paginationState.errorMessage!, paginationNotifier)
                : paginationState.products.isEmpty
                    ? productEmptyView()
                    : ProductListViewBody(
                        paginationState: paginationState,
                        selectionState: productSelectionState,
                        selectionNotifier: productSelectionNotifier,
                        scrollController: scrollController,
                      ),
      ),
    );
  }
}

// import 'dart:developer' as developer;
// import 'package:payzo_books/data/repository/products_api/product_list_api.dart';
// import 'package:payzo_books/import_data.dart';
// import 'package:payzo_books/view/product_page/components/product_empty_view.dart';
// import 'package:payzo_books/view/product_page/components/product_error_view.dart';
// import 'package:payzo_books/view/product_page/components/product_list_view_body.dart';
// import 'package:payzo_books/view/product_page/provider/product_pagination_provider.dart';
// import 'package:payzo_books/view/product_page/provider/product_selection.dart';

// class ProductMainBody extends ConsumerStatefulWidget {
//   const ProductMainBody({super.key});

//   @override
//   ConsumerState<ProductMainBody> createState() => _ProductMainBodyState();
// }

// class _ProductMainBodyState extends ConsumerState<ProductMainBody> {
//   final ScrollController scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     // Setup scroll listener for pagination
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       scrollController.addListener(() {
//         if (scrollController.position.pixels >=
//                 scrollController.position.maxScrollExtent - 200 &&
//             !scrollController.position.outOfRange) {
//           final paginationState = ref.read(productPaginationStateProvider);
//           final paginationNotifier =
//               ref.read(productPaginationStateProvider.notifier);

//           // Load more if has next page and not loading
//           if (paginationState.hasNextPage && !paginationState.isLoading) {
//             developer.log('Triggering load more products',
//                 name: 'ProductMainBody');
//             paginationNotifier.loadMoreProducts();
//           }
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final paginationState = ref.watch(productPaginationStateProvider);
//     final paginationNotifier =
//         ref.read(productPaginationStateProvider.notifier);
//     final productSelectionState = ref.watch(productSelectionProvider);
//     final productSelectionNotifier =
//         ref.read(productSelectionProvider.notifier);

//     return Expanded(
//       child: RefreshIndicator(
//         onRefresh: () async {
//           developer.log('Pull to refresh triggered', name: 'ProductMainBody');

//           // ✅ FIX: Don't invalidate here, let the refresh method handle it
//           await ref.read(productPaginationStateProvider.notifier).refresh();

//           developer.log('Pull to refresh completed', name: 'ProductMainBody');
//         },
//         child: paginationState.isLoading && paginationState.products.isEmpty
//             ? const Center(
//                 child: CircularProgressIndicator(
//                   color: AppColors.appMainColor,
//                 ),
//               )
//             : paginationState.errorMessage != null &&
//                     paginationState.products.isEmpty
//                 ? productErrorView(
//                     paginationState.errorMessage!, paginationNotifier)
//                 : paginationState.products.isEmpty
//                     ? productEmptyView()
//                     : ProductListViewBody(
//                         paginationState: paginationState,
//                         selectionState: productSelectionState,
//                         selectionNotifier: productSelectionNotifier,
//                         scrollController: scrollController,
//                       ),
//       ),
//     );
//   }
// }
