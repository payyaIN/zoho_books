import 'package:payzo_books/data/models/customer_model/customer_model.dart';
import 'package:payzo_books/data/repository/customer_list_page/customer_listing_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/searchbar/provider/search_bar_provider.dart';
import 'package:payzo_books/view/customer_screen/components/customer_body_listview.dart';
import 'package:payzo_books/view/customer_screen/components/customer_body_widget.dart';
import 'package:payzo_books/view/customer_screen/components/customer_error_view.dart';
import 'package:payzo_books/view/customer_screen/components/customer_fab.dart';
import 'package:payzo_books/view/customer_screen/components/customer_search_data.dart';
import 'package:payzo_books/view/customer_screen/components/customer_search_ui.dart';
import 'package:payzo_books/view/customer_screen/provider/customer_fn_provider.dart';
import 'package:payzo_books/view/customer_screen/provider/customer_pagination_provider.dart';

class CustomerScreen extends ConsumerStatefulWidget {
  const CustomerScreen({super.key});

  @override
  ConsumerState<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends ConsumerState<CustomerScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshCustomerList();
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
      _refreshCustomerList();
    }
  }

  void _refreshCustomerList() {
    final paginationState = ref.read(customerPaginationStateProvider);

    if (paginationState.searchQuery.isNotEmpty) {
      ref
          .read(customerPaginationStateProvider.notifier)
          .setSearchQuery(paginationState.searchQuery);
    } else {
      ref.read(customerPaginationStateProvider.notifier).refresh();
    }
  }

  // Future<void> _refresh() async {
  //   final paginationState = ref.read(customerPaginationStateProvider);

  //   if (paginationState.searchQuery.isNotEmpty) {
  //     await ref
  //         .read(customerPaginationStateProvider.notifier)
  //         .setSearchQuery(paginationState.searchQuery);
  //   } else {
  //     await ref.read(customerPaginationStateProvider.notifier).refresh();
  //   }
  // }

  Future<void> _refresh() async {
    // ✅ Clear cache before refreshing
    ref.invalidate(getCustomerDataWithPagination);

    final paginationState = ref.read(customerPaginationStateProvider);

    if (paginationState.searchQuery.isNotEmpty) {
      await ref
          .read(customerPaginationStateProvider.notifier)
          .setSearchQuery(paginationState.searchQuery);
    } else {
      await ref.read(customerPaginationStateProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScalingFactor(
      child: Scaffold(
        appBar: reusableAppBar(
            context: context, title: AppText.customers, showBackButton: true),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Column(
            children: [
              CustomerSearchUi(),
              CustomerBodyWidget(
                scrollController: _scrollController,
              ),
            ],
          ),
        ),
        floatingActionButton: customerFABBtn(context: context),
      ),
    );
  }
}
