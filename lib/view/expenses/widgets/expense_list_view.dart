import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/app_data/parsed_date.dart';
import 'package:payzo_books/view/expenses/expense_details_page.dart';
import 'package:payzo_books/view/expenses/model/expenses_fn_provider.dart';
import 'package:payzo_books/view/expenses/provider/expense_notifier.dart';
import 'package:payzo_books/view/expenses/provider/expense_pagination_provider.dart';
import 'package:payzo_books/view/expenses/widgets/expense_item_widget.dart';
import 'package:payzo_books/view/expenses/widgets/expense_search_not_found.dart';

Widget expensesBuildListView({
  required BuildContext context,
  required WidgetRef ref,
  required ExpensesPaginationState paginationState,
  required ExpensesSelectionState selectionState,
  required ExpensesSelectionNotifier selectionNotifier,
  required ScrollController scrollController,
}) {
  final expenses = paginationState.searchQuery.isNotEmpty
      ? paginationState.filteredExpenses
      : paginationState.expenses;

  if (paginationState.searchQuery.isNotEmpty && expenses.isEmpty) {
    return expensesSearchNotFound();
  }

  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (scrollController.hasClients) {
      scrollController.removeListener(() {}); // clean any old listener

      scrollController.addListener(() {
        final maxScroll = scrollController.position.maxScrollExtent;
        final currentScroll = scrollController.position.pixels;
        final threshold = maxScroll * 0.8;

        if (currentScroll >= threshold &&
            !paginationState.isLoading &&
            paginationState.hasNextPage) {
          ref.read(expensesPaginationStateProvider.notifier).loadMoreExpenses();
        }
      });
    }
  });

  return NotificationListener<ScrollNotification>(
    onNotification: (ScrollNotification notification) {
      if (notification is ScrollEndNotification) {
        if (scrollController.position.extentAfter < 500 &&
            !paginationState.isLoading &&
            paginationState.hasNextPage) {
          ref.read(expensesPaginationStateProvider.notifier).loadMoreExpenses();
        }
      }
      return false;
    },
    child: ListView.builder(
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: expenses.length + (paginationState.hasNextPage ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == expenses.length) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: AppColors.appMainColor,
            ),
          );
        }

        final expense = expenses[index];

        return ExpensesItemWidget(
          index: index,
          isSelectionMode: selectionState.isSelectionMode,
          isSelected: index < selectionState.selectedItems.length
              ? selectionState.selectedItems[index]
              : false,
          onTap: () {
            if (selectionState.isSelectionMode) {
              selectionNotifier.toggleItemSelection(index);
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExpenseDetailPage(
                    expenseId: (expense.expenseId ?? 0).toInt(),
                  ),
                ),
              );
            }
          },
          onLongPress: () {
            selectionNotifier.toggleSelectionMode();
            selectionNotifier.toggleItemSelection(index);
          },
          reference: expense.reference?.toString() ?? "N/A",
          vendorName: expense.vendor ?? "No Vendor",
          amount: expense.expenseAmount?.toDouble() ?? 0,
          currency: expense.currency ?? "INR",
          date: formatDate(expense.date.toString()),
          branch: expense.branch ?? "",
          status: expense.status ?? "",
        );
      },
    ),
  );
}
