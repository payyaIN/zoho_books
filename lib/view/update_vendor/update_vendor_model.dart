import 'dart:convert';

class UpdateVendorModel {
  final bool error;
  final String? errorMsg;
  final String? successMsg;
  final ResponseData response;
  final bool status;
  final String transactionId;

  UpdateVendorModel({
    required this.error,
    this.errorMsg,
    this.successMsg,
    required this.response,
    required this.status,
    required this.transactionId,
  });

  factory UpdateVendorModel.fromJson(String str) =>
      UpdateVendorModel.fromMap(json.decode(str));

  factory UpdateVendorModel.fromMap(Map<String, dynamic> json) {
    print('VendorModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    if (json["response"] != null &&
        json["response"] is Map &&
        json["response"].containsKey("response")) {
      print('Processing vendor list response format');
      final responseData = json["response"] as Map<String, dynamic>;

      return UpdateVendorModel(
        error: json["error"] ?? false,
        errorMsg: json["errorMsg"],
        successMsg: json["successMsg"],
        response: ResponseData.fromMap(responseData),
        status: json["status"] ?? false,
        transactionId: json["transactionId"] ?? "",
      );
    } else if (json["response"] != null && json["response"] is Map) {
      print('Processing vendor detail response format');
      final vendorDetail = json["response"] as Map<String, dynamic>;

      final normalizedResponse = {
        "response": [vendorDetail],
        "totalRecord": 1
      };

      return UpdateVendorModel(
        error: json["error"] ?? false,
        errorMsg: json["errorMsg"],
        successMsg: json["successMsg"],
        response: ResponseData.fromMap(normalizedResponse),
        status: json["status"] ?? false,
        transactionId: json["transactionId"] ?? "",
      );
    } else {
      print('Unexpected response format, returning empty vendor model');
      return UpdateVendorModel(
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
  final List<UpdateVendor> response;
  final int totalRecord;

  ResponseData({required this.response, required this.totalRecord});

  factory ResponseData.fromMap(Map<String, dynamic> json) {
    print('ResponseData.fromMap - Processing response data');
    print('Keys in response data: ${json.keys.join(", ")}');

    List<dynamic> vendorDataList = [];

    if (json.containsKey("response")) {
      if (json["response"] is List) {
        vendorDataList = json["response"] as List;
        print('Found ${vendorDataList.length} vendors in response');
      } else {
        print('Warning: "response" is not a List');
      }
    } else {
      print('Warning: No "response" key found');
    }

    final vendorList = <UpdateVendor>[];
    for (var i = 0; i < vendorDataList.length; i++) {
      try {
        if (vendorDataList[i] is Map) {
          final vendorMap = Map<String, dynamic>.from(vendorDataList[i] as Map);
          final vendor = UpdateVendor.fromMap(vendorMap);
          print(
              'Processed vendor ${i + 1}: ${vendor.companyName} (ID: ${vendor.partyId})');
          vendorList.add(vendor);
        } else {
          print('Warning: Item at index $i is not a Map');
        }
      } catch (e) {
        print('Error processing vendor at index $i: $e');
      }
    }

    final totalRecord = json["totalRecord"] ?? vendorList.length;

    print(
        'Final vendor count: ${vendorList.length}, totalRecord: $totalRecord');

    return ResponseData(
      response: vendorList,
      totalRecord: totalRecord,
    );
  }
}

class UpdateVendor {
  final String emailAddress;
  final String mobileCode;
  final int? phone;
  final String displayName;
  final PrimaryContact primaryContact;
  final PrimaryContactArabic? primaryContactArabic;
  final String? companyNameArabic;
  final String companyName;
  final int? mobile;
  final String? phoneCode;
  final Address shippingAddress;
  final Address billingAddress;
  final int partyId;
  final String partyType;
  final String? vatNumber;
  final String? crNum;
  final String? customerType;

  UpdateVendor({
    required this.emailAddress,
    required this.mobileCode,
    this.phone,
    required this.displayName,
    required this.primaryContact,
    this.primaryContactArabic,
    this.companyNameArabic,
    required this.companyName,
    this.mobile,
    this.phoneCode,
    required this.shippingAddress,
    required this.billingAddress,
    required this.partyId,
    required this.partyType,
    this.vatNumber,
    this.crNum,
    this.customerType,
  });

  factory UpdateVendor.empty() => UpdateVendor(
        emailAddress: "",
        mobileCode: "",
        displayName: "",
        primaryContact: PrimaryContact.empty(),
        primaryContactArabic: PrimaryContactArabic.empty(),
        companyNameArabic: '',
        companyName: "",
        shippingAddress: Address.empty(),
        billingAddress: Address.empty(),
        partyId: 0,
        partyType: "",
        vatNumber: '',
        crNum: '',
        customerType: '',
      );

  factory UpdateVendor.fromMap(Map<String, dynamic> json) {
    print('Vendor.fromMap - Processing vendor with ID: ${json["partyId"]}');

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
    Map<String, dynamic> primaryContactArabicMap = {};
    if (json["primaryContactArabic"] != null &&
        json["primaryContactArabic"] is Map) {
      primaryContactArabicMap =
          Map<String, dynamic>.from(json["primaryContactArabic"] as Map);
    }

    final primaryContactArabic =
        PrimaryContactArabic.fromMap(primaryContactArabicMap);

    final companyNameArabic = json['companyNameArabic'] ?? '';

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

    final vatNumber = json['vatNumber']?.toString();
    final crNum = json['crNum']?.toString();
    final customerType = json['customerType']?.toString();

    return UpdateVendor(
      emailAddress: json["emailAddress"] ?? "",
      mobileCode: json["mobileCode"] ?? "",
      phone: phone,
      displayName: json["displayName"] ?? "",
      primaryContact: PrimaryContact.fromMap(primaryContactMap),
      primaryContactArabic: primaryContactArabic,
      companyNameArabic: companyNameArabic,
      companyName: json["companyName"] ?? "",
      mobile: mobile,
      phoneCode: json["phoneCode"],
      shippingAddress: Address.fromMap(shippingAddressMap),
      billingAddress: Address.fromMap(billingAddressMap),
      partyId: partyId,
      partyType: json["partyType"] ?? "",
      vatNumber: vatNumber,
      crNum: crNum,
      customerType: customerType,
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

class PrimaryContactArabic {
  final String? firstNameArabic;
  final String? lastNameArabic;

  PrimaryContactArabic({this.firstNameArabic, this.lastNameArabic});

  factory PrimaryContactArabic.fromMap(Map<String, dynamic>? json) {
    if (json == null) return PrimaryContactArabic();
    return PrimaryContactArabic(
      firstNameArabic: json['firstNameArabic'] ?? '',
      lastNameArabic: json['lastNameArabic'] ?? '',
    );
  }

  factory PrimaryContactArabic.empty() => PrimaryContactArabic(
        firstNameArabic: '',
        lastNameArabic: '',
      );
}

class Address {
  final String zipCode;
  final String? streetName;
  final String? streetAddress;
  final String city;
  final String? streetAddressArabic;

  final String? cityArabic;
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
    this.streetAddressArabic,
    this.cityArabic,
  });

  factory Address.empty() => Address(
        zipCode: "",
        city: "",
        countryRegion: "",
        buildingNumber: "",
        state: "",
        streetAddressArabic: '',
        cityArabic: '',
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
        streetAddressArabic: json["streetAddressArabic"],
        cityArabic: json["cityArabic"],
      );
}
