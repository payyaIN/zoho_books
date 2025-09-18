import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/bill_screen/components/bill_build_listview.dart';
import 'package:payzo_books/view/bill_screen/components/bill_empty_view.dart';
import 'package:payzo_books/view/bill_screen/components/bill_error_widget.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_fn_provider.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_pagination_provider.dart';

class BillBodyData extends ConsumerStatefulWidget {
  const BillBodyData({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BillBodyDataState();
}

class _BillBodyDataState extends ConsumerState<BillBodyData> {
  late ScrollController scrollController;
  bool isFirstLoad = true;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(billPaginationStateProvider);
    final paginationNotifier = ref.read(billPaginationStateProvider.notifier);
    final billSelectionState = ref.watch(billSelectionProvider);
    final billSelectionNotifier = ref.read(billSelectionProvider.notifier);

    if (isFirstLoad && scrollController.hasClients) {
      isFirstLoad = false;
      print('Initializing scroll controller for pagination');

      scrollController.addListener(() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent * 0.8 &&
            !paginationState.isLoading &&
            paginationState.hasNextPage &&
            paginationState.searchQuery.isEmpty) {
          print('Triggering loadMoreBills from scroll controller listener');
          paginationNotifier.loadMoreBills();
        }
      });
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          print('Manual refresh triggered');
          paginationNotifier.refresh();
        },
        child: paginationState.isLoading && paginationState.bills.isEmpty
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.appMainColor,
                    ),
                  ],
                ),
              )
            : paginationState.errorMessage != null &&
                    paginationState.bills.isEmpty
                ? billErrorViewWidget(
                    paginationState.errorMessage!, paginationNotifier)
                : paginationState.bills.isEmpty
                    ? billEmptyView()
                    : billBuildListView(
                        context: context,
                        ref: ref,
                        paginationState: paginationState,
                        selectionState: billSelectionState,
                        selectionNotifier: billSelectionNotifier,
                        scrollController: scrollController,
                      ),
      ),
    );
  }
}
