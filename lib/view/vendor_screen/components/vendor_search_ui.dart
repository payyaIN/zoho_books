import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/utils/searchbar/provider/search_bar_provider.dart';
import 'package:payzo_books/view/vendor_screen/provider/vendor_pagination_provider.dart';
import 'dart:async';
import 'dart:developer' as developer;

class VendorSearchUi extends ConsumerStatefulWidget {
  const VendorSearchUi({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VendorSearchUiState();
}

class _VendorSearchUiState extends ConsumerState<VendorSearchUi> {
  final TextEditingController vendorSearchController = TextEditingController();
  Timer? _debounceTimer;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(canRequestFocus: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentQuery = ref.read(vendorPaginationStateProvider).searchQuery;
      if (currentQuery.isNotEmpty &&
          vendorSearchController.text != currentQuery) {
        vendorSearchController.text = currentQuery;
      }
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    vendorSearchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void vendorOnChange(String value) {
    ref.read(searchProvider.notifier).updateSearchQuery(value);

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted && ref.read(vendorPaginationStateProvider.notifier) != null) {
        developer.log('Executing search for: "$value"', name: 'VendorSearchUI');
        _debounceTimer = null;
        ref.read(vendorPaginationStateProvider.notifier).setSearchQuery(value);
      }
    });
  }

  void vendorClearSearch() {
    developer.log('Clearing vendor search', name: 'VendorSearchUI');

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
      _debounceTimer = null;
    }

    vendorSearchController.clear();

    ref.read(searchProvider.notifier).clearSearch();

    ref.read(vendorPaginationStateProvider.notifier).setSearchQuery('');
  }

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(vendorPaginationStateProvider);

    if (paginationState.searchQuery != vendorSearchController.text &&
        !vendorSearchController.selection.isValid) {
      vendorSearchController.text = paginationState.searchQuery;
    }

    return BodyStatus(
      controller: vendorSearchController,
      onChanged: vendorOnChange,
      onClear: vendorClearSearch,
      hintText: 'Search by Vendor First Name',
      focusNode: _focusNode,
    );
  }
}
