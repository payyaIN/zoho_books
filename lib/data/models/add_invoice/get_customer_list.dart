// models/get_customer_list.dart

class GetCustomerList {
  GetCustomerList({
    this.error,
    this.errorMsg,
    this.successMsg,
    this.response,
    this.status,
    this.transactionId,
  });

  factory GetCustomerList.fromJson(Map<String, dynamic> json) => GetCustomerList(
    error: json['error'] as bool?,
    errorMsg: json['errorMsg'],
    successMsg: json['successMsg'],
    response: json['response'] != null
        ? ResponseWrapper.fromJson(json['response'] as Map<String, dynamic>)
        : null,
    status: json['status'] as bool?,
    transactionId: json['transactionId'] as String?,
  );

  bool? error;
  dynamic errorMsg;
  dynamic successMsg;
  ResponseWrapper? response;
  bool? status;
  String? transactionId;

  GetCustomerList copyWith({
    bool? error,
    dynamic errorMsg,
    dynamic successMsg,
    ResponseWrapper? response,
    bool? status,
    String? transactionId,
  }) =>
      GetCustomerList(
        error: error ?? this.error,
        errorMsg: errorMsg ?? this.errorMsg,
        successMsg: successMsg ?? this.successMsg,
        response: response ?? this.response,
        status: status ?? this.status,
        transactionId: transactionId ?? this.transactionId,
      );

  Map<String, dynamic> toJson() => {
    'error': error,
    'errorMsg': errorMsg,
    'successMsg': successMsg,
    if (response != null) 'response': response!.toJson(),
    'status': status,
    'transactionId': transactionId,
  };
}

/// Represents the object under "response" in the top-level JSON:
/// {
///   "response": [ ...customers... ],
///   "totalRecord": 9
/// }
class ResponseWrapper {
  ResponseWrapper({
    this.response,
    this.totalRecord,
  });

  factory ResponseWrapper.fromJson(Map<String, dynamic> json) => ResponseWrapper(
    response: json['response'] != null
        ? (json['response'] as List)
        .map((e) => Customer.fromJson(e as Map<String, dynamic>))
        .toList()
        : <Customer>[],
    totalRecord: json['totalRecord'] is int
        ? json['totalRecord'] as int
        : (json['totalRecord'] is num ? (json['totalRecord'] as num).toInt() : null),
  );

  List<Customer>? response;
  int? totalRecord;

  ResponseWrapper copyWith({
    List<Customer>? response,
    int? totalRecord,
  }) =>
      ResponseWrapper(
        response: response ?? this.response,
        totalRecord: totalRecord ?? this.totalRecord,
      );

  Map<String, dynamic> toJson() => {
    'response': response?.map((e) => e.toJson()).toList(),
    'totalRecord': totalRecord,
  };
}

/// Single customer entry
class Customer {
  Customer({
    this.mobileCode,
    this.displayName,
    this.companyName,
    this.mobile,
    this.partyType,
    this.emailAddress,
    this.phone,
    this.primaryContact,
    this.phoneCode,
    this.shippingAddress,
    this.currency,
    this.billingAddress,
    this.partyId,
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    mobileCode: json['mobileCode'] as String?,
    displayName: json['displayName'] as String?,
    companyName: json['companyName'] as String?,
    mobile: json['mobile'], // numeric or null => keep as dynamic
    partyType: json['partyType'] as String?,
    emailAddress: json['emailAddress'] as String?,
    phone: json['phone'], // numeric or null
    primaryContact: json['primaryContact'] != null
        ? PrimaryContact.fromJson(json['primaryContact'] as Map<String, dynamic>)
        : null,
    phoneCode: json['phoneCode'] as String?,
    shippingAddress: json['shippingAddress'] != null
        ? Address.fromJson(json['shippingAddress'] as Map<String, dynamic>)
        : null,
    currency: json['currency'] as String?,
    billingAddress: json['billingAddress'] != null
        ? Address.fromJson(json['billingAddress'] as Map<String, dynamic>)
        : null,
    partyId: json['partyId'] is int
        ? json['partyId'] as int
        : (json['partyId'] is num ? (json['partyId'] as num).toInt() : null),
  );

  String? mobileCode;
  String? displayName;
  String? companyName;
  dynamic mobile;
  String? partyType;
  String? emailAddress;
  dynamic phone;
  PrimaryContact? primaryContact;
  String? phoneCode;
  Address? shippingAddress;
  String? currency;
  Address? billingAddress;
  int? partyId;

  Customer copyWith({
    String? mobileCode,
    String? displayName,
    String? companyName,
    dynamic mobile,
    String? partyType,
    String? emailAddress,
    dynamic phone,
    PrimaryContact? primaryContact,
    String? phoneCode,
    Address? shippingAddress,
    String? currency,
    Address? billingAddress,
    int? partyId,
  }) =>
      Customer(
        mobileCode: mobileCode ?? this.mobileCode,
        displayName: displayName ?? this.displayName,
        companyName: companyName ?? this.companyName,
        mobile: mobile ?? this.mobile,
        partyType: partyType ?? this.partyType,
        emailAddress: emailAddress ?? this.emailAddress,
        phone: phone ?? this.phone,
        primaryContact: primaryContact ?? this.primaryContact,
        phoneCode: phoneCode ?? this.phoneCode,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        currency: currency ?? this.currency,
        billingAddress: billingAddress ?? this.billingAddress,
        partyId: partyId ?? this.partyId,
      );

  Map<String, dynamic> toJson() => {
    'mobileCode': mobileCode,
    'displayName': displayName,
    'companyName': companyName,
    'mobile': mobile,
    'partyType': partyType,
    'emailAddress': emailAddress,
    'phone': phone,
    if (primaryContact != null) 'primaryContact': primaryContact!.toJson(),
    'phoneCode': phoneCode,
    if (shippingAddress != null) 'shippingAddress': shippingAddress!.toJson(),
    'currency': currency,
    if (billingAddress != null) 'billingAddress': billingAddress!.toJson(),
    'partyId': partyId,
  };
}

/// Shared address structure used for shippingAddress and billingAddress
class Address {
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
    streetAddress: json['streetAddress'] as String?,
    city: json['city'] as String?,
    countryRegion: json['countryRegion'] as String?,
    buildingNumber: json['buildingNumber'],
    countryName: json['countryName'] as String?,
    state: json['state'] as String?,
  );

  dynamic zipCode;
  dynamic streetName;
  String? streetAddress;
  String? city;
  String? countryRegion;
  dynamic buildingNumber;
  String? countryName;
  String? state;

  Address copyWith({
    dynamic zipCode,
    dynamic streetName,
    String? streetAddress,
    String? city,
    String? countryRegion,
    dynamic buildingNumber,
    String? countryName,
    String? state,
  }) =>
      Address(
        zipCode: zipCode ?? this.zipCode,
        streetName: streetName ?? this.streetName,
        streetAddress: streetAddress ?? this.streetAddress,
        city: city ?? this.city,
        countryRegion: countryRegion ?? this.countryRegion,
        buildingNumber: buildingNumber ?? this.buildingNumber,
        countryName: countryName ?? this.countryName,
        state: state ?? this.state,
      );

  Map<String, dynamic> toJson() => {
    'zipCode': zipCode,
    'streetName': streetName,
    'streetAddress': streetAddress,
    'city': city,
    'countryRegion': countryRegion,
    'buildingNumber': buildingNumber,
    'countryName': countryName,
    'state': state,
  };
}

class PrimaryContact {
  PrimaryContact({
    this.firstName,
    this.lastName,
    this.salutation,
  });

  factory PrimaryContact.fromJson(Map<String, dynamic> json) => PrimaryContact(
    firstName: json['firstName'] as String?,
    lastName: json['lastName'] as String?,
    salutation: json['salutation'],
  );

  String? firstName;
  String? lastName;
  dynamic salutation;

  PrimaryContact copyWith({
    String? firstName,
    String? lastName,
    dynamic salutation,
  }) =>
      PrimaryContact(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        salutation: salutation ?? this.salutation,
      );

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'salutation': salutation,
  };
}
