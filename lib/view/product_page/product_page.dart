// import 'package:payzo_books/import_data.dart';

// class ProductPage extends ConsumerStatefulWidget {
//   const ProductPage({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _ProductPageState();
// }

// class _ProductPageState extends ConsumerState<ProductPage> {
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

import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/product_page/provider/product_pagination_provider.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage>
    with WidgetsBindingObserver {
  // ✅ Add WidgetsBindingObserver

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // ✅ Add observer

    // ✅ Refresh product list when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshProductList();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // ✅ Remove observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // ✅ Refresh when app resumes (user comes back from background)
    if (state == AppLifecycleState.resumed) {
      _refreshProductList();
    }
  }

  // ✅ Refresh product list
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
