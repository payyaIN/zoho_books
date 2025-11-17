import 'package:payzo_books/data/models/vendor_model_list/vendor_model.dart';
import 'package:payzo_books/import_data.dart';

Row primaryContactContent(WidgetRef ref) {
  final phoneLauncher = ref.read(phoneLauncherProvider);
  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ReusableText(
            text: AppText.vendorName,
            fontWeight: FontWeight.w400,
            fontFamily: 'SF Pro Display',
            fontSize: 12,
          ),
          GapSpace.height10,
          ReusableText(
            text: AppText.vendorMail,
            fontWeight: FontWeight.w400,
            fontFamily: 'SF Pro Display',
            fontSize: 12,
          ),
          GapSpace.height10,
          ReusableText(
            text: AppText.vendorContact,
            fontWeight: FontWeight.w400,
            fontFamily: 'SF Pro Display',
            fontSize: 12,
          ),
        ],
      ),
      boxIconWithOutLabel(
          callOnTap: () => phoneLauncher.makePhoneCall(AppText.vendorContact),
          mailOnTap: () {},
          msgOnTap: () {})
    ],
  );
}

Widget textRowData({
  required String leftText,
  required String rightText,
  bool? isTextUnderLine,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ReusableText(
            text: leftText,
            fontWeight: FontWeight.w400,
            fontFamily: 'SF Pro Display',
            fontSize: 14,
            color: AppColors.loginTextColor,
          ),
          ReusableText(
            text: rightText,
            fontWeight: FontWeight.w500,
            fontFamily: 'SF Pro Display',
            fontSize: 14,
            decoration:
                isTextUnderLine == true ? TextDecoration.underline : null,
            decorationColor:
                isTextUnderLine == true ? AppColors.appMainColor : null,
            color: isTextUnderLine == true
                ? AppColors.appMainColor
                : AppColors.loginTextColor,
          ),
        ],
      ),
      GapSpace.height15
    ],
  );
}

Column vendorDetailsContent({
  // required int partyId,
  required String partyType,
  // required String transactionId,
}) {
  return Column(
    children: [
      // textRowData(leftText: AppText.currencyCode, rightText: AppText.sar),
      // textRowData(leftText: AppText.partyId, rightText: '$partyId'),
      textRowData(leftText: AppText.partyType, rightText: partyType),
      // textRowData(leftText: AppText.transactionId, rightText: transactionId),
    ],
  );
}

Widget vendorAddressDetailWidget(Address address) {
  return Column(
    children: [
      // textRowData(leftText: 'Country Region', rightText: address.countryRegion),
      // textRowData(leftText: 'State', rightText: address.state),
      // textRowData(
      //   leftText: 'City',
      //   rightText: address.city,
      // ),
      // textRowData(
      //   leftText: 'Zipcode',
      //   rightText: address.zipCode,
      // ),
      // textRowData(
      //   leftText: 'Building Number',
      //   rightText: address.buildingNumber,
      // ),
      // textRowData(
      //   leftText: 'Street Address',
      //   rightText: address.streetAddress ?? 'N/A',
      // ),
      textRowData(
        leftText: 'Street Address',
        rightText: address.streetAddress ?? 'N/A',
      ),
      textRowData(
        leftText: 'Building Number',
        rightText: address.buildingNumber,
      ),
      textRowData(
        leftText: 'City',
        rightText: address.city,
      ),
      textRowData(leftText: 'State', rightText: address.state),
      textRowData(
        leftText: 'Zipcode',
        rightText: address.zipCode,
      ),
      textRowData(leftText: 'Country Region', rightText: address.countryRegion),
    ],
  );
}

Widget primaryContactVendorWidget(
  PrimaryContact contact,
  PhoneLauncher launcher,
  String vendorEmail,
  String vendorContact,
  String countryCode,
  VoidCallback callOnTap,
  VoidCallback mailOnTap,
  VoidCallback msgOnTap,
) {
  final fullName =
      "${contact.salutation ?? ''} ${contact.firstName} ${contact.lastName}"
          .trim();

  return Row(
    crossAxisAlignment: CrossAxisAlignment.end,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          textRowData(
            leftText: 'Full Name : ',
            rightText: fullName,
          ),
          textRowData(
            leftText: 'Email : ',
            rightText: vendorEmail,
          ),
          textRowData(
            leftText: 'Phone : ',
            rightText: '$countryCode $vendorContact',
          ),
        ],
      ),
      boxIconWithOutLabel(
          callOnTap: callOnTap, mailOnTap: mailOnTap, msgOnTap: msgOnTap)
    ],
  );
}
