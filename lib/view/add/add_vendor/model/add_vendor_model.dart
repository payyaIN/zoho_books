class AddVendorModel {
  final String salutation;
  final String firstName;
  final String firstNameArabic;
  final String secondName;
  final String secondNameArabic;
  final String companyName;
  final String companyNameArabic;
  final String email;
  final String mobile;
  final String workPhone;
  final String phoneCode;
  final String mobileCode;
  final String customerType;
  final String partyType;
  final String vatNumber;
  final String crNum;
  final String displayName;

  final Map<String, dynamic> openingBalance;
  final Map<String, dynamic> documents;
  final Map<String, dynamic> remark;
  final Map<String, dynamic> customFields;
  final Map<String, dynamic> reportingTag;

  final List<Map<String, dynamic>> contactPersons;
  final bool sameAddressFlag;

  final Map<String, dynamic> billingAddress;
  final Map<String, dynamic> shippingAddress;

  final Map<String, String> errors;

  AddVendorModel({
    required this.salutation,
    required this.firstName,
    required this.firstNameArabic,
    required this.secondName,
    required this.secondNameArabic,
    required this.companyName,
    required this.companyNameArabic,
    required this.email,
    required this.mobile,
    required this.workPhone,
    required this.phoneCode,
    required this.mobileCode,
    required this.customerType,
    required this.partyType,
    required this.vatNumber,
    required this.crNum,
    required this.displayName,
    required this.openingBalance,
    required this.documents,
    required this.remark,
    required this.customFields,
    required this.reportingTag,
    required this.contactPersons,
    required this.sameAddressFlag,
    required this.billingAddress,
    required this.shippingAddress,
    this.errors = const {},
  });

  AddVendorModel copyWith({
    String? salutation,
    String? firstName,
    String? firstNameArabic,
    String? secondName,
    String? secondNameArabic,
    String? companyName,
    String? companyNameArabic,
    String? email,
    String? mobile,
    String? workPhone,
    String? phoneCode,
    String? mobileCode,
    String? customerType,
    String? partyType,
    String? vatNumber,
    String? crNum,
    String? displayName,
    Map<String, dynamic>? openingBalance,
    Map<String, dynamic>? documents,
    Map<String, dynamic>? remark,
    Map<String, dynamic>? customFields,
    Map<String, dynamic>? reportingTag,
    List<Map<String, dynamic>>? contactPersons,
    bool? sameAddressFlag,
    Map<String, dynamic>? billingAddress,
    Map<String, dynamic>? shippingAddress,
    Map<String, String>? errors,
  }) {
    return AddVendorModel(
      salutation: salutation ?? this.salutation,
      firstName: firstName ?? this.firstName,
      firstNameArabic: firstNameArabic ?? this.firstNameArabic,
      secondName: secondName ?? this.secondName,
      secondNameArabic: secondNameArabic ?? this.secondNameArabic,
      companyName: companyName ?? this.companyName,
      companyNameArabic: companyNameArabic ?? this.companyNameArabic,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      workPhone: workPhone ?? this.workPhone,
      phoneCode: phoneCode ?? this.phoneCode,
      mobileCode: mobileCode ?? this.mobileCode,
      customerType: customerType ?? this.customerType,
      partyType: partyType ?? this.partyType,
      vatNumber: vatNumber ?? this.vatNumber,
      crNum: crNum ?? this.crNum,
      displayName: displayName ?? this.displayName,
      openingBalance: openingBalance ?? this.openingBalance,
      documents: documents ?? this.documents,
      remark: remark ?? this.remark,
      customFields: customFields ?? this.customFields,
      reportingTag: reportingTag ?? this.reportingTag,
      contactPersons: contactPersons ?? this.contactPersons,
      sameAddressFlag: sameAddressFlag ?? this.sameAddressFlag,
      billingAddress: billingAddress ?? this.billingAddress,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      errors: errors ?? this.errors,
    );
  }

  Map<String, dynamic> toJson() => {
    "primaryContact": {
      "firstName": firstName,
      "lastName": secondName,
    },
    "primaryContactArabic": {
      "firstName": firstNameArabic,
      "lastName": secondNameArabic,
    },
    "customerType": customerType,
    "partyType": partyType,
    "companyName": companyName,
    "displayName": displayName,
    "emailAddress": email,
    "phoneCode": phoneCode,
    "phone": int.tryParse(workPhone) ?? '',
    "mobileCode": mobileCode,
    "mobile": int.tryParse(mobile) ?? '',
    "openingBalance": openingBalance,
    "vatNumber": vatNumber,
    "crNum": crNum,
    "documents": documents,
    "remark": remark,
    "customFields": customFields,
    "reportingTag": reportingTag,
    "billingAddress": {
      "countryRegion": billingAddress["countryRegion"] ?? '',
      "buildingNumber": billingAddress["building"] ?? '',
      "streetName": billingAddress["streetName"] ?? null,
      "streetAddress": billingAddress["streetAddress"] ?? '',
      "city": billingAddress["city"] ?? '',
      "state": billingAddress["state"] ?? '',
      "stateId": billingAddress["stateId"] ?? '',
      "zipCode": billingAddress["zip"] ?? '',
    },
    "shippingAddress": {
      "countryRegion": shippingAddress["countryRegion"] ?? '',
      "buildingNumber": shippingAddress["building"] ?? '',
      "streetName": shippingAddress["streetName"] ?? null,
      "streetAddress": shippingAddress["streetAddress"] ?? '',
      "city": shippingAddress["city"] ?? '',
      "state": shippingAddress["state"] ?? '',
      "stateId": shippingAddress["stateId"] ?? '',
      "zipCode": shippingAddress["zip"] ?? '',
    },
    "contactPersons": contactPersons,
    "sameAddressFlag": sameAddressFlag,
  };
}
