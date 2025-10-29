import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/product_page/provider/product_pagination_provider.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage>
    with WidgetsBindingObserver {
  //  Add WidgetsBindingObserver

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    //  Refresh product list when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProductList();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh when app resumes (user comes back from background)
    if (state == AppLifecycleState.resumed) {
      _refreshProductList();
    }
  }

  //  Refresh product list
  void _refreshProductList() {
    final paginationState = ref.read(productPaginationStateProvider);

    if (paginationState.searchQuery.isNotEmpty) {
      // If searching, maintain search
      ref
          .read(productPaginationStateProvider.notifier)
          .setSearchQuery(paginationState.searchQuery);
    } else {
      // Otherwise refresh from page 0
      ref.read(productPaginationStateProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgColor,
        appBar: productAppBar(context: context, ref: ref),
        body: Stack(
          children: [
            Column(
              children: [ProductBodyStatus(), ProductMainBody()],
            ),
            ProductCheckboxPage()
          ],
        ),
        floatingActionButton: ProductFloatingActionButton(),
      ),
    );
  }
}

// import 'package:payzo_books/import_data.dart';
// import 'package:payzo_books/view/product_page/provider/product_pagination_provider.dart';
// import 'dart:developer' as developer;

// class ProductPage extends ConsumerStatefulWidget {
//   const ProductPage({super.key});

//   @override
//   ConsumerState<ProductPage> createState() => _ProductPageState();
// }

// class _ProductPageState extends ConsumerState<ProductPage>
//     with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);

//     // ✅ Always refresh product list when page loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _refreshProductList(forceRefresh: true);
//     });
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     // ✅ Refresh when app resumes from background
//     if (state == AppLifecycleState.resumed) {
//       developer.log('App resumed, refreshing products', name: 'ProductPage');
//       _refreshProductList(forceRefresh: true);
//     }
//   }

//   // ✅ Enhanced refresh method
//   void _refreshProductList({bool forceRefresh = false}) {
//     final paginationState = ref.read(productPaginationStateProvider);

//     if (paginationState.searchQuery.isNotEmpty) {
//       // If searching, refresh search results
//       ref
//           .read(productPaginationStateProvider.notifier)
//           .setSearchQuery(paginationState.searchQuery);
//     } else {
//       // Otherwise refresh normally
//       if (forceRefresh) {
//         ref.read(productPaginationStateProvider.notifier).refresh();
//       } else {
//         ref.read(productPaginationStateProvider.notifier).fetchProducts();
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ScalingFactor(
//       child: Scaffold(
//         backgroundColor: AppColors.scaffoldBgColor,
//         appBar: productAppBar(context: context, ref: ref),
//         body: Stack(
//           children: [
//             Column(
//               children: [ProductBodyStatus(), ProductMainBody()],
//             ),
//             ProductCheckboxPage()
//           ],
//         ),
//         floatingActionButton: ProductFloatingActionButton(),
//       ),
//     );
//   }
// }
