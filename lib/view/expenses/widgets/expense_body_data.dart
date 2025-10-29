import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/expenses/model/expenses_fn_provider.dart';
import 'package:payzo_books/view/expenses/provider/expense_pagination_provider.dart';
import 'package:payzo_books/view/expenses/repo/expense_repo.dart';
import 'package:payzo_books/view/expenses/widgets/expense_empty_view.dart';
import 'package:payzo_books/view/expenses/widgets/expense_error_widget.dart';
import 'package:payzo_books/view/expenses/widgets/expense_list_view.dart';

class ExpensesBodyData extends ConsumerStatefulWidget {
  const ExpensesBodyData({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ExpensesBodyDataState();
}

class _ExpensesBodyDataState extends ConsumerState<ExpensesBodyData> {
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
    final paginationState = ref.watch(expensesPaginationStateProvider);
    final paginationNotifier =
        ref.read(expensesPaginationStateProvider.notifier);
    final selectionState = ref.watch(expensesSelectionProvider);
    final selectionNotifier = ref.read(expensesSelectionProvider.notifier);

    if (isFirstLoad && scrollController.hasClients) {
      isFirstLoad = false;
      print('Initializing scroll controller for pagination');

      scrollController.addListener(() {
        if (scrollController.position.pixels >=
                scrollController.position.maxScrollExtent * 0.8 &&
            !paginationState.isLoading &&
            paginationState.hasNextPage &&
            paginationState.searchQuery.isEmpty) {
          print('Triggering loadMoreExpenses from scroll controller listener');
          paginationNotifier.loadMoreExpenses();
        }
      });
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          print('Manual refresh triggered');
          ref.invalidate(getExpenseDataWithPagination);
          paginationNotifier.refresh();
        },
        child: paginationState.isLoading && paginationState.expenses.isEmpty
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
                    paginationState.expenses.isEmpty
                ? expensesErrorViewWidget(
                    paginationState.errorMessage!, paginationNotifier)
                : paginationState.expenses.isEmpty
                    ? expensesEmptyView()
                    : expensesBuildListView(
                        context: context,
                        ref: ref,
                        paginationState: paginationState,
                        selectionState: selectionState,
                        selectionNotifier: selectionNotifier,
                        scrollController: scrollController,
                      ),
      ),
    );
  }
}
