import 'package:payzo_books/data/models/customer_model/customer_model.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/customer_screen/components/customer_search_data.dart';
import 'package:payzo_books/view/customer_screen/provider/customer_fn_provider.dart';
import 'package:payzo_books/view/customer_screen/provider/customer_pagination_provider.dart';
import 'dart:developer' as developer;

Widget customerBodyListView(CustomerPaginationState paginationState,
    ScrollController scrollController, WidgetRef ref) {
  final customers = paginationState.customers;

  if (paginationState.searchQuery.isNotEmpty &&
      customers.isEmpty &&
      !paginationState.isLoading) {
    developer.log(
        'Search query: "${paginationState.searchQuery}" yielded no results',
        name: 'CustomerListView');
    return customerSearchData();
  }

  if (customers.isEmpty && !paginationState.isLoading) {
    developer.log('No customers found in current state',
        name: 'CustomerListView');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            "No customers found",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  return ListView.builder(
    controller: scrollController,
    physics: const AlwaysScrollableScrollPhysics(),
    itemCount: customers.length +
        (paginationState.hasNextPage && paginationState.searchQuery.isEmpty
            ? 1
            : 0),
    itemBuilder: (context, index) {
      if (index == customers.length) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              color: AppColors.appMainColor,
            ),
          ),
        );
      }

      final customer = customers[index];
      final safeImageIndex = index % customerImg.length;

      final fullName =
          "${customer.primaryContact.firstName} ${customer.primaryContact.lastName}"
              .trim();

      String stateValue = customer.billingAddress.state;
      String cityValue = customer.billingAddress.city;

      if (stateValue.length > 6) {
        stateValue = stateValue.substring(0, 6);
      }

      if (cityValue.length > 6) {
        cityValue = cityValue.substring(0, 6);
      }

      return GestureDetector(
        onTap: () {
          developer.log('Customer tapped: $fullName (ID: ${customer.partyId})',
              name: 'CustomerListView');

          final customerData = CustomerModel(
            error: false,
            response: ResponseData(
                response: [customer], totalRecord: customers.length),
            status: true,
            transactionId: "",
          );

          ref
              .read(customerSelectionProvider.notifier)
              .selectCustomer(customerData);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomerDetailPage(
                partyId: customer.partyId,
              ),
            ),
          );
        },
        child: customerAndVendorDetails(
          customerImg: customerImg[safeImageIndex],
          name: fullName,
          email: customer.emailAddress,
          stateValue: stateValue,
          cityValue: cityValue,
        ),
      );
    },
  );
}
