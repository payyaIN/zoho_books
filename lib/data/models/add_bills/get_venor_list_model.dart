class VendorListResponse {
  final bool? error;
  final String? errorMsg;
  final String? successMsg;
  final VendorListData? response;
  final bool? status;
  final String? transactionId;

  VendorListResponse({
    this.error,
    this.errorMsg,
    this.successMsg,
    this.response,
    this.status,
    this.transactionId,
  });

  factory VendorListResponse.fromJson(Map<String, dynamic> json) => VendorListResponse(
    error: json['error'],
    errorMsg: json['errorMsg'],
    successMsg: json['successMsg'],
    response: json['response'] != null ? VendorListData.fromJson(json['response']) : null,
    status: json['status'],
    transactionId: json['transactionId'],
  );
}

class VendorListData {
  final List<VendorData>? response;
  final int? totalRecord;

  VendorListData({this.response, this.totalRecord});

  factory VendorListData.fromJson(Map<String, dynamic> json) => VendorListData(
    response: (json['response'] as List<dynamic>?)
        ?.map((e) => VendorData.fromJson(e))
        .toList(),
    totalRecord: json['totalRecord'],
  );
}

class VendorData {
  final String? emailAddress;
  final String? mobileCode;
  final int? phone;
  final String? displayName;
  final PrimaryContact? primaryContact;
  final String? companyName;
  final int? mobile;
  final String? phoneCode;
  final Address? shippingAddress;
  final Address? billingAddress;
  final int? partyId;
  final String? partyType;

  VendorData({
    this.emailAddress,
    this.mobileCode,
    this.phone,
    this.displayName,
    this.primaryContact,
    this.companyName,
    this.mobile,
    this.phoneCode,
    this.shippingAddress,
    this.billingAddress,
    this.partyId,
    this.partyType,
  });

  factory VendorData.fromJson(Map<String, dynamic> json) => VendorData(
    emailAddress: json['emailAddress'],
    mobileCode: json['mobileCode'],
    phone: json['phone'],
    displayName: json['displayName'],
    primaryContact: json['primaryContact'] != null
        ? PrimaryContact.fromJson(json['primaryContact'])
        : null,
    companyName: json['companyName'],
    mobile: json['mobile'],
    phoneCode: json['phoneCode'],
    shippingAddress: json['shippingAddress'] != null
        ? Address.fromJson(json['shippingAddress'])
        : null,
    billingAddress: json['billingAddress'] != null
        ? Address.fromJson(json['billingAddress'])
        : null,
    partyId: json['partyId'],
    partyType: json['partyType'],
  );
}

class PrimaryContact {
  final String? firstName;
  final String? lastName;
  final String? salutation;

  PrimaryContact({this.firstName, this.lastName, this.salutation});

  factory PrimaryContact.fromJson(Map<String, dynamic> json) => PrimaryContact(
    firstName: json['firstName'],
    lastName: json['lastName'],
    salutation: json['salutation'],
  );
}

class Address {
  final String? zipCode;
  final String? streetName;
  final String? streetAddress;
  final String? city;
  final String? countryRegion;
  final String? buildingNumber;
  final String? countryName;
  final String? state;

  Address({
    this.zipCode,
    this.streetName,
    this.streetAddress,
    this.city,
    this.countryRegion,
    this.buildingNumber,
    this.countryName,
    this.state,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    zipCode: json['zipCode'],
    streetName: json['streetName'],
    streetAddress: json['streetAddress'],
    city: json['city'],
    countryRegion: json['countryRegion'],
    buildingNumber: json['buildingNumber'],
    countryName: json['countryName'],
    state: json['state'],
  );
}