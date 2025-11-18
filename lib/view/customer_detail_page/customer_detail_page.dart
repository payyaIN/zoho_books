import 'package:payzo_books/data/repository/customer_details/customer_detail_api.dart';
import 'package:payzo_books/data/repository/document_type/get_doc_type_api.dart';
import 'package:payzo_books/data/repository/event_api/get_event_api.dart';
import 'package:payzo_books/data/repository/price_currency/price_currency_api.dart';
import 'package:payzo_books/data/repository/view_party/view_party_api.dart';
import 'package:payzo_books/import_data.dart';
import 'package:payzo_books/view/customer_detail_page/components/customer_detail_content.dart';
import 'package:payzo_books/view/customer_detail_page/provider/country_list_provider.dart';

class CustomerDetailPage extends ConsumerWidget {
  final int? partyId;
  const CustomerDetailPage({Key? key, this.partyId}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectivePartyId = partyId ?? 1;
    final urlLauncher = ref.read(phoneLauncherProvider);
    final countryListState = ref.watch(countryListProvider);
    final customerDetailsAsync =
        ref.watch(getCustomerDetailsProvider(effectivePartyId));
    final eventsAsync = ref.watch(eventsProvider);
    final documentTypesAsync = ref.watch(documentTypesProvider);
    final priceCurrenciesAsync = ref.watch(priceCurrenciesProvider);
    final viewPartyAsync = ref.watch(viewPartyProvider(effectivePartyId));
    return ScalingFactor(
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBgColor,
        appBar: reusableAppBar(
            title: 'Customer Details', showBackButton: true, context: context),
        body: RefreshIndicator(
          onRefresh: () =>
              ref.refresh(getCustomerDetailsProvider(effectivePartyId).future),
          child: customerDetailsAsync.when(
            data: (data) {
              final cstmrData = data;
              final customerDetails = data.response.response;
              if (customerDetails.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 48, color: Colors.amber),
                      SizedBox(height: 16),
                      Text(
                        "No customer details found",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text("Please try again or contact support"),
                    ],
                  ),
                );
              }

              final customer = customerDetails[0];
              String stateValue = customer.billingAddress.state;
              String cityValue = customer.billingAddress.city;

              if (stateValue.length > 6) {
                stateValue = stateValue.substring(0, 6);
              }

              if (cityValue.length > 6) {
                cityValue = cityValue.substring(0, 6);
              }
              debugPrint("Transctn Id - customer:${data.transactionId}");
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // headerTextAndWidgets(
                      //   headerText1: customer.companyName,
                      //   headerText2: customer.emailAddress,
                      //   title1: AppText.call,
                      //   title2: AppText.mail,
                      //   title3: AppText.msg,
                      //   title4: AppText.edit,
                      //   title5: AppText.delete,
                      //   img1: AppImages.call,
                      //   img2: AppImages.mail,
                      //   img3: AppImages.msg,
                      //   img4: AppImages.editWhite,
                      //   img5: AppImages.delete,
                      //   isonTap1Needed: true,
                      //   isonTap4Needed: true,
                      //   isonTap2Needed: true,
                      //   isonTap5Needed: true,
                      //   isonTap3Needed: true,
                      //   onTap1: () => urlLauncher.makePhoneCall(
                      //       customer.phone?.toString() ??
                      //           customer.mobile?.toString() ??
                      //           AppText.vendorContact),
                      //   onTap2: () =>
                      //       urlLauncher.sendEmail(customer.emailAddress),
                      //   onTap3: () => urlLauncher.sendSms(
                      //       customer.phone?.toString() ??
                      //           customer.mobile?.toString() ??
                      //           AppText.vendorContact),
                      //   onTap4: () {},
                      //   onTap5: () {},
                      // ),
                      headerTextAndWidgets(
                          headerText1: customer.companyName,
                          headerText2: customer.emailAddress,
                          imgName1: AppText.call,
                          imgName2: AppText.mail,
                          imgName3: AppText.msg,
                          imgName4: AppText.more,
                          img1: AppImages.call,
                          img2: AppImages.mail,
                          img3: AppImages.msg,
                          img4: AppImages.more,
                          isMailNeeded: true,
                          isCallNeeded: true,
                          callOnTap: () => urlLauncher.makePhoneCall(
                              customer.phone?.toString() ??
                                  customer.mobile?.toString() ??
                                  AppText.vendorContact),
                          mailOnTap: () =>
                              urlLauncher.sendEmail(customer.emailAddress),
                          msgOnTap: () => urlLauncher.sendSms(
                              customer.phone?.toString() ??
                                  customer.mobile?.toString() ??
                                  AppText.vendorContact),
                          editOnTap: () {},
                          isEditNeeded: false),
                      GapSpace.height35,
                      financialCard(
                        state: stateValue,
                        city: cityValue,
                        companyName: customer.companyName,
                        primaryContactName:
                            "${customer.primaryContact.firstName} ${customer.primaryContact.lastName}",
                        mobileCode: customer.mobileCode,
                        phoneNumber: customer.phone?.toString() ??
                            customer.mobile?.toString() ??
                            "N/A",
                        emailAddress: customer.emailAddress,
                      ),
                      GapSpace.height20,
                      customExpandableSection(context,
                          isContentTypeString: false,
                          title: AppText.billingAdrs,
                          contentWidget:
                              addressDetailWidget(customer.billingAddress),
                          isPrefixIconNeeded: true,
                          prefixImg: AppImages.locationPin),
                      GapSpace.height20,
                      customExpandableSection(context,
                          isContentTypeString: false,
                          title: AppText.shippingAdrs,
                          contentWidget:
                              addressDetailWidget(customer.shippingAddress),
                          isPrefixIconNeeded: true,
                          prefixImg: AppImages.locationPin),
                      GapSpace.height20,
                      customExpandableSection(
                        context,
                        isContentTypeString: false,
                        title: AppText.primaryContct,
                        contentWidget: primaryContactWidget(
                          customer.primaryContact,
                          customer.companyName,
                          urlLauncher,
                          customer.emailAddress,
                          customer.phone?.toString() ??
                              customer.mobile?.toString() ??
                              AppText.vendorContact,
                          customer.mobileCode,
                          () => urlLauncher.makePhoneCall(
                              customer.phone?.toString() ??
                                  customer.mobile?.toString() ??
                                  AppText.vendorContact),
                          () => urlLauncher.sendEmail(customer.emailAddress),
                          () => urlLauncher.sendSms(
                              customer.phone?.toString() ??
                                  customer.mobile?.toString() ??
                                  AppText.vendorContact),
                        ),
                        isPrefixIconNeeded: false,
                      ),
                      GapSpace.height20,
                      customExpandableSection(
                        context,
                        isContentTypeString: true,
                        title: AppText.regionDetails,
                        content: customer.billingAddress.countryRegion,
                        isPrefixIconNeeded: false,
                      ),
                      GapSpace.height20,

                      // customExpandableSection(
                      //   context,
                      //   title: AppText.otherDetails,
                      //   isContentTypeString: false,
                      //   contentWidget: customerDetailsContent(
                      //     customerType: viewPartyAsync.when(
                      //       data: (data) => data.response.customerType,
                      //       loading: () => "Loading...",
                      //       error: (_, __) => "Not available",
                      //     ),
                      //     partyType: customer.partyType,
                      //     transactionId: data.transactionId,
                      //   ),
                      //   isPrefixIconNeeded: false,
                      // ),
                      customExpandableSection(
                        context,
                        title: AppText.otherDetails,
                        isContentTypeString: false,
                        contentWidget: customerDetailsContent(
                          customerType: viewPartyAsync.when(
                            data: (data) {
                              debugPrint(
                                  "Transctn Id - view party:${data.transactionId}");
                              return data.response.customerType ?? "INDIVIDUAL";
                            },
                            loading: () => "Loading...",
                            error: (_, __) => "Not available",
                          ),
                          partyType: customer.partyType,
                          // transactionId:
                          //     cstmrData.transactionId ?? "TXN-0000000",
                          // transactionId: viewPartyAsync.when(
                          //   data: (data) => data.transactionId ?? "TXN-0000000",
                          //   loading: () => "Loading...",
                          //   error: (_, __) => "Not available",
                          // ),
                        ),
                        isPrefixIconNeeded: false,
                      ),
                      GapSpace.height20,
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
                    "Error loading customer details",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(error.toString(), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        ref.refresh(getCustomerDetailsProvider(partyId ?? 1)),
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
