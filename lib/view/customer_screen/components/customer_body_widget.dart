import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/customer_screen/components/customer_body_listview.dart';
import 'package:payzo_books/view/customer_screen/components/customer_error_view.dart';
import 'package:payzo_books/view/customer_screen/provider/customer_pagination_provider.dart';

class CustomerBodyWidget extends ConsumerStatefulWidget {
  final ScrollController scrollController;
  const CustomerBodyWidget({required this.scrollController, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerBodyWidgetState();
}

class _CustomerBodyWidgetState extends ConsumerState<CustomerBodyWidget> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      if (widget.scrollController.position.pixels >=
              widget.scrollController.position.maxScrollExtent * 0.8 &&
          !ref.read(customerPaginationStateProvider).isLoading &&
          ref.read(customerPaginationStateProvider).hasNextPage) {
        ref.read(customerPaginationStateProvider.notifier).loadMoreCustomers();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paginationState = ref.watch(customerPaginationStateProvider);

    if (paginationState.isLoading && paginationState.customers.isEmpty) {
      return const Expanded(
          child: Center(
              child: CircularProgressIndicator(color: AppColors.appMainColor)));
    }

    if (paginationState.errorMessage != null &&
        paginationState.customers.isEmpty) {
      return Expanded(
          child: customerErrorView(paginationState.errorMessage!, ref));
    }

    if (paginationState.customers.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                paginationState.searchQuery.isEmpty
                    ? Icons.people_outline
                    : Icons.search_off,
                size: 64,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 16),
              Text(
                paginationState.searchQuery.isEmpty
                    ? "No customers available"
                    : "No customers match your search",
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
      child:
          customerBodyListView(paginationState, widget.scrollController, ref),
    );
  }
}
