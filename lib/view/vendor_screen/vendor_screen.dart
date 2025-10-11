import 'package:payzo_books/data/repository/vendor_api/vendor_listing/vendor_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/vendor_screen/components/vendor_app_bar.dart';
import 'package:payzo_books/view/vendor_screen/components/vendor_body_widget.dart';
import 'package:payzo_books/view/vendor_screen/components/vendor_fab.dart';
import 'package:payzo_books/view/vendor_screen/components/vendor_search_ui.dart';
import 'package:payzo_books/view/vendor_screen/provider/vendor_pagination_provider.dart';

class VendorScreen extends ConsumerStatefulWidget {
  const VendorScreen({super.key});

  @override
  ConsumerState<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends ConsumerState<VendorScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshVendorList();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshVendorList();
    }
  }

  void _refreshVendorList() {
    final paginationState = ref.read(vendorPaginationStateProvider);

    if (paginationState.searchQuery.isNotEmpty) {
      ref
          .read(vendorPaginationStateProvider.notifier)
          .setSearchQuery(paginationState.searchQuery);
    } else {
      ref.read(vendorPaginationStateProvider.notifier).refresh();
    }
  }

  // Future<void> _refresh() async {
  //   final paginationState = ref.read(vendorPaginationStateProvider);

  //   if (paginationState.searchQuery.isNotEmpty) {
  //     await ref
  //         .read(vendorPaginationStateProvider.notifier)
  //         .setSearchQuery(paginationState.searchQuery);
  //   } else {
  //     await ref.read(vendorPaginationStateProvider.notifier).refresh();
  //   }
  // }
  Future<void> _refresh() async {
    // ✅ Clear cache before refreshing
    ref.invalidate(getVendorDataWithPagination);

    final paginationState = ref.read(vendorPaginationStateProvider);

    if (paginationState.searchQuery.isNotEmpty) {
      await ref
          .read(vendorPaginationStateProvider.notifier)
          .setSearchQuery(paginationState.searchQuery);
    } else {
      await ref.read(vendorPaginationStateProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Scaffold(
          appBar: vendorAppBar(context: context),
          body: RefreshIndicator(
            onRefresh: _refresh,
            child: Column(
              children: [
                VendorSearchUi(),
                VendorBodyWidget(
                  scrollController: _scrollController,
                )
              ],
            ),
          ),
          floatingActionButton: vendorFabBtn(context: context)),
    );
  }
}
