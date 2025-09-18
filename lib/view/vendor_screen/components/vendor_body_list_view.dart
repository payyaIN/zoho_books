import 'package:payzo_books/data/models/vendor_model/vendor_model.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/vendor_details/provider/vendor_detail_fn_provider.dart';
import 'package:payzo_books/view/vendor_screen/components/vendor_search_data.dart';
import 'package:payzo_books/view/vendor_screen/provider/vendor_pagination_provider.dart';
import 'dart:developer' as developer;

Widget vendorBodyListView(VendorPaginationState paginationState,
    ScrollController scrollController, WidgetRef ref) {
  final vendors = paginationState.vendors;

  if (paginationState.searchQuery.isNotEmpty &&
      vendors.isEmpty &&
      !paginationState.isLoading) {
    developer.log(
        'Search query: "${paginationState.searchQuery}" yielded no results',
        name: 'VendorListView');
    return vendorSearchData();
  }

  if (vendors.isEmpty && !paginationState.isLoading) {
    developer.log('No vendors found in current state', name: 'VendorListView');
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: 64,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 16),
          Text(
            "No vendors found",
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
    itemCount: vendors.length +
        (paginationState.hasNextPage && paginationState.searchQuery.isEmpty
            ? 1
            : 0),
    itemBuilder: (context, index) {
      if (index == vendors.length) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(
              color: AppColors.appMainColor,
            ),
          ),
        );
      }

      final vendor = vendors[index];
      final safeImageIndex = index % customerImg.length;

      final fullName =
          "${vendor.primaryContact.firstName} ${vendor.primaryContact.lastName}"
              .trim();

      String stateValue = vendor.billingAddress.state;
      String cityValue = vendor.billingAddress.city;

      if (stateValue.length > 6) {
        stateValue = stateValue.substring(0, 6);
      }

      if (cityValue.length > 6) {
        cityValue = cityValue.substring(0, 6);
      }

      return GestureDetector(
        onTap: () {
          developer.log('Vendor tapped: $fullName (ID: ${vendor.partyId})',
              name: 'VendorListView');

          final vendorData = VendorModel(
            error: false,
            response:
                ResponseData(response: [vendor], totalRecord: vendors.length),
            status: true,
            transactionId: "",
          );

          ref.read(vendorSelectionProvider.notifier).selectVendor(vendorData);

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VendorDetailPage(
                partyId: vendor.partyId,
              ),
            ),
          );
        },
        child: customerAndVendorDetails(
          customerImg: customerImg[safeImageIndex],
          name: fullName,
          email: vendor.emailAddress,
          stateValue: stateValue,
          cityValue: cityValue,
        ),
      );
    },
  );
}
