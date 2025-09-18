import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/searchbar/provider/search_bar_provider.dart';
import 'package:payzo_books/view/customer_screen/provider/customer_pagination_provider.dart';
import 'dart:async';
import 'dart:developer' as developer;

class CustomerSearchUi extends ConsumerStatefulWidget {
  const CustomerSearchUi({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerSearchUiState();
}

class _CustomerSearchUiState extends ConsumerState<CustomerSearchUi> {
  final TextEditingController customerSearchController =
      TextEditingController();
  Timer? _debounceTimer;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(canRequestFocus: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentQuery =
          ref.read(customerPaginationStateProvider).searchQuery;
      if (currentQuery.isNotEmpty &&
          customerSearchController.text != currentQuery) {
        customerSearchController.text = currentQuery;
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    customerSearchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void customerOnChange(String value) {
    ref.read(searchProvider.notifier).updateSearchQuery(value);

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted &&
          ref.read(customerPaginationStateProvider.notifier) != null) {
        developer.log('Executing search for: "$value"',
            name: 'CustomerSearchUI');
        _debounceTimer = null;
        ref
            .read(customerPaginationStateProvider.notifier)
            .setSearchQuery(value);
      }
    });
  }

  void customerOnClear() {
    developer.log('Clearing customer search', name: 'CustomerSearchUI');

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
      _debounceTimer = null;
    }

    customerSearchController.clear();

    ref.read(searchProvider.notifier).clearSearch();

    ref.read(customerPaginationStateProvider.notifier).setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(customerPaginationStateProvider);

    if (paginationState.searchQuery != customerSearchController.text &&
        !customerSearchController.selection.isValid) {
      customerSearchController.text = paginationState.searchQuery;
    }

    return BodyStatus(
      controller: customerSearchController,
      onChanged: customerOnChange,
      onClear: customerOnClear,
      hintText: 'Search by Customer First Name',
      focusNode: _focusNode,
    );
  }
}
