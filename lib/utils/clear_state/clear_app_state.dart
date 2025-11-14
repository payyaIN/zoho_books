import 'package:payzo_books/import_data.dart';

import 'package:payzo_books/data/repository/bills_api/bills_api.dart';
import 'package:payzo_books/data/repository/customer_list_page/customer_listing_api.dart';
import 'package:payzo_books/data/repository/vendor_api/vendor_listing/vendor_api.dart';
import 'package:payzo_books/data/repository/invoice_api/invoice_detail_api.dart';
import 'package:payzo_books/data/repository/products_api/product_list_api.dart';
import 'package:payzo_books/data/repository/get_user_details/get_user_details.dart';
import 'package:payzo_books/data/repository/logout/log_out_api.dart';

import 'package:payzo_books/data/repository/rfq/get_rfq_details.dart';
import 'package:payzo_books/data/repository/quotes_api/quotes_details_api.dart';
import 'package:payzo_books/data/repository/purchase_order/get_order_details.dart';

import 'package:payzo_books/view/customer_screen/provider/customer_fn_provider.dart';
import 'package:payzo_books/view/vendor_details/provider/vendor_detail_fn_provider.dart';
import 'package:payzo_books/view/product_page/provider/product_selection.dart';
import 'package:payzo_books/view/invoice_details_page/provider/invoice_detail_provider.dart';

import 'package:payzo_books/view/customer_screen/provider/customer_pagination_provider.dart';
import 'package:payzo_books/view/vendor_screen/provider/vendor_pagination_provider.dart';
import 'package:payzo_books/view/bill_screen/provider/bill_pagination_provider.dart';
import 'package:payzo_books/view/invoice_screen/provider/invoice_pagination_provider.dart';
import 'package:payzo_books/view/product_page/provider/product_pagination_provider.dart';

import 'package:payzo_books/utils/searchbar/provider/search_bar_provider.dart';
import 'package:payzo_books/view/product_page/provider/product_search_provider.dart';

import 'package:payzo_books/view/add/add_vendor/notifier/add_vendor_notifier.dart';
import 'package:payzo_books/view/customer_detail_page/provider/country_list_provider.dart';

import 'package:payzo_books/view/notification_details/approve_notification/provider/approve_notification_provider.dart';
import 'package:payzo_books/view/notification_details/reject_notification/reject_provider/reject_provider.dart';

import '../../data/repository/add_vendor/get_country_list_repository.dart';

class ProviderInvalidationHelper {
  static Future<void> invalidateAllProviders(WidgetRef ref) async {
    try {
      print('🔄 Starting comprehensive provider invalidation...');

      _invalidateDataProviders(ref);

      _invalidatePaginationProviders(ref);

      _invalidateSelectionProviders(ref);

      _invalidateSearchProviders(ref);

      _invalidateFormProviders(ref);

      _invalidateNotificationProviders(ref);

      _invalidateAuthProviders(ref);

      print('✅ All providers invalidated successfully');
    } catch (e) {
      print('❌ Error during provider invalidation: $e');
      rethrow;
    }
  }

  /// Invalidates core data fetching providers
  static void _invalidateDataProviders(WidgetRef ref) {
    print('🔄 Invalidating data providers...');

    // Bill Data
    ref.invalidate(getBillData);
    ref.invalidate(getBillDataWithPagination);
    ref.invalidate(pendingBillListProvider);
    ref.invalidate(getAllBillsData);

    // Customer Data
    ref.invalidate(getCustomerData);
    ref.invalidate(getCustomerDataWithPagination);
    ref.invalidate(getAllCustomersData);

    // Vendor Data
    ref.invalidate(getVendorData);
    ref.invalidate(getVendorDataWithPagination);
    ref.invalidate(getAllVendorsData);

    // Invoice Data
    ref.invalidate(getInvoiceData);
    ref.invalidate(getInvoiceDataWithPagination);
    ref.invalidate(getInvoiceDataOfAll);
    ref.invalidate(pendingInvoicesProvider);
    ref.invalidate(getAllInvoiceData);

    // Product Data
    ref.invalidate(getProductData);
    ref.invalidate(getProductDataWithPagination);
    ref.invalidate(getProductByIdProvider);
    ref.invalidate(getAllProductsData);

    // User Data
    ref.invalidate(fetchUserDetails);
    ref.invalidate(getUserDetailsProvider);

    // Country Data
    ref.invalidate(getCountryList);
    ref.invalidate(countryListProvider);

    print('Data providers invalidated');
  }
  /// Invalidates all pagination state providers

  static void _invalidatePaginationProviders(WidgetRef ref) {
    print('🔄 Invalidating pagination providers...');
    ref.invalidate(customerPaginationStateProvider);
    ref.invalidate(vendorPaginationStateProvider);
    ref.invalidate(billPaginationStateProvider);
    ref.invalidate(invoicePaginationStateProvider);
    ref.invalidate(productPaginationStateProvider);

    print('✅ Pagination providers invalidated');
  }

  /// Invalidates selection and detail providers
  static void _invalidateSelectionProviders(WidgetRef ref) {
    print('🔄 Invalidating selection providers...');

    // Customer Selection
    ref.invalidate(customerSelectionProvider);
    ref.invalidate(specificCustomerProvider);

    // Vendor Selection
    ref.invalidate(vendorSelectionProvider);
    ref.invalidate(specificVendorProvider);

    // Product Selection
    ref.invalidate(productSelectionProvider);
    ref.invalidate(productSelectionDataProvider);
    ref.invalidate(selectedProductDetailProvider);
    ref.invalidate(specificProductProvider);
    ref.invalidate(selectedProductIdProvider);
    ref.invalidate(selectedProductProvider);

    // Invoice Selection
    ref.invalidate(invoiceSelectionProvider);
    ref.invalidate(selectedInvoiceDetailProvider);
    ref.invalidate(specificInvoiceProvider);

    print('✅ Selection providers invalidated');
  }

  /// Invalidates search-related providers
  static void _invalidateSearchProviders(WidgetRef ref) {
    print('🔄 Invalidating search providers...');

    ref.invalidate(searchProvider);
    ref.invalidate(productSearchProvider);
    ref.invalidate(productFocusNodeProvider);
    ref.invalidate(productTextControllerProvider);
    ref.invalidate(filteredProductsProvider);

    print('✅ Search providers invalidated');
  }

  /// Invalidates form and UI state providers
  static void _invalidateFormProviders(WidgetRef ref) {
    print('🔄 Invalidating form providers...');

    ref.invalidate(vendorFormProvider);

    print('✅ Form providers invalidated');
  }

  /// Invalidates notification-related providers
  static void _invalidateNotificationProviders(WidgetRef ref) {
    print('🔄 Invalidating notification providers...');

    // Notification Data
    ref.invalidate(getNotificationsProvider);
    ref.invalidate(selectedNotificationIdProvider);

    // Notification State
    ref.invalidate(approveNotificationStateProvider);
    ref.invalidate(rejectNotificationStateProvider);
    ref.invalidate(rejectionReasonProvider);
    ref.invalidate(rejectionStatusProvider);
    ref.invalidate(rejectionErrorProvider);

    print('✅ Notification providers invalidated');
  }

  /// Invalidates auth-related providers (but keeps login state)
  static void _invalidateAuthProviders(WidgetRef ref) {
    print('🔄 Invalidating auth providers...');

    // Logout provider can be invalidated as it's used for the logout process
    ref.invalidate(logoutProvider);
    ref.invalidate(logoutRepositoryProvider);

    print('✅ Auth providers invalidated');
  }

  /// Invalidates specific family providers for given parameters
  ///
  /// Use this for targeted invalidation when you know specific IDs
  static void invalidateFamilyProviders(
    WidgetRef ref, {
    List<int>? billIds,
    List<int>? invoiceIds,
    List<int>? rfqIds,
    List<int>? quoteIds,
    List<int>? orderIds,
  }) {
    print('🔄 Invalidating family providers with specific parameters...');

    // Invalidate specific bill details
    if (billIds != null) {
      for (final id in billIds) {
        ref.invalidate(getBillDetailsProvider(id));
      }
    }

    // Invalidate specific invoice details
    if (invoiceIds != null) {
      for (final id in invoiceIds) {
        ref.invalidate(getInvoiceDetailsProvider(id));
      }
    }

    // Invalidate specific RFQ details
    if (rfqIds != null) {
      for (final id in rfqIds) {
        ref.invalidate(getRfqDetailsProvider(id));
      }
    }

    // Invalidate specific quote details
    if (quoteIds != null) {
      for (final id in quoteIds) {
        ref.invalidate(getQuoteDetailsProvider(id));
      }
    }

    // Invalidate specific order details
    if (orderIds != null) {
      for (final id in orderIds) {
        ref.invalidate(getOrderDetailsProvider(id));
      }
    }

    print('Family providers invalidated');
  }

  static void quickDataRefresh(WidgetRef ref) {
    print('Quick data refresh...');

    _invalidateDataProviders(ref);
    _invalidatePaginationProviders(ref);

    print('Quick data refresh completed');
  }

  static void resetUIState(WidgetRef ref) {
    print('Resetting UI state...');

    _invalidateSearchProviders(ref);
    _invalidateSelectionProviders(ref);

    print('UI state reset completed');
  }
}

extension ProviderInvalidationExtension on WidgetRef {
  Future<void> invalidateAllProviders() async {
    await ProviderInvalidationHelper.invalidateAllProviders(this);
  }

  void quickDataRefresh() {
    ProviderInvalidationHelper.quickDataRefresh(this);
  }

  void resetUIState() {
    ProviderInvalidationHelper.resetUIState(this);
  }
}
