import 'dart:convert';

class UpdateCustomerModel {
  final bool error;
  final dynamic errorMsg;
  final dynamic successMsg;
  final CustomerListResponse response;
  final bool status;
  final String transactionId;

  UpdateCustomerModel({
    required this.error,
    this.errorMsg,
    this.successMsg,
    required this.response,
    required this.status,
    required this.transactionId,
  });

  factory UpdateCustomerModel.fromJson(String str) =>
      UpdateCustomerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpdateCustomerModel.fromMap(Map<String, dynamic> json) {
    print('GetCustomerListModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    return UpdateCustomerModel(
      error: json["error"] ?? false,
      errorMsg: json["errorMsg"],
      successMsg: json["successMsg"],
      response: json["response"] != null
          ? CustomerListResponse.fromMap(json["response"])
          : CustomerListResponse.empty(),
      status: json["status"] ?? false,
      transactionId: json["transactionId"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "error": error,
        "errorMsg": errorMsg,
        "successMsg": successMsg,
        "response": response.toMap(),
        "status": status,
        "transactionId": transactionId,
      };

  factory UpdateCustomerModel.empty() => UpdateCustomerModel(
        error: false,
        errorMsg: null,
        successMsg: null,
        response: CustomerListResponse.empty(),
        status: false,
        transactionId: "",
      );
}

class CustomerListResponse {
  final List<UpdateCustomer> response;
  final int totalRecord;

  CustomerListResponse({
    required this.response,
    required this.totalRecord,
  });

  factory CustomerListResponse.fromJson(String str) =>
      CustomerListResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CustomerListResponse.fromMap(Map<String, dynamic> json) {
    print('CustomerListResponse.fromMap - Processing response data');

    List<dynamic> customersList = [];

    if (json.containsKey("response")) {
      if (json["response"] is List) {
        customersList = json["response"] as List;
        print('Found ${customersList.length} customers in response');
      } else {
        print('Warning: "response" is not a List');
      }
    } else {
      print('Warning: No "response" key found');
    }

    return CustomerListResponse(
      response: List<UpdateCustomer>.from(customersList.map((x) {
        if (x is Map) {
          return UpdateCustomer.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Customer item is not a Map');
          return UpdateCustomer.empty();
        }
      })),
      totalRecord: json["totalRecord"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "response": List<dynamic>.from(response.map((x) => x.toMap())),
        "totalRecord": totalRecord,
      };

  factory CustomerListResponse.empty() => CustomerListResponse(
        response: [],
        totalRecord: 0,
      );
}

class UpdateCustomer {
  final String emailAddress;
  final String mobileCode;
  final int? phone;
  final String displayName;
  final PrimaryContact primaryContact;
  final String companyName;
  final int? mobile;
  final String? phoneCode;
  final Address shippingAddress;
  final Address billingAddress;
  final int partyId;
  final String partyType;

  UpdateCustomer({
    required this.emailAddress,
    required this.mobileCode,
    required this.phone,
    required this.displayName,
    required this.primaryContact,
    required this.companyName,
    required this.mobile,
    required this.phoneCode,
    required this.shippingAddress,
    required this.billingAddress,
    required this.partyId,
    required this.partyType,
  });

  factory UpdateCustomer.fromJson(String str) =>
      UpdateCustomer.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UpdateCustomer.fromMap(Map<String, dynamic> json) {
    return UpdateCustomer(
      emailAddress: json["emailAddress"] ?? "",
      mobileCode: json["mobileCode"] ?? "",
      phone: json["phone"],
      displayName: json["displayName"] ?? "",
      primaryContact: json["primaryContact"] != null
          ? PrimaryContact.fromMap(json["primaryContact"])
          : PrimaryContact.empty(),
      companyName: json["companyName"] ?? "",
      mobile: json["mobile"],
      phoneCode: json["phoneCode"],
      shippingAddress: json["shippingAddress"] != null
          ? Address.fromMap(json["shippingAddress"])
          : Address.empty(),
      billingAddress: json["billingAddress"] != null
          ? Address.fromMap(json["billingAddress"])
          : Address.empty(),
      partyId: json["partyId"] ?? 0,
      partyType: json["partyType"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "emailAddress": emailAddress,
        "mobileCode": mobileCode,
        "phone": phone,
        "displayName": displayName,
        "primaryContact": primaryContact.toMap(),
        "companyName": companyName,
        "mobile": mobile,
        "phoneCode": phoneCode,
        "shippingAddress": shippingAddress.toMap(),
        "billingAddress": billingAddress.toMap(),
        "partyId": partyId,
        "partyType": partyType,
      };

  factory UpdateCustomer.empty() => UpdateCustomer(
        emailAddress: "",
        mobileCode: "",
        phone: null,
        displayName: "",
        primaryContact: PrimaryContact.empty(),
        companyName: "",
        mobile: null,
        phoneCode: null,
        shippingAddress: Address.empty(),
        billingAddress: Address.empty(),
        partyId: 0,
        partyType: "CUSTOMER",
      );
}

class PrimaryContact {
  final String firstName;
  final String lastName;
  final dynamic salutation;

  PrimaryContact({
    required this.firstName,
    required this.lastName,
    this.salutation,
  });

  factory PrimaryContact.fromJson(String str) =>
      PrimaryContact.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrimaryContact.fromMap(Map<String, dynamic> json) {
    return PrimaryContact(
      firstName: json["firstName"] ?? "",
      lastName: json["lastName"] ?? "",
      salutation: json["salutation"],
    );
  }

  Map<String, dynamic> toMap() => {
        "firstName": firstName,
        "lastName": lastName,
        "salutation": salutation,
      };

  factory PrimaryContact.empty() => PrimaryContact(
        firstName: "",
        lastName: "",
        salutation: null,
      );
}

class Address {
  final String zipCode;
  final String? streetName;
  final String streetAddress;
  final String city;
  final String countryRegion;
  final String buildingNumber;
  final String? countryName;
  final String state;

  Address({
    required this.zipCode,
    this.streetName,
    required this.streetAddress,
    required this.city,
    required this.countryRegion,
    required this.buildingNumber,
    this.countryName,
    required this.state,
  });

  factory Address.fromJson(String str) => Address.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Address.fromMap(Map<String, dynamic> json) {
    return Address(
      zipCode: json["zipCode"] ?? "",
      streetName: json["streetName"],
      streetAddress: json["streetAddress"] ?? "",
      city: json["city"] ?? "",
      countryRegion: json["countryRegion"] ?? "",
      buildingNumber: json["buildingNumber"] ?? "",
      countryName: json["countryName"],
      state: json["state"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "zipCode": zipCode,
        "streetName": streetName,
        "streetAddress": streetAddress,
        "city": city,
        "countryRegion": countryRegion,
        "buildingNumber": buildingNumber,
        "countryName": countryName,
        "state": state,
      };

  factory Address.empty() => Address(
        zipCode: "",
        streetName: null,
        streetAddress: "",
        city: "",
        countryRegion: "",
        buildingNumber: "",
        countryName: null,
        state: "",
      );
}
