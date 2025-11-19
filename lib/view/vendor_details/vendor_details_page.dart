import 'package:payzo_books/data/repository/document_type/get_doc_type_api.dart';
import 'package:payzo_books/data/repository/event_api/get_event_api.dart';
import 'package:payzo_books/data/repository/price_currency/price_currency_api.dart';
import 'package:payzo_books/data/repository/vendor_api/vendor_details/vendor_detail_api.dart';
import 'package:payzo_books/data/repository/view_party/view_party_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/customer_detail_page/provider/country_list_provider.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_model.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_page.dart';
import 'package:payzo_books/view/update_vendor/update_vendor_provider.dart';
import 'package:payzo_books/view/vendor_details/components/formatr_fn_vndr.dart';
import 'package:payzo_books/view/vendor_details/components/no_vendor_detail_found_page.dart';

class VendorDetailPage extends ConsumerStatefulWidget {
  final int? partyId;
  const VendorDetailPage({super.key, this.partyId});

  @override
  ConsumerState<VendorDetailPage> createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends ConsumerState<VendorDetailPage> {
  String getValidPhoneNumber(int? phone, int? mobile) {
    // Check if phone is valid (not null and not 0)
    if (phone != null && phone != 0) {
      return phone.toString();
    }
    // Check if mobile is valid (not null and not 0)
    if (mobile != null && mobile != 0) {
      return mobile.toString();
    }
    // Return fallback text
    return AppText.vendorContact;
  }

  @override
  Widget build(BuildContext context) {
    final urlLauncher = ref.watch(phoneLauncherProvider);
    final vendorDetailsAsync =
        ref.watch(getVendorDetailsProvider(widget.partyId ?? 1));

    // final effectivePartyId = partyId ?? 1;
    // final urlLauncher = ref.read(phoneLauncherProvider);

    // print('Building VendorDetailPage for partyId: $partyId');

    // final vendorDetailsAsync =
    //     ref.watch(getVendorDetailsProvider(effectivePartyId));
    // final countryListState = ref.watch(countryListProvider);

    // final eventsAsync = ref.watch(eventsProvider);
    // final documentTypesAsync = ref.watch(documentTypesProvider);
    // final priceCurrenciesAsync = ref.watch(priceCurrenciesProvider);
    // final viewPartyAsync = ref.watch(viewPartyProvider(effectivePartyId));
    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgColor,
        appBar: reusableAppBar(
            title: 'Vendor Details', showBackButton: true, context: context),
        // reusableAppBarWithSuffixWidget(
        //     title: 'Vendor Details',
        //     context: context,
        //     showBackButton: true,
        //     isSuffixText: false,
        //     showTitle: true,
        //     widget: SvgPictureWidget(
        //         image: AppImages.editImg, height: 24, width: 24)),
        body: RefreshIndicator(
          // onRefresh: () =>
          //     ref.refresh(getVendorDetailsProvider(effectivePartyId).future),
          onRefresh: () async {
            ref.invalidate(getVendorDetailsProvider(widget.partyId ?? 1));
          },
          child: vendorDetailsAsync.when(
            data: (vndrData) {
              if (vndrData.response.response.isEmpty) {
                return noVendorDetailFoundPage(context: context);
              }

              final vendor = vndrData.response.response[0];
              String stateValue = vendor.billingAddress.state;
              String cityValue = vendor.billingAddress.city;

              if (stateValue.length > 6) {
                stateValue = stateValue.substring(0, 6);
              }

              if (cityValue.length > 6) {
                cityValue = cityValue.substring(0, 6);
              }

              // Get valid phone number using helper method
              final validPhoneNumber =
                  getValidPhoneNumber(vendor.phone, vendor.mobile);

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      headerTextAndWidgets(
                        headerText1: vendor.companyName,
                        headerText2: vendor.emailAddress,
                        img1: AppImages.call,
                        img2: AppImages.mail,
                        img3: AppImages.msg,
                        img4: AppImages.editWhite,
                        img5: '',
                        title1: AppText.call,
                        title2: AppText.mail,
                        title3: AppText.msg,
                        title4: AppText.editVendor,
                        title5: '',
                        isOnTap1Needed: true,
                        isOnTap3Needed: true,
                        isOnTap2Needed: true,
                        isOnTap4Needed: true,
                        isOnTap5Needed: false,
                        onTap1: () =>
                            urlLauncher.makePhoneCall(validPhoneNumber),
                        onTap2: () =>
                            urlLauncher.sendEmail(vendor.emailAddress),
                        onTap3: () => urlLauncher.sendSms(validPhoneNumber),
                        onTap4: () {
                          ref
                              .read(updateVendorEditModeProvider.notifier)
                              .state = true;
                          ref
                              .read(updateVendorEditPartyIdProvider.notifier)
                              .state = vendor.partyId;
                          ref.read(vendorEditDataProvider.notifier).state =
                              vendor;

                          // Navigate
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UpdateVendorScreen(),
                            ),
                          );
                        },
                        onTap5: () {},
                      ),
                      GapSpace.height35,
                      financialCard(
                        state: stateValue,
                        city: cityValue,
                        companyName: vendor.companyName,
                        primaryContactName:
                            "${vendor.primaryContact.firstName} ${vendor.primaryContact.lastName}",
                        mobileCode: vendor.mobileCode,
                        phoneNumber: validPhoneNumber,
                        emailAddress: vendor.emailAddress,
                      ),
                      GapSpace.height20,
                      customExpandableSection(context,
                          isContentTypeString: false,
                          title: AppText.billingAdrs,
                          contentWidget:
                              vendorAddressDetailWidget(vendor.billingAddress),
                          isPrefixIconNeeded: true,
                          prefixImg: AppImages.locationPin),
                      GapSpace.height20,
                      customExpandableSection(context,
                          isContentTypeString: false,
                          title: AppText.shippingAdrs,
                          contentWidget:
                              vendorAddressDetailWidget(vendor.shippingAddress),
                          isPrefixIconNeeded: true,
                          prefixImg: AppImages.locationPin),
                      GapSpace.height20,
                      customExpandableSection(
                        context,
                        isContentTypeString: false,
                        title: AppText.primaryContct,
                        contentWidget: primaryContactVendorWidget(
                          vendor.primaryContact,
                          urlLauncher,
                          vendor.emailAddress,
                          validPhoneNumber,
                          vendor.mobileCode,
                          () => urlLauncher.makePhoneCall(validPhoneNumber),
                          () => urlLauncher.sendEmail(vendor.emailAddress),
                          () => urlLauncher.sendSms(validPhoneNumber),
                        ),
                        isPrefixIconNeeded: false,
                      ),
                      GapSpace.height20,
                      customExpandableSection(
                        context,
                        isContentTypeString: true,
                        title: AppText.regionDetails,
                        content: vendor.billingAddress.countryRegion,
                        isPrefixIconNeeded: false,
                      ),
                      GapSpace.height20,
                      customExpandableSection(
                        context,
                        title: AppText.otherDetails,
                        isContentTypeString: false,
                        contentWidget: vendorDetailsContent(
                          partyType: vendor.partyType,
                        ),
                        isPrefixIconNeeded: false,
                      ),
                      GapSpace.height40,
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.appMainColor,
              ),
            ),
            error: (error, stackTrace) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    "Error loading vendor details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(error.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref
                        .refresh(getVendorDetailsProvider(widget.partyId ?? 1)),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//           child: vendorDetailsAsync.when(
//             data: (vndrData) {
//               print(
//                   'Vendor details data received: ${data.response.totalRecord} records');
//               final vndrData = data;
//               final vendorsDetails = data.response.response;
//               if (vendorsDetails.isEmpty) {
//                 return noVendorDetailFoundPage(context: context);
//                 // const Center(
//                 //   child: Column(
//                 //     mainAxisAlignment: MainAxisAlignment.center,
//                 //     children: [
//                 //       Icon(Icons.warning_amber_rounded,
//                 //           size: 48, color: Colors.amber),
//                 //       SizedBox(height: 16),
//                 //       Text(
//                 //         "No vendor details found",
//                 //         style: TextStyle(
//                 //             fontSize: 18, fontWeight: FontWeight.bold),
//                 //       ),
//                 //       SizedBox(height: 8),
//                 //       Text("Please try again or contact support"),
//                 //     ],
//                 //   ),
//                 // );
//               }

//               final vendor = vendorsDetails[0];
//               print('Displaying details for vendor: ${vendor.companyName}');

//               String stateValue = vendor.billingAddress.state;
//               String cityValue = vendor.billingAddress.city;

//               if (stateValue.length > 6) {
//                 stateValue = stateValue.substring(0, 6);
//               }

//               if (cityValue.length > 6) {
//                 cityValue = cityValue.substring(0, 6);
//               }
//               viewPartyAsync.whenData((data) {
//                 debugPrint("Transaction - view party : ${data.transactionId} ");
//               });

//               return SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 24, right: 24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       headerTextAndWidgets(
//                           headerText1: vendor.companyName,
//                           headerText2: vendor.emailAddress,
//                           imgName1: AppText.call,
//                           imgName2: AppText.mail,
//                           imgName3: AppText.msg,
//                           imgName4: AppText.more,
//                           img1: AppImages.call,
//                           img2: AppImages.mail,
//                           img3: AppImages.msg,
//                           img4: AppImages.more,
//                           isMailNeeded: true,
//                           isCallNeeded: true,
//                           callOnTap: () => urlLauncher.makePhoneCall(
//                               vendor.phone?.toString() ??
//                                   vendor.mobile?.toString() ??
//                                   AppText.vendorContact),
//                           mailOnTap: () =>
//                               urlLauncher.sendEmail(vendor.emailAddress),
//                           msgOnTap: () => urlLauncher.sendSms(
//                               vendor.phone?.toString() ??
//                                   vendor.mobile?.toString() ??
//                                   AppText.vendorContact),
//                           moreOnTap: () {},
//                           isMoreNeeded: false),
//                       GapSpace.height35,
//                       financialCard(
//                         state: stateValue,
//                         city: cityValue,
//                         companyName: vendor.companyName,
//                         primaryContactName:
//                             "${vendor.primaryContact.firstName} ${vendor.primaryContact.lastName}",
//                         mobileCode: vendor.mobileCode,
//                         phoneNumber: vendor.mobile.toString() ?? "N/A",
//                         emailAddress: vendor.emailAddress,
//                       ),
//                       GapSpace.height20,
//                       customExpandableSection(context,
//                           isContentTypeString: false,
//                           title: AppText.billingAdrs,
//                           contentWidget:
//                               vendorAddressDetailWidget(vendor.billingAddress),
//                           isPrefixIconNeeded: true,
//                           prefixImg: AppImages.locationPin),
//                       GapSpace.height20,
//                       customExpandableSection(context,
//                           isContentTypeString: false,
//                           title: AppText.shippingAdrs,
//                           contentWidget:
//                               vendorAddressDetailWidget(vendor.shippingAddress),
//                           isPrefixIconNeeded: true,
//                           prefixImg: AppImages.locationPin),
//                       GapSpace.height20,
//                       customExpandableSection(
//                         context,
//                         isContentTypeString: false,
//                         title: AppText.primaryContct,
//                         contentWidget: primaryContactVendorWidget(
//                           vendor.primaryContact,
//                           urlLauncher,
//                           vendor.emailAddress,
//                           vendor.mobile.toString(),
//                           vendor.mobileCode,
//                           () => urlLauncher.makePhoneCall(
//                               vendor.phone?.toString() ??
//                                   vendor.mobile?.toString() ??
//                                   AppText.vendorContact),
//                           () => urlLauncher.sendEmail(vendor.emailAddress),
//                           () => urlLauncher.sendSms(vendor.phone?.toString() ??
//                               vendor.mobile?.toString() ??
//                               AppText.vendorContact),
//                         ),
//                         isPrefixIconNeeded: false,
//                       ),
//                       GapSpace.height20,
//                       customExpandableSection(
//                         context,
//                         isContentTypeString: true,
//                         title: AppText.regionDetails,
//                         content: vendor.billingAddress.countryRegion,
//                         isPrefixIconNeeded: false,
//                       ),
//                       GapSpace.height20,
//                       customExpandableSection(
//                         context,
//                         title: AppText.otherDetails,
//                         isContentTypeString: false,
//                         contentWidget: vendorDetailsContent(
//                           // partyId: vendor.partyId,
//                           partyType: vendor.partyType,
//                           // transactionId:
//                           //     vndrData.transactionId ?? "TXN :0000007"
//                         ),
//                         isPrefixIconNeeded: false,
//                       ),
//                       GapSpace.height40,
//                     ],
//                   ),
//                 ),
//               );
//             },
//             loading: () => const Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.appMainColor,
//               ),
//             ),
//             error: (error, stackTrace) => Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Icon(Icons.error_outline, size: 48, color: Colors.red),
//                   const SizedBox(height: 16),
//                   const Text(
//                     "Error loading vendor details",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(error.toString(), textAlign: TextAlign.center),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () =>
//                         ref.refresh(getVendorDetailsProvider(partyId ?? 1)),
//                     child: const Text("Retry"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
