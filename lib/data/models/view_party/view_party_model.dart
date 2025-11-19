import 'dart:convert';

class ViewPartyModel {
  final bool error;
  final String? errorMsg;
  final String? successMsg;
  final ViewPartyResponseData response;
  final bool status;
  final String transactionId;

  ViewPartyModel({
    required this.error,
    this.errorMsg,
    this.successMsg,
    required this.response,
    required this.status,
    required this.transactionId,
  });

  factory ViewPartyModel.fromJson(String str) =>
      ViewPartyModel.fromMap(json.decode(str));

  factory ViewPartyModel.fromMap(Map<String, dynamic> json) {
    return ViewPartyModel(
      error: json["error"] ?? false,
      errorMsg: json["errorMsg"],
      successMsg: json["successMsg"],
      response: ViewPartyResponseData.fromMap(json["response"] ?? {}),
      status: json["status"] ?? false,
      transactionId: json["transactionId"] ?? "",
    );
  }
}

class ViewPartyResponseData {
  final String mobileCode;
  final Map<String, dynamic> documents;
  final String displayName;
  final Map<String, dynamic> customFields;
  final String companyName;
  final String? companyNameArabic;
  final int mobile;
  final Remark remark;
  final Map<String, dynamic> reportingTag;
  final String partyType;
  final String customerType;
  final String emailAddress;
  final int phone;
  final PrimaryContact primaryContact;
  final PrimaryContactArabic? primaryContactArabic;
  final List<ContactPerson> contactPersons;
  final String phoneCode;
  final Address shippingAddress;
  final Address billingAddress;
  final bool sameAddressFlag;
  final String? vatNumber;
  final String? crNum;

  ViewPartyResponseData({
    required this.mobileCode,
    required this.documents,
    required this.displayName,
    required this.customFields,
    required this.companyName,
    this.companyNameArabic,
    required this.mobile,
    required this.remark,
    required this.reportingTag,
    required this.partyType,
    required this.customerType,
    required this.emailAddress,
    required this.phone,
    required this.primaryContact,
    this.primaryContactArabic,
    required this.contactPersons,
    required this.phoneCode,
    required this.shippingAddress,
    required this.billingAddress,
    required this.sameAddressFlag,
    this.vatNumber,
    this.crNum,
  });

  factory ViewPartyResponseData.fromMap(Map<String, dynamic> json) {
    return ViewPartyResponseData(
      mobileCode: json["mobileCode"] ?? "",
      documents: json["documents"] ?? {},
      displayName: json["displayName"] ?? "",
      customFields: json["customFields"] ?? {},
      companyName: json["companyName"] ?? "",
      companyNameArabic: json["companyNameArabic"],
      mobile: json["mobile"] ?? 0,
      remark: Remark.fromMap(json["remark"] ?? {"remark": ""}),
      reportingTag: json["reportingTag"] ?? {},
      partyType: json["partyType"] ?? "",
      customerType: json["customerType"] ?? "BUSINESS",
      emailAddress: json["emailAddress"] ?? "",
      phone: json["phone"] ?? 0,
      primaryContact: PrimaryContact.fromMap(json["primaryContact"] ?? {}),
      primaryContactArabic: json["primaryContactArabic"] != null
          ? PrimaryContactArabic.fromMap(json["primaryContactArabic"])
          : null,
      contactPersons: json["contactPersons"] != null
          ? List<ContactPerson>.from(
              json["contactPersons"].map((x) => ContactPerson.fromMap(x)))
          : [],
      phoneCode: json["phoneCode"] ?? "",
      shippingAddress: Address.fromMap(json["shippingAddress"] ?? {}),
      billingAddress: Address.fromMap(json["billingAddress"] ?? {}),
      sameAddressFlag: json["sameAddressFlag"] ?? false,
      vatNumber: json["vatNumber"],
      crNum: json["crNum"],
    );
  }
}

class Remark {
  final String remark;

  Remark({
    required this.remark,
  });

  factory Remark.fromMap(Map<String, dynamic> json) {
    return Remark(
      remark: json["remark"] ?? "",
    );
  }
}

class PrimaryContact {
  final String firstName;
  final String lastName;

  PrimaryContact({
    required this.firstName,
    required this.lastName,
  });

  factory PrimaryContact.fromMap(Map<String, dynamic> json) {
    return PrimaryContact(
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
    );
  }
}

class PrimaryContactArabic {
  final String? firstNameArabic;
  final String? lastNameArabic;

  PrimaryContactArabic({
    this.firstNameArabic,
    this.lastNameArabic,
  });

  factory PrimaryContactArabic.fromMap(Map<String, dynamic> json) {
    return PrimaryContactArabic(
      firstNameArabic: json["firstNameArabic"],
      lastNameArabic: json["lastNameArabic"],
    );
  }
}

class ContactPerson {
  final String mobileNo;
  final String events;
  final String lastName;
  final String emailAddress;
  final String firstName;
  final String cpMobCode;

  ContactPerson({
    required this.mobileNo,
    required this.events,
    required this.lastName,
    required this.emailAddress,
    required this.firstName,
    required this.cpMobCode,
  });

  factory ContactPerson.fromMap(Map<String, dynamic> json) {
    return ContactPerson(
      mobileNo: json["mobileNo"] ?? "",
      events: json["events"] ?? "",
      lastName: json["lastName"] ?? "",
      emailAddress: json["emailAddress"] ?? "",
      firstName: json["firstName"] ?? "",
      cpMobCode: json["cpMobCode"] ?? "",
    );
  }
}

class Address {
  final int addressId;
  final int partyId;
  final String addressType;
  final String? attention;
  final String countryRegion;
  final String buildingNumber;
  final String? street;
  final String city;
  final String? cityArabic;
  final String state;
  final String? stateName;
  final String zipCode;
  final String? phone;
  final String? faxNumber;
  final String? streetName;
  final String? streetAddress;
  final String? streetAddressArabic;

  Address({
    required this.addressId,
    required this.partyId,
    required this.addressType,
    this.attention,
    required this.countryRegion,
    required this.buildingNumber,
    this.street,
    required this.city,
    this.cityArabic,
    required this.state,
    this.stateName,
    required this.zipCode,
    this.phone,
    this.faxNumber,
    this.streetName,
    this.streetAddress,
    this.streetAddressArabic,
  });

  factory Address.fromMap(Map<String, dynamic> json) {
    return Address(
      addressId: json["addressId"] ?? 0,
      partyId: json["partyId"] ?? 0,
      addressType: json["addressType"] ?? "",
      attention: json["attention"],
      countryRegion: json["countryRegion"] ?? "",
      buildingNumber: json["buildingNumber"] ?? "",
      street: json["street"],
      city: json["city"] ?? "",
      cityArabic: json["cityArabic"],
      state: json["state"] ?? "",
      stateName: json["stateName"],
      zipCode: json["zipCode"] ?? "",
      phone: json["phone"],
      faxNumber: json["faxNumber"],
      streetName: json["streetName"],
      streetAddress: json["streetAddress"],
      streetAddressArabic: json["streetAddressArabic"],
    );
  }
}
