import 'dart:convert';

class CustomerModel {
  final bool error;
  final String? errorMsg;
  final String? successMsg;
  final ResponseData response;
  final bool status;
  final String transactionId;

  CustomerModel({
    required this.error,
    this.errorMsg,
    this.successMsg,
    required this.response,
    required this.status,
    required this.transactionId,
  });

  factory CustomerModel.fromJson(String str) =>
      CustomerModel.fromMap(json.decode(str));

  factory CustomerModel.fromMap(Map<String, dynamic> json) {
    print('CustomerModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    if (json["response"] != null &&
        json["response"] is Map &&
        json["response"].containsKey("response")) {
      print('Processing customer list response format');
      final responseData = json["response"] as Map<String, dynamic>;

      return CustomerModel(
        error: json["error"] ?? false,
        errorMsg: json["errorMsg"],
        successMsg: json["successMsg"],
        response: ResponseData.fromMap(responseData),
        status: json["status"] ?? false,
        transactionId: json["transactionId"] ?? "",
      );
    } else if (json["response"] != null && json["response"] is Map) {
      print('Processing customer detail response format');
      final customerDetail = json["response"] as Map<String, dynamic>;

      final normalizedResponse = {
        "response": [customerDetail],
        "totalRecord": 1
      };

      return CustomerModel(
        error: json["error"] ?? false,
        errorMsg: json["errorMsg"],
        successMsg: json["successMsg"],
        response: ResponseData.fromMap(normalizedResponse),
        status: json["status"] ?? false,
        transactionId: json["transactionId"] ?? "",
      );
    } else {
      print('Unexpected response format, returning empty customer model');
      return CustomerModel(
        error: json["error"] ?? true,
        errorMsg: json["errorMsg"] ?? "Invalid response format",
        successMsg: json["successMsg"],
        response: ResponseData(response: [], totalRecord: 0),
        status: json["status"] ?? false,
        transactionId: json["transactionId"] ?? "",
      );
    }
  }
}

class ResponseData {
  final List<Customer> response;
  final int totalRecord;

  ResponseData({required this.response, required this.totalRecord});

  factory ResponseData.fromMap(Map<String, dynamic> json) {
    print('ResponseData.fromMap - Processing response data');
    print('Keys in response data: ${json.keys.join(", ")}');

    List<dynamic> customerDataList = [];

    if (json.containsKey("response")) {
      if (json["response"] is List) {
        customerDataList = json["response"] as List;
        print('Found ${customerDataList.length} customers in response');
      } else {
        print('Warning: "response" is not a List');
      }
    } else {
      print('Warning: No "response" key found');
    }

    final customerList = <Customer>[];
    for (var i = 0; i < customerDataList.length; i++) {
      try {
        if (customerDataList[i] is Map) {
          final customerMap =
              Map<String, dynamic>.from(customerDataList[i] as Map);
          final customer = Customer.fromMap(customerMap);
          print(
              'Processed customer ${i + 1}: ${customer.companyName} (ID: ${customer.partyId})');
          customerList.add(customer);
        } else {
          print('Warning: Item at index $i is not a Map');
        }
      } catch (e) {
        print('Error processing customer at index $i: $e');
      }
    }

    final totalRecord = json["totalRecord"] ?? customerList.length;

    print(
        'Final customer count: ${customerList.length}, totalRecord: $totalRecord');

    return ResponseData(
      response: customerList,
      totalRecord: totalRecord,
    );
  }
}

class Customer {
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

  Customer({
    required this.emailAddress,
    required this.mobileCode,
    this.phone,
    required this.displayName,
    required this.primaryContact,
    required this.companyName,
    this.mobile,
    this.phoneCode,
    required this.shippingAddress,
    required this.billingAddress,
    required this.partyId,
    required this.partyType,
  });

  factory Customer.empty() => Customer(
        emailAddress: "",
        mobileCode: "",
        displayName: "",
        primaryContact: PrimaryContact.empty(),
        companyName: "",
        shippingAddress: Address.empty(),
        billingAddress: Address.empty(),
        partyId: 0,
        partyType: "",
      );

  factory Customer.fromMap(Map<String, dynamic> json) {
    print('Customer.fromMap - Processing customer with ID: ${json["partyId"]}');

    Map<String, dynamic> primaryContactMap = {};
    if (json["primaryContact"] != null) {
      if (json["primaryContact"] is Map) {
        primaryContactMap =
            Map<String, dynamic>.from(json["primaryContact"] as Map);
      } else {
        print('Warning: primaryContact is not a Map');
      }
    }

    Map<String, dynamic> shippingAddressMap = {};
    if (json["shippingAddress"] != null) {
      if (json["shippingAddress"] is Map) {
        shippingAddressMap =
            Map<String, dynamic>.from(json["shippingAddress"] as Map);
      } else {
        print('Warning: shippingAddress is not a Map');
      }
    }

    Map<String, dynamic> billingAddressMap = {};
    if (json["billingAddress"] != null) {
      if (json["billingAddress"] is Map) {
        billingAddressMap =
            Map<String, dynamic>.from(json["billingAddress"] as Map);
      } else {
        print('Warning: billingAddress is not a Map');
      }
    }

    final partyId = json["partyId"] != null
        ? (json["partyId"] is int
            ? json["partyId"]
            : int.tryParse(json["partyId"].toString()) ?? 0)
        : 0;
    final phone = json["phone"] != null
        ? (json["phone"] is int
            ? json["phone"]
            : int.tryParse(json["phone"].toString()))
        : null;

    final mobile = json["mobile"] != null
        ? (json["mobile"] is int
            ? json["mobile"]
            : int.tryParse(json["mobile"].toString()))
        : null;

    return Customer(
      emailAddress: json["emailAddress"] ?? "",
      mobileCode: json["mobileCode"] ?? "",
      phone: phone,
      displayName: json["displayName"] ?? "",
      primaryContact: PrimaryContact.fromMap(primaryContactMap),
      companyName: json["companyName"] ?? "",
      mobile: mobile,
      phoneCode: json["phoneCode"],
      shippingAddress: Address.fromMap(shippingAddressMap),
      billingAddress: Address.fromMap(billingAddressMap),
      partyId: partyId,
      partyType: json["partyType"] ?? "",
    );
  }
}

class PrimaryContact {
  final String firstName;
  final String lastName;
  final String? salutation;

  PrimaryContact({
    required this.firstName,
    required this.lastName,
    this.salutation,
  });

  factory PrimaryContact.empty() => PrimaryContact(
        firstName: "",
        lastName: "",
      );

  factory PrimaryContact.fromMap(Map<String, dynamic> json) => PrimaryContact(
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        salutation: json["salutation"],
      );
}

class Address {
  final String zipCode;
  final String? streetName;
  final String? streetAddress;
  final String city;
  final String countryRegion;
  final String buildingNumber;
  final String? countryName;
  final String state;

  Address({
    required this.zipCode,
    this.streetName,
    this.streetAddress,
    required this.city,
    required this.countryRegion,
    required this.buildingNumber,
    this.countryName,
    required this.state,
  });

  factory Address.empty() => Address(
        zipCode: "",
        city: "",
        countryRegion: "",
        buildingNumber: "",
        state: "",
      );

  factory Address.fromMap(Map<String, dynamic> json) => Address(
        zipCode: json["zipCode"] ?? "",
        streetName: json["streetName"],
        streetAddress: json["streetAddress"],
        city: json["city"] ?? "",
        countryRegion: json["countryRegion"] ?? "",
        buildingNumber: json["buildingNumber"] ?? "",
        countryName: json["countryName"],
        state: json["state"] ?? "",
      );
}
