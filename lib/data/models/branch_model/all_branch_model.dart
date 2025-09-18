import 'dart:convert';

class GetAllBranchListModel {
  final List<Branch> data;
  final int count;
  final String message;
  final String status;

  GetAllBranchListModel({
    required this.data,
    required this.count,
    required this.message,
    required this.status,
  });

  factory GetAllBranchListModel.fromJson(String str) =>
      GetAllBranchListModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory GetAllBranchListModel.fromMap(Map<String, dynamic> json) {
    print('GetAllBranchListModel.fromMap - Processing response');
    print('Top level keys: ${json.keys.join(", ")}');

    List<dynamic> branchList = [];

    if (json.containsKey("data")) {
      if (json["data"] is List) {
        branchList = json["data"] as List;
        print('Found ${branchList.length} branches in response');
      } else {
        print('Warning: "data" is not a List');
      }
    } else {
      print('Warning: No "data" key found');
    }

    return GetAllBranchListModel(
      data: List<Branch>.from(branchList.map((x) {
        if (x is Map) {
          return Branch.fromMap(Map<String, dynamic>.from(x));
        } else {
          print('Warning: Branch item is not a Map');
          return Branch.empty();
        }
      })),
      count: json["count"] ?? 0,
      message: json["message"] ?? "",
      status: json["status"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "count": count,
        "message": message,
        "status": status,
      };

  factory GetAllBranchListModel.empty() => GetAllBranchListModel(
        data: [],
        count: 0,
        message: "",
        status: "",
      );
}

class Branch {
  final int branchId;
  final DateTime createdAt;
  final String nameSecondary;
  final String? websiteUrl;
  final PrimaryContact primaryContact;
  final String addressDetails;
  final String? logoUrl;
  final String namePrimary;
  final int addressId;
  final DateTime updatedAt;

  Branch({
    required this.branchId,
    required this.createdAt,
    required this.nameSecondary,
    this.websiteUrl,
    required this.primaryContact,
    required this.addressDetails,
    this.logoUrl,
    required this.namePrimary,
    required this.addressId,
    required this.updatedAt,
  });

  factory Branch.fromJson(String str) => Branch.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Branch.fromMap(Map<String, dynamic> json) {
    return Branch(
      branchId: json["branchId"] ?? 0,
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
      nameSecondary: json["nameSecondary"] ?? "",
      websiteUrl: json["websiteUrl"],
      primaryContact: json["primaryContact"] != null
          ? PrimaryContact.fromMap(json["primaryContact"])
          : PrimaryContact.empty(),
      addressDetails: json["addressDetails"] ?? "",
      logoUrl: json["logoUrl"],
      namePrimary: json["namePrimary"] ?? "",
      addressId: json["addressId"] ?? 0,
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
        "branchId": branchId,
        "createdAt": createdAt.toIso8601String(),
        "nameSecondary": nameSecondary,
        "websiteUrl": websiteUrl,
        "primaryContact": primaryContact.toMap(),
        "addressDetails": addressDetails,
        "logoUrl": logoUrl,
        "namePrimary": namePrimary,
        "addressId": addressId,
        "updatedAt": updatedAt.toIso8601String(),
      };

  factory Branch.empty() => Branch(
        branchId: 0,
        createdAt: DateTime.now(),
        nameSecondary: "",
        websiteUrl: null,
        primaryContact: PrimaryContact.empty(),
        addressDetails: "",
        logoUrl: null,
        namePrimary: "",
        addressId: 0,
        updatedAt: DateTime.now(),
      );
}

class PrimaryContact {
  final String userId;
  final dynamic companyCr;
  final String userName;
  final String password;
  final dynamic level0;
  final String emailId;
  final String cellNo;
  final dynamic sysDate;
  final dynamic createdTime;
  final dynamic modifiedTime;
  final dynamic logTime;
  final dynamic numAttempt;
  final dynamic accountStatus;
  final dynamic passwordDate;
  final dynamic alertQueue;
  final dynamic alertHvl;
  final dynamic alertSys;
  final dynamic alertRej;
  final dynamic userType;
  final dynamic thrLimit;
  final dynamic userLimit;
  final dynamic createdBy;
  final dynamic modifiedBy;
  final String status;
  final dynamic listCount;
  final dynamic userCategory;
  final dynamic phyImage;
  final dynamic loginStatus;
  final dynamic userLng;
  final dynamic passExpire;
  final dynamic profilePicture;
  final dynamic idNumber;
  final dynamic expiryDate;
  final dynamic tokenGenTime;
  final dynamic token;
  final String groupId;
  final dynamic designation;
  final String tenantId;
  final int department;
  final bool isActive;
  final bool allowPortal;
  final String firstName;
  final dynamic middleName;
  final dynamic lastName;
  final bool onboardingFlag;
  final bool enabled;
  final String countryPhoneCode;
  final int companyId;

  PrimaryContact({
    required this.userId,
    this.companyCr,
    required this.userName,
    required this.password,
    this.level0,
    required this.emailId,
    required this.cellNo,
    this.sysDate,
    this.createdTime,
    this.modifiedTime,
    this.logTime,
    this.numAttempt,
    this.accountStatus,
    this.passwordDate,
    this.alertQueue,
    this.alertHvl,
    this.alertSys,
    this.alertRej,
    this.userType,
    this.thrLimit,
    this.userLimit,
    this.createdBy,
    this.modifiedBy,
    required this.status,
    this.listCount,
    this.userCategory,
    this.phyImage,
    this.loginStatus,
    this.userLng,
    this.passExpire,
    this.profilePicture,
    this.idNumber,
    this.expiryDate,
    this.tokenGenTime,
    this.token,
    required this.groupId,
    this.designation,
    required this.tenantId,
    required this.department,
    required this.isActive,
    required this.allowPortal,
    required this.firstName,
    this.middleName,
    this.lastName,
    required this.onboardingFlag,
    required this.enabled,
    required this.countryPhoneCode,
    required this.companyId,
  });

  factory PrimaryContact.fromJson(String str) =>
      PrimaryContact.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PrimaryContact.fromMap(Map<String, dynamic> json) {
    return PrimaryContact(
      userId: json["userId"] ?? "",
      companyCr: json["companyCr"],
      userName: json["userName"] ?? "",
      password: json["password"] ?? "",
      level0: json["level0"],
      emailId: json["emailId"] ?? "",
      cellNo: json["cellNo"] ?? "",
      sysDate: json["sysDate"],
      createdTime: json["createdTime"],
      modifiedTime: json["modifiedTime"],
      logTime: json["logTime"],
      numAttempt: json["numAttempt"],
      accountStatus: json["accountStatus"],
      passwordDate: json["passwordDate"],
      alertQueue: json["alertQueue"],
      alertHvl: json["alertHvl"],
      alertSys: json["alertSys"],
      alertRej: json["alertRej"],
      userType: json["userType"],
      thrLimit: json["thrLimit"],
      userLimit: json["userLimit"],
      createdBy: json["createdBy"],
      modifiedBy: json["modifiedBy"],
      status: json["status"] ?? "",
      listCount: json["listCount"],
      userCategory: json["userCategory"],
      phyImage: json["phyImage"],
      loginStatus: json["loginStatus"],
      userLng: json["userLng"],
      passExpire: json["passExpire"],
      profilePicture: json["profilePicture"],
      idNumber: json["idNumber"],
      expiryDate: json["expiryDate"],
      tokenGenTime: json["tokenGenTime"],
      token: json["token"],
      groupId: json["groupId"] ?? "",
      designation: json["designation"],
      tenantId: json["tenantId"] ?? "",
      department: json["department"] ?? 0,
      isActive: json["isActive"] ?? false,
      allowPortal: json["allowPortal"] ?? false,
      firstName: json["firstName"] ?? "",
      middleName: json["middleName"],
      lastName: json["lastName"],
      onboardingFlag: json["onboardingFlag"] ?? false,
      enabled: json["enabled"] ?? false,
      countryPhoneCode: json["countryPhoneCode"] ?? "",
      companyId: json["companyId"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "userId": userId,
        "companyCr": companyCr,
        "userName": userName,
        "password": password,
        "level0": level0,
        "emailId": emailId,
        "cellNo": cellNo,
        "sysDate": sysDate,
        "createdTime": createdTime,
        "modifiedTime": modifiedTime,
        "logTime": logTime,
        "numAttempt": numAttempt,
        "accountStatus": accountStatus,
        "passwordDate": passwordDate,
        "alertQueue": alertQueue,
        "alertHvl": alertHvl,
        "alertSys": alertSys,
        "alertRej": alertRej,
        "userType": userType,
        "thrLimit": thrLimit,
        "userLimit": userLimit,
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "status": status,
        "listCount": listCount,
        "userCategory": userCategory,
        "phyImage": phyImage,
        "loginStatus": loginStatus,
        "userLng": userLng,
        "passExpire": passExpire,
        "profilePicture": profilePicture,
        "idNumber": idNumber,
        "expiryDate": expiryDate,
        "tokenGenTime": tokenGenTime,
        "token": token,
        "groupId": groupId,
        "designation": designation,
        "tenantId": tenantId,
        "department": department,
        "isActive": isActive,
        "allowPortal": allowPortal,
        "firstName": firstName,
        "middleName": middleName,
        "lastName": lastName,
        "onboardingFlag": onboardingFlag,
        "enabled": enabled,
        "countryPhoneCode": countryPhoneCode,
        "companyId": companyId,
      };

  factory PrimaryContact.empty() => PrimaryContact(
        userId: "",
        userName: "",
        password: "",
        emailId: "",
        cellNo: "",
        status: "",
        groupId: "",
        tenantId: "",
        department: 0,
        isActive: false,
        allowPortal: false,
        firstName: "",
        onboardingFlag: false,
        enabled: false,
        countryPhoneCode: "",
        companyId: 0,
      );
}
