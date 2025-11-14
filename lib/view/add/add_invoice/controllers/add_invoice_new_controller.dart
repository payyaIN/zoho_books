// lib/controllers/add_invoice_new_controller.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:payzo_books/view/add/add_invoice/providers/invoice_address_providers.dart' show invoiceBillingAddressProvider, invoiceShippingAddressProvider;

import '../../../../data/repository/add_invoice/get_customer_list_repo.dart';
import '../../../../import_data.dart';
import '../../../../utils/common_widgets/reusable_bottom_sheet.dart';
import '../providers/add_invoice_providers_new.dart';

class AddInvoiceNewController extends StateNotifier<bool> {
  final Ref ref;

  AddInvoiceNewController(this.ref) : super(false);

  void setLoading(bool value) => state = value;

  /// Call this on screen open to prefetch all bottom-sheet lists
  /// so that bottom sheets open instantly.
  Future<void> initOnOpen() async {
    setLoading(true);
    try {
      // Parallel prefetch of all lists. Add or remove providers as needed.
      final futures = <Future<dynamic>>[
        ref.read(fetchCustomerListProvider.future),
      ];

      // Wait for all to complete but don't fail-fast on single failure
      await Future.wait(
        futures.map((f) => f.catchError((e, st) {
          if (kDebugMode) {
            print('prefetch error: $e\n$st');
          }
          return null;
        })),
      );

      // ✅ All data loaded successfully
      if (kDebugMode) {
        print('All Add Invoice selection lists loaded ✅');
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('initOnOpen failed: $e\n$st');
      }
    } finally {
      setLoading(false);
    }
  }

  /// customer name selection — does NOT pop the bottom sheet on selection
  Future<void> selectCustomer(BuildContext context) async {
    try {
      // unfocus UI
      await ref.read(focusUtilsProvider).unfocusAndDelay();

      // prefetch customers (expected: List<Customer>)
      final customerAsync = await ref.read(fetchCustomerListProvider.future);

      final customerNames = customerAsync
          .map((e) => e.displayName ?? '')
          .where((e) => e.isNotEmpty)
          .toSet()
          .toList();

      if (!context.mounted) return;

      // show bottom sheet — stays open after selection
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) {
          return ReusableCountryBottomSheet(
            title: 'Customer',
            items: customerNames,
            onSelect: (selectedName) {
              // find selected customer model
              final selectedCustomer = customerAsync.firstWhere(
                    (e) => e.displayName == selectedName,
                orElse: () => customerAsync.first,
              );

              // update providers (name/id)
              ref.read(customerNameAddInvoiceProvider.notifier).state =
                  selectedCustomer.displayName;
              ref.read(customerNameIdAddInvoiceProvider.notifier).state =
                  selectedCustomer.partyId?.toString();

              // clear any previous error
              ref.read(customerNameAddInvoiceErrorProvider.notifier).state = null;

              // populate invoice billing & shipping providers
              try {
                _populateInvoiceAddressProviders(selectedCustomer);
              } catch (e, st) {
                if (kDebugMode) {
                  print('Error populating invoice address providers: $e\n$st');
                }
              }

              if (kDebugMode) {
                print(
                    'customer name: ${selectedCustomer.displayName}, customer id: ${selectedCustomer.partyId}');
              }

              // NOTE: intentionally NOT popping the sheet here.
            },
          );
        },
      );
    } catch (e, st) {
      ref.read(customerNameAddInvoiceErrorProvider.notifier).state =
      'Failed to load customers';
      debugPrint('selectCustomer error: $e\n$st');
    }
  }

  /// ✅ Validation method to ensure customer is selected
  bool validateCustomerSelection() {
    final customerName = ref.read(customerNameAddInvoiceProvider);
    final customerId = ref.read(customerNameIdAddInvoiceProvider);

    if (customerName == null ||
        customerName.isEmpty ||
        customerId == null ||
        customerId.isEmpty) {
      ref.read(customerNameAddInvoiceErrorProvider.notifier).state =
      'Please select a customer';
      if (kDebugMode) {
        print('Validation failed: no customer selected ❌');
      }
      return false;
    }

    // Clear any previous error if valid
    ref.read(customerNameAddInvoiceErrorProvider.notifier).state = null;

    if (kDebugMode) {
      print('Validation passed ✅ - Customer selected: $customerName');
    }

    return true;
  }

  /// Clears all selection providers used on the Add Invoice screen.
  /// Call this when user hits back or leaves the page so the screen is fresh next open.
  void clearAllSelections() {
    // Customer
    ref.read(customerNameAddInvoiceProvider.notifier).state = null;
    ref.read(customerNameIdAddInvoiceProvider.notifier).state = null;
    ref.read(customerNameAddInvoiceErrorProvider.notifier).state = null;

    // Clear invoice address lists as well
    ref.read(invoiceBillingAddressProvider.notifier).clearAddresses();
    ref.read(invoiceShippingAddressProvider.notifier).clearAddresses();

    // TODO: Add any other selection providers you want reset on back.
    // Examples (uncomment/adjust provider names if you have them):
    // ref.read(vendorNameAddInvoiceProvider.notifier).state = null;
    // ref.read(branchAddInvoiceProvider.notifier).state = null;
    // ref.read(currencyAddInvoiceProvider.notifier).state = null;
    // ref.read(accountAddInvoiceProvider.notifier).state = null;

    if (kDebugMode) {
      print('All Add Invoice selections cleared ✅');
    }
  }

  /// Helper stub — checks whether provider name exists in your codebase.
  /// This is only for readability here. In practice, remove these checks
  /// and only include the providers you actually have.
  bool _providerExists(String providerName) {
    // Remove this implementation for production. It's here so the
    // prefetch list can be safely edited by you.
    // Return true if you have that provider; false otherwise.
    return true;
  }

  // -------------------------
  // PRIVATE: Populate invoice address providers
  // -------------------------
  // Accepts the selected customer object (dynamic to be flexible) and writes
  // formatted lines into invoiceBillingAddressProvider and invoiceShippingAddressProvider.
  void _populateInvoiceAddressProviders(dynamic selectedCustomer) {
    final billingNotifier =
    ref.read(invoiceBillingAddressProvider.notifier);
    final shippingNotifier =
    ref.read(invoiceShippingAddressProvider.notifier);

    // clear existing entries
    billingNotifier.clearAddresses();
    shippingNotifier.clearAddresses();

    // Build billing lines
    final List<String> billingLines = [];
    try {
      // header: displayName or companyName
      final dn = selectedCustomer.displayName;
      final comp = selectedCustomer.companyName;
      final header = (dn != null && dn.toString().trim().isNotEmpty)
          ? dn.toString().trim()
          : (comp != null && comp.toString().trim().isNotEmpty
          ? comp.toString().trim()
          : null);
      if (header != null) billingLines.add(header);

      final billing = selectedCustomer.billingAddress;
      if (billing != null) {
        final parts = <String>[];
        final street = billing.streetAddress;
        final bldg = billing.buildingNumber;
        final city = billing.city;
        final state = billing.state;
        final country = billing.countryName ?? billing.countryRegion;
        final zip = billing.zipCode;

        if (street != null && street.toString().trim().isNotEmpty) {
          parts.add(street.toString().trim());
        }
        if (bldg != null && bldg.toString().trim().isNotEmpty) {
          parts.add('Bldg: ${bldg.toString().trim()}');
        }
        if (city != null && city.toString().trim().isNotEmpty) {
          parts.add(city.toString().trim());
        }
        if (state != null && state.toString().trim().isNotEmpty) {
          parts.add('State: ${state.toString().trim()}');
        }
        if (country != null && country.toString().trim().isNotEmpty) {
          parts.add(country.toString().trim());
        }
        if (zip != null && zip.toString().trim().isNotEmpty) {
          parts.add('ZIP: ${zip.toString().trim()}');
        }
        if (parts.isNotEmpty) billingLines.add(parts.join(', '));
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('billing lines extraction error: $e\n$st');
      }
    }

    // Build shipping lines
    final List<String> shippingLines = [];
    try {
      final shipping = selectedCustomer.shippingAddress;
      if (shipping != null) {
        final parts = <String>[];
        final street = shipping.streetAddress;
        final bldg = shipping.buildingNumber;
        final city = shipping.city;
        final state = shipping.state;
        final country = shipping.countryName ?? shipping.countryRegion;
        final zip = shipping.zipCode;

        if (street != null && street.toString().trim().isNotEmpty) {
          parts.add(street.toString().trim());
        }
        if (bldg != null && bldg.toString().trim().isNotEmpty) {
          parts.add('Bldg: ${bldg.toString().trim()}');
        }
        if (city != null && city.toString().trim().isNotEmpty) {
          parts.add(city.toString().trim());
        }
        if (state != null && state.toString().trim().isNotEmpty) {
          parts.add('State: ${state.toString().trim()}');
        }
        if (country != null && country.toString().trim().isNotEmpty) {
          parts.add(country.toString().trim());
        }
        if (zip != null && zip.toString().trim().isNotEmpty) {
          parts.add('ZIP: ${zip.toString().trim()}');
        }
        if (parts.isNotEmpty) shippingLines.add(parts.join(', '));
      }

      // If shipping empty but billing has lines, optionally duplicate billing into shipping
      // Comment out the next block if you don't want this behavior.
      if (shippingLines.isEmpty && billingLines.length > 1) {
        // copy address line (not header) into shipping to show something
        shippingLines.add(billingLines[1]);
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('shipping lines extraction error: $e\n$st');
      }
    }

    // Build contact lines (mobile/email/phone/primary contact) as shipping provider additions
    try {
      final List<String> contactLines = [];
      final mobileCode = selectedCustomer.mobileCode;
      final mobile = selectedCustomer.mobile;
      final phoneCode = selectedCustomer.phoneCode;
      final phone = selectedCustomer.phone;
      final email = selectedCustomer.emailAddress;

      if (mobile != null && mobile.toString().trim().isNotEmpty) {
        final m = (mobileCode != null && mobileCode.toString().trim().isNotEmpty)
            ? '${mobileCode.toString().trim()} ${mobile.toString().trim()}'
            : mobile.toString().trim();
        contactLines.add('Mobile: $m');
      }

      if (phone != null && phone.toString().trim().isNotEmpty) {
        final p = (phoneCode != null && phoneCode.toString().trim().isNotEmpty)
            ? '${phoneCode.toString().trim()} ${phone.toString().trim()}'
            : phone.toString().trim();
        contactLines.add('Phone: $p');
      }

      if (email != null && email.toString().trim().isNotEmpty) {
        contactLines.add('Email: ${email.toString().trim()}');
      }

      final pc = selectedCustomer.primaryContact;
      if (pc != null) {
        final fname = pc.firstName ?? '';
        final lname = pc.lastName ?? '';
        final fullname = '${fname.toString().trim()} ${lname.toString().trim()}'.trim();
        if (fullname.isNotEmpty) contactLines.add('Contact: $fullname');
      }

      // append contact lines to shippingLines (so second column shows contact details)
      for (final c in contactLines) {
        if (!shippingLines.contains(c)) shippingLines.add(c);
      }
    } catch (e, st) {
      if (kDebugMode) {
        print('contact lines extraction error: $e\n$st');
      }
    }

    // Commit to providers (use addAddress to trigger state notifications)
    for (final line in billingLines) {
      billingNotifier.addAddress(line);
    }
    for (final line in shippingLines) {
      shippingNotifier.addAddress(line);
    }

    if (kDebugMode) {
      print('Populated billing lines: $billingLines');
      print('Populated shipping lines: $shippingLines');
    }
  }
}

final addInvoiceNewControllerProvider =
StateNotifierProvider<AddInvoiceNewController, bool>((ref) {
  return AddInvoiceNewController(ref);
});
