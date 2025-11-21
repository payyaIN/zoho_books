import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payzo_books/data/services/base_api_service.dart';
import 'package:payzo_books/view/add/add_customer/notifiers/customer_form_provider.dart';
import 'package:payzo_books/data/models/base_api_response.dart';
import '../../../import_data.dart';

class UpdateCustomerRepository {
  final Ref ref;

  UpdateCustomerRepository(this.ref);

  Future<BaseApiResponse> updateCustomer({required int partyId}) async {
    final state = ref.read(customerFormProvider);
    debugPrint("🧾 Update Customer State (toJson): ${state.toJson()}");

    // primary contact values
    final String primaryFirst = state.primaryContact?.firstName ?? '';
    final String primaryLast = state.primaryContact?.lastName ?? '';

    // primary contact arabic
    final String primaryFirstArabic = state.primaryContactArabic?.firstNameArabic ?? '';
    final String primaryLastArabic = state.primaryContactArabic?.lastNameArabic ?? '';

    // opening balance fields
    final openingBranch = state.openingBalance?.branch;
    final openingCurrency = state.openingBalance?.currency;
    final openingAmount = state.openingBalance?.amount?.toString() ?? '';

    // billing/shipping addresses (model uses objects, not maps)
    final billing = state.billingAddress;
    final shipping = state.shippingAddress;

    // build contactPersons: prefer contactPersons list in state, otherwise use primary contact
    List<Map<String, dynamic>> contactPersonsPayload = [];
    if (state.contactPersons != null && state.contactPersons!.isNotEmpty) {
      contactPersonsPayload = state.contactPersons!
          .map((cp) => <String, dynamic>{
        'firstName': cp.firstName ?? '',
        'lastName': cp.lastName ?? '',
        'emailAddress': cp.emailAddress ?? '',
        'cpMobCode': cp.cpMobCode ?? state.mobileCode ?? '',
        'mobileNo': cp.mobileNo ?? state.mobile ?? '',
        'events': cp.events ?? <dynamic>[],
      })
          .toList();
    } else {
      // fallback to primary contact
      contactPersonsPayload = [
        {
          'firstName': primaryFirst,
          'lastName': primaryLast,
          'emailAddress': state.emailAddress ?? '',
          'cpMobCode': state.mobileCode ?? '',
          'mobileNo': state.mobile ?? '',
          'events': <dynamic>[],
        }
      ];
    }

    // documents payload: convert Documents model -> map (if any)
    final documentsPayload = (state.documents ?? []).map((doc) {
      return <String, dynamic>{
        'attachmentList': doc.attachmentList ?? <dynamic>[],
        'documentType': doc.documentType ?? '',
        'expirydate': doc.expirydate ?? '',
        'documentNumber': doc.documentNumber ?? '',
        'file': doc.file ?? <dynamic>[],
      };
    }).toList();

    final customerBody = <String, dynamic>{
      "primaryContact": {
        "firstName": primaryFirst,
        "lastName": primaryLast,
      },
      "primaryContactArabic": {
        "firstNameArabic": primaryFirstArabic,
        "lastNameArabic": primaryLastArabic,
      },
      "customerType": (state.customerType ?? 'BUSINESS').toString().toUpperCase(),
      "partyType": (state.partyType ?? 'CUSTOMER'),
      "partyId": partyId.toString(),
      "companyName": state.companyName ?? '',
      "companyNameArabic": state.companyNameArabic ?? '',
      "displayName": (state.displayName != null && state.displayName!.isNotEmpty)
          ? state.displayName
          : (state.companyName ?? ''),
      "emailAddress": state.emailAddress ?? '',
      "phoneCode": state.phoneCode ?? '',
      "phone": state.phone ?? '',
      "mobileCode": state.mobileCode ?? '',
      "mobile": state.mobile ?? '',
      "governmentEntity": state.governmentEntity ?? false,
      "taxedOrganization": state.taxedOrganization ?? false,
      "openingBalance": {
        "branch": openingBranch,
        "currency": openingCurrency,
        "amount": openingAmount,
      },
      "documents": documentsPayload,
      "remark": {"remark": state.remark?.remark ?? ''},
      "customFields": state.customFields ?? {},
      "reportingTag": state.reportingTag ?? {},
      "billingAddress": {
        "countryRegion": billing?.countryRegion ?? '',
        "buildingNumber": billing?.buildingNumber ?? billing?.buildingNumber ?? '',
        "streetName": billing?.streetName ?? '',
        "streetAddress": billing?.streetAddress ?? '',
        "streetAddressArabic": billing?.streetAddressArabic ?? '',
        "city": billing?.city ?? '',
        "cityArabic": billing?.cityArabic ?? '',
        "state": billing?.state ?? '',
        "zipCode": billing?.zipCode ?? '',
      },
      "shippingAddress": {
        "countryRegion": shipping?.countryRegion ?? '',
        "buildingNumber": shipping?.buildingNumber ?? '',
        "streetName": shipping?.streetName ?? '',
        "streetAddress": shipping?.streetAddress ?? '',
        "streetAddressArabic": shipping?.streetAddressArabic ?? '',
        "city": shipping?.city ?? '',
        "cityArabic": shipping?.cityArabic ?? '',
        "state": shipping?.state ?? '',
        "zipCode": shipping?.zipCode ?? '',
      },
      "contactPersons": contactPersonsPayload,
      "sameAddressFlag": state.sameAddressFlag ?? false,
      "vatNumber": state.vatNumber ?? '',
      "crNum": state.crNum ?? '',
    };

    const url = 'http://81.208.173.149/pb-process-service/api/process/updateVendor';

    return await ref.read(apiServiceProvider).postApi<BaseApiResponse>(
      url: url,
      body: customerBody,
      fromJson: (json) => BaseApiResponse.fromJson(json),
    );
  }
}

final updateCustomerRepoProvider = Provider<UpdateCustomerRepository>((ref) {
  return UpdateCustomerRepository(ref);
});
