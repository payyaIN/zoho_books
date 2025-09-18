import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/searchbar/provider/search_bar_provider.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_pagination_provider.dart';
import 'dart:async';

class BillSearchData extends ConsumerStatefulWidget {
  const BillSearchData({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BillSearchDataState();
}

class _BillSearchDataState extends ConsumerState<BillSearchData> {
  final TextEditingController billSearchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    billSearchController.addListener(() {
      if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        final searchText = billSearchController.text.trim();
        print("Search controller value changed to: '$searchText'");
        ref.read(searchProvider.notifier).updateSearchQuery(searchText);
        ref
            .read(billPaginationStateProvider.notifier)
            .setSearchQuery(searchText);
      });
    });
  }

  @override
  void dispose() {
    billSearchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void billOnChange(String value) {
    print("billOnChange called with: '$value'");
  }

  void billOnClear() {
    print("billOnClear called");
    billSearchController.clear();
    ref.read(searchProvider.notifier).clearSearch();
    ref.read(billPaginationStateProvider.notifier).setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(billPaginationStateProvider).searchQuery;

    if (searchQuery != billSearchController.text &&
        billSearchController.text.isEmpty) {
      print("Syncing controller from state: '$searchQuery'");
      if (billSearchController.text.isEmpty && searchQuery.isNotEmpty) {
        billSearchController.text = searchQuery;
      }
    }

    return BodyStatus(
      controller: billSearchController,
      onChanged: billOnChange,
      onClear: billOnClear,
      hintText: 'Search by Reference No',
    );
  }
}
