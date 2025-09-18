import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/vendor_screen/components/vendor_body_list_view.dart';
import 'package:payzo_books/view/vendor_screen/components/vendor_error_view.dart';
import 'package:payzo_books/view/vendor_screen/provider/vendor_pagination_provider.dart';
import 'dart:developer' as developer;

class VendorBodyWidget extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const VendorBodyWidget({required this.scrollController, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VendorBodyWidgetState();
}

class _VendorBodyWidgetState extends ConsumerState<VendorBodyWidget> {
  @override
  void initState() {
    super.initState();

    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels >=
              widget.scrollController.position.maxScrollExtent * 0.8 &&
          !ref.read(vendorPaginationStateProvider).isLoading &&
          ref.read(vendorPaginationStateProvider).hasNextPage) {
        ref.read(vendorPaginationStateProvider.notifier).loadMoreVendors();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(vendorPaginationStateProvider);

    if (paginationState.isLoading && paginationState.vendors.isEmpty) {
      return const Expanded(
          child: Center(
              child: CircularProgressIndicator(color: AppColors.appMainColor)));
    }

    if (paginationState.errorMessage != null &&
        paginationState.vendors.isEmpty) {
      return Expanded(
          child: vendorErrorView(paginationState.errorMessage!, ref));
    }

    if (paginationState.vendors.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                paginationState.searchQuery.isEmpty
                    ? Icons.business_outlined
                    : Icons.search_off,
                size: 64,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 16),
              Text(
                paginationState.searchQuery.isEmpty
                    ? "No vendors available"
                    : "No vendors match your search",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              if (paginationState.searchQuery.isNotEmpty) ...[
                SizedBox(height: 8),
                Text(
                  "Try a different search term",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Expanded(
      child: vendorBodyListView(paginationState, widget.scrollController, ref),
    );
  }
}
