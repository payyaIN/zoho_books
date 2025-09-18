import 'dart:async';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/searchbar/provider/search_bar_provider.dart';
import 'package:payzo_books/view/expenses/provider/expense_pagination_provider.dart';

class ExpensesSearchData extends ConsumerStatefulWidget {
  const ExpensesSearchData({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExpensesSearchDataState();
}

class _ExpensesSearchDataState extends ConsumerState<ExpensesSearchData> {
  final TextEditingController expensesSearchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    expensesSearchController.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        final searchText = expensesSearchController.text.trim();
        print("Search controller value changed to: '$searchText'");
        ref.read(searchProvider.notifier).updateSearchQuery(searchText);
        ref
            .read(expensesPaginationStateProvider.notifier)
            .setSearchQuery(searchText);
      });
    });
  }

  @override
  void dispose() {
    expensesSearchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void expensesOnChange(String value) {
    print("expensesOnChange called with: '$value'");
  }

  void expensesOnClear() {
    print("expensesOnClear called");
    expensesSearchController.clear();
    ref.read(searchProvider.notifier).clearSearch();
    ref.read(expensesPaginationStateProvider.notifier).setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(expensesPaginationStateProvider).searchQuery;

    if (searchQuery != expensesSearchController.text &&
        expensesSearchController.text.isEmpty) {
      print("Syncing controller from state: '$searchQuery'");
      if (expensesSearchController.text.isEmpty && searchQuery.isNotEmpty) {
        expensesSearchController.text = searchQuery;
      }
    }

    return BodyStatus(
      controller: expensesSearchController,
      onChanged: expensesOnChange,
      onClear: expensesOnClear,
      hintText: 'Search by Reference No',
    );
  }
}
