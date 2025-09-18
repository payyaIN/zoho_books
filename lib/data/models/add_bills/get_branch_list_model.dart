class BranchListResponse {
  final List<BranchData>? data;
  final int? count;
  final String? message;
  final String? status;

  BranchListResponse({this.data, this.count, this.message, this.status});

  factory BranchListResponse.fromJson(Map<String, dynamic> json) {
    return BranchListResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BranchData.fromJson(e))
          .toList(),
      count: json['count'],
      message: json['message'],
      status: json['status'],
    );
  }
}

class BranchData {
  final int? branchId;
  final String? namePrimary;
  final String? nameSecondary;
  final String? websiteUrl;
  final String? addressDetails;
  final String? logoUrl;
  final int? addressId;
  final String? createdAt;
  final String? updatedAt;
  final PrimaryContact? primaryContact;

  BranchData({
    this.branchId,
    this.namePrimary,
    this.nameSecondary,
    this.websiteUrl,
    this.addressDetails,
    this.logoUrl,
    this.addressId,
    this.createdAt,
    this.updatedAt,
    this.primaryContact,
  });

  factory BranchData.fromJson(Map<String, dynamic> json) {
    return BranchData(
      branchId: json['branchId'],
      namePrimary: json['namePrimary'],
      nameSecondary: json['nameSecondary'],
      websiteUrl: json['websiteUrl'],
      addressDetails: json['addressDetails'],
      logoUrl: json['logoUrl'],
      addressId: json['addressId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      primaryContact: json['primaryContact'] != null
          ? PrimaryContact.fromJson(json['primaryContact'])
          : null,
    );
  }
}

class PrimaryContact {
  final String? userId;
  final String? userName;
  final String? emailId;
  final String? cellNo;
  final String? status;
  final String? groupId;
  final String? tenantId;
  final int? department;
  final bool? isActive;
  final bool? allowPortal;
  final String? firstName;
  final String? lastName;
  final String? countryPhoneCode;

  PrimaryContact({
    this.userId,
    this.userName,
    this.emailId,
    this.cellNo,
    this.status,
    this.groupId,
    this.tenantId,
    this.department,
    this.isActive,
    this.allowPortal,
    this.firstName,
    this.lastName,
    this.countryPhoneCode,
  });

  factory PrimaryContact.fromJson(Map<String, dynamic> json) {
    return PrimaryContact(
      userId: json['userId'],
      userName: json['userName'],
      emailId: json['emailId'],
      cellNo: json['cellNo'],
      status: json['status'],
      groupId: json['groupId'],
      tenantId: json['tenantId'],
      department: json['department'],
      isActive: json['isActive'],
      allowPortal: json['allowPortal'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      countryPhoneCode: json['countryPhoneCode'],
    );
  }
}
