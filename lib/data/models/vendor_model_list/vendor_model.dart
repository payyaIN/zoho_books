import 'dart:convert';

class VendorModel {
  final bool error;
  final String? errorMsg;
  final String? successMsg;
  final ResponseData response;
  final bool status;
  final String transactionId;

  VendorModel({
    required this.error,
    this.errorMsg,
    this.successMsg,
    required this.response,
    required this.status,
    required this.transactionId,
  });

  factory VendorModel.fromJson(String str) =>
      VendorModel.fromMap(json.decode(str));

  factory VendorModel.fromMap(Map<String, dynamic> json) {
    print('VendorModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    if (json["response"] != null &&
        json["response"] is Map &&
        json["response"].containsKey("response")) {
      print('Processing vendor list response format');
      final responseData = json["response"] as Map<String, dynamic>;

      return VendorModel(
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

      return VendorModel(
        error: json["error"] ?? false,
        errorMsg: json["errorMsg"],
        successMsg: json["successMsg"],
        response: ResponseData.fromMap(normalizedResponse),
        status: json["status"] ?? false,
        transactionId: json["transactionId"] ?? "",
      );
    } else {
      print('Unexpected response format, returning empty vendor model');
      return VendorModel(
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
  final List<Vendor> response;
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

    final vendorList = <Vendor>[];
    for (var i = 0; i < vendorDataList.length; i++) {
      try {
        if (vendorDataList[i] is Map) {
          final vendorMap = Map<String, dynamic>.from(vendorDataList[i] as Map);
          final vendor = Vendor.fromMap(vendorMap);
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

class Vendor {
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
  final String? vatNumber;
  final String? crNum;
  final String? companyNameArabic;
  final PrimaryContactArabic? primaryContactArabic;

  Vendor({
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
    this.vatNumber,
    this.crNum,
    this.companyNameArabic,
    this.primaryContactArabic,
  });

  factory Vendor.empty() => Vendor(
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

  factory Vendor.fromMap(Map<String, dynamic> json) {
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
    PrimaryContactArabic? primaryContactArabic;
    if (json["primaryContactArabic"] != null &&
        json["primaryContactArabic"] is Map) {
      primaryContactArabic = PrimaryContactArabic.fromMap(
          Map<String, dynamic>.from(json["primaryContactArabic"] as Map));
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

    return Vendor(
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
      vatNumber: json["vatNumber"],
      crNum: json["crNum"],
      companyNameArabic: json["companyNameArabic"],
      primaryContactArabic: primaryContactArabic,
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

class Address {
  final String zipCode;
  final String? streetName;
  final String? streetAddress;
  final String city;
  final String countryRegion;
  final String buildingNumber;
  final String? countryName;
  final String state;
  final String? streetAddressArabic;
  final String? cityArabic;

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
// import 'dart:convert';
// import 'dart:math' show min;

// class VendorModel {
//   final bool error;
//   final String? errorMsg;
//   final String? successMsg;
//   final ResponseData response;
//   final bool status;
//   final String transactionId;

//   VendorModel({
//     required this.error,
//     this.errorMsg,
//     this.successMsg,
//     required this.response,
//     required this.status,
//     required this.transactionId,
//   });

//   factory VendorModel.fromJson(String str) =>
//       VendorModel.fromMap(json.decode(str));

//   factory VendorModel.fromMap(Map<String, dynamic> json) {
//     print('VendorModel.fromMap - Processing response');
//     print('Top level keys: ${json.keys.join(", ")}');

//     try {
//       final bool hasError = json["error"] == true;
//       final String? errorMsg = json["errorMsg"];

//       if (hasError && errorMsg != null) {
//         print('API returned error: $errorMsg');
//         return VendorModel(
//           error: true,
//           errorMsg: errorMsg,
//           response: ResponseData(response: [], totalRecord: 0),
//           status: json["status"] ?? false,
//           transactionId: json["transactionId"] ?? "",
//         );
//       }

//       if (json["response"] != null) {
//         if (json["response"] is Map &&
//             json["response"].containsKey("response") &&
//             json["response"]["response"] is List) {
//           print('Processing standard vendor list response format');
//           final responseData = json["response"] as Map<String, dynamic>;

//           return VendorModel(
//             error: json["error"] ?? false,
//             errorMsg: json["errorMsg"],
//             successMsg: json["successMsg"],
//             response: ResponseData.fromMap(responseData),
//             status: json["status"] ?? false,
//             transactionId: json["transactionId"] ?? "",
//           );
//         } else if (json["response"] is Map) {
//           print('Processing vendor detail response format');
//           final vendorDetail = json["response"] as Map<String, dynamic>;

//           if (vendorDetail.containsKey("partyId")) {
//             print('Found direct vendor object in response');
//             final normalizedResponse = {
//               "response": [vendorDetail],
//               "totalRecord": 1
//             };

//             return VendorModel(
//               error: json["error"] ?? false,
//               errorMsg: json["errorMsg"],
//               successMsg: json["successMsg"],
//               response: ResponseData.fromMap(normalizedResponse),
//               status: json["status"] ?? false,
//               transactionId: json["transactionId"] ?? "",
//             );
//           }

//           if (vendorDetail.containsKey("response") &&
//               vendorDetail["response"] is List) {
//             print('Found vendor list in response object');
//             return VendorModel(
//               error: json["error"] ?? false,
//               errorMsg: json["errorMsg"],
//               successMsg: json["successMsg"],
//               response: ResponseData.fromMap(vendorDetail),
//               status: json["status"] ?? false,
//               transactionId: json["transactionId"] ?? "",
//             );
//           }
//         } else if (json["response"] is List) {
//           print('Processing direct vendor array response');
//           final vendorList = json["response"] as List;
//           final normalizedResponse = {
//             "response": vendorList,
//             "totalRecord": vendorList.length
//           };

//           return VendorModel(
//             error: json["error"] ?? false,
//             errorMsg: json["errorMsg"],
//             successMsg: json["successMsg"],
//             response: ResponseData.fromMap(normalizedResponse),
//             status: json["status"] ?? false,
//             transactionId: json["transactionId"] ?? "",
//           );
//         }
//       }

//       print('Unexpected response format, returning empty vendor model');
//       final previewContent = json.toString();
//       print(
//           'Response preview: ${previewContent.substring(0, min(300, previewContent.length))}...');

//       return VendorModel(
//         error: true,
//         errorMsg: json["errorMsg"] ??
//             "Invalid response format - cannot parse vendor data",
//         successMsg: json["successMsg"],
//         response: ResponseData(response: [], totalRecord: 0),
//         status: json["status"] ?? false,
//         transactionId: json["transactionId"] ?? "",
//       );
//     } catch (e, stackTrace) {
//       print('Exception in VendorModel.fromMap: $e');
//       print('Stack trace: $stackTrace');

//       return VendorModel(
//         error: true,
//         errorMsg: "Error parsing vendor data: $e",
//         response: ResponseData(response: [], totalRecord: 0),
//         status: false,
//         transactionId: json["transactionId"] ?? "",
//       );
//     }
//   }
// }

// class ResponseData {
//   final List<Vendor> response;
//   final int totalRecord;

//   ResponseData({required this.response, required this.totalRecord});

//   factory ResponseData.fromMap(Map<String, dynamic> json) {
//     print('ResponseData.fromMap - Processing response data');
//     print('Keys in response data: ${json.keys.join(", ")}');

//     List<dynamic> vendorDataList = [];

//     if (json.containsKey("response")) {
//       if (json["response"] is List) {
//         vendorDataList = json["response"] as List;
//         print('Found ${vendorDataList.length} vendors in response');
//       } else {
//         print('Warning: "response" is not a List');
//         print('Response type: ${json["response"].runtimeType}');
//         if (json["response"] is Map) {
//           vendorDataList = [json["response"]];
//           print('Converted single vendor map to list with 1 item');
//         }
//       }
//     } else {
//       print('Warning: No "response" key found');
//     }

//     final vendorList = <Vendor>[];
//     for (var i = 0; i < vendorDataList.length; i++) {
//       try {
//         if (vendorDataList[i] is Map) {
//           final vendorMap = Map<String, dynamic>.from(vendorDataList[i] as Map);
//           final vendor = Vendor.fromMap(vendorMap);
//           print(
//               'Processed vendor ${i + 1}: ${vendor.companyName} (ID: ${vendor.partyId})');
//           vendorList.add(vendor);
//         } else {
//           print(
//               'Warning: Item at index $i is not a Map: ${vendorDataList[i].runtimeType}');
//         }
//       } catch (e, stackTrace) {
//         print('Error processing vendor at index $i: $e');
//         print('Vendor data: ${vendorDataList[i]}');
//         print('Stack trace: $stackTrace');
//       }
//     }

//     final totalRecord = json["totalRecord"] ?? vendorList.length;

//     print(
//         'Final vendor count: ${vendorList.length}, totalRecord: $totalRecord');

//     return ResponseData(
//       response: vendorList,
//       totalRecord: totalRecord,
//     );
//   }
// }

// class Vendor {
//   final String emailAddress;
//   final String mobileCode;
//   final int? phone;
//   final String displayName;
//   final PrimaryContact primaryContact;
//   final String companyName;
//   final int? mobile;
//   final String? phoneCode;
//   final Address shippingAddress;
//   final Address billingAddress;
//   final int partyId;
//   final String partyType;

//   Vendor({
//     required this.emailAddress,
//     required this.mobileCode,
//     this.phone,
//     required this.displayName,
//     required this.primaryContact,
//     required this.companyName,
//     this.mobile,
//     this.phoneCode,
//     required this.shippingAddress,
//     required this.billingAddress,
//     required this.partyId,
//     required this.partyType,
//   });

//   factory Vendor.empty() => Vendor(
//         emailAddress: "",
//         mobileCode: "",
//         displayName: "",
//         primaryContact: PrimaryContact.empty(),
//         companyName: "",
//         shippingAddress: Address.empty(),
//         billingAddress: Address.empty(),
//         partyId: 0,
//         partyType: "",
//       );

//   factory Vendor.fromMap(Map<String, dynamic> json) {
//     try {
//       print('Vendor.fromMap - Processing vendor with ID: ${json["partyId"]}');

//       Map<String, dynamic> primaryContactMap = {};
//       if (json["primaryContact"] != null) {
//         if (json["primaryContact"] is Map) {
//           primaryContactMap =
//               Map<String, dynamic>.from(json["primaryContact"] as Map);
//         } else {
//           print('Warning: primaryContact is not a Map');
//         }
//       }

//       Map<String, dynamic> shippingAddressMap = {};
//       if (json["shippingAddress"] != null) {
//         if (json["shippingAddress"] is Map) {
//           shippingAddressMap =
//               Map<String, dynamic>.from(json["shippingAddress"] as Map);
//         } else {
//           print('Warning: shippingAddress is not a Map');
//         }
//       }

//       Map<String, dynamic> billingAddressMap = {};
//       if (json["billingAddress"] != null) {
//         if (json["billingAddress"] is Map) {
//           billingAddressMap =
//               Map<String, dynamic>.from(json["billingAddress"] as Map);
//         } else {
//           print('Warning: billingAddress is not a Map');
//         }
//       }

//       final partyId = json["partyId"] != null
//           ? (json["partyId"] is int
//               ? json["partyId"]
//               : int.tryParse(json["partyId"].toString()) ?? 0)
//           : 0;

//       final phone = json["phone"] != null
//           ? (json["phone"] is int
//               ? json["phone"]
//               : int.tryParse(json["phone"].toString()))
//           : null;

//       final mobile = json["mobile"] != null
//           ? (json["mobile"] is int
//               ? json["mobile"]
//               : int.tryParse(json["mobile"].toString()))
//           : null;

//       return Vendor(
//         emailAddress: json["emailAddress"] ?? "",
//         mobileCode: json["mobileCode"] ?? "",
//         phone: phone,
//         displayName: json["displayName"] ?? "",
//         primaryContact: PrimaryContact.fromMap(primaryContactMap),
//         companyName: json["companyName"] ?? "",
//         mobile: mobile,
//         phoneCode: json["phoneCode"],
//         shippingAddress: Address.fromMap(shippingAddressMap),
//         billingAddress: Address.fromMap(billingAddressMap),
//         partyId: partyId,
//         partyType: json["partyType"] ?? "",
//       );
//     } catch (e, stackTrace) {
//       print('Error in Vendor.fromMap: $e');
//       print('JSON: $json');
//       print('Stack trace: $stackTrace');

//       return Vendor.empty();
//     }
//   }
// }

// class PrimaryContact {
//   final String firstName;
//   final String lastName;
//   final String? salutation;

//   PrimaryContact({
//     required this.firstName,
//     required this.lastName,
//     this.salutation,
//   });

//   factory PrimaryContact.empty() => PrimaryContact(
//         firstName: "",
//         lastName: "",
//       );

//   factory PrimaryContact.fromMap(Map<String, dynamic> json) => PrimaryContact(
//         firstName: json["firstName"] ?? "",
//         lastName: json["lastName"] ?? "",
//         salutation: json["salutation"],
//       );
// }

// class Address {
//   final String zipCode;
//   final String? streetName;
//   final String? streetAddress;
//   final String city;
//   final String countryRegion;
//   final String buildingNumber;
//   final String? countryName;
//   final String state;

//   Address({
//     required this.zipCode,
//     this.streetName,
//     this.streetAddress,
//     required this.city,
//     required this.countryRegion,
//     required this.buildingNumber,
//     this.countryName,
//     required this.state,
//   });

//   factory Address.empty() => Address(
//         zipCode: "",
//         city: "",
//         countryRegion: "",
//         buildingNumber: "",
//         state: "",
//       );

//   factory Address.fromMap(Map<String, dynamic> json) => Address(
//         zipCode: json["zipCode"] ?? "",
//         streetName: json["streetName"],
//         streetAddress: json["streetAddress"],
//         city: json["city"] ?? "",
//         countryRegion: json["countryRegion"] ?? "",
//         buildingNumber: json["buildingNumber"] ?? "",
//         countryName: json["countryName"],
//         state: json["state"] ?? "",
//       );
// }
