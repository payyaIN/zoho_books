class GetUserDetails {
  GetUserDetails({
      this.error, 
      this.message, 
      this.response, 
      this.status,});

  GetUserDetails.fromJson(dynamic json) {
    error = json['error'];
    message = json['message'];
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
    status = json['status'];
  }
  bool? error;
  String? message;
  Response? response;
  bool? status;
GetUserDetails copyWith({  bool? error,
  String? message,
  Response? response,
  bool? status,
}) => GetUserDetails(  error: error ?? this.error,
  message: message ?? this.message,
  response: response ?? this.response,
  status: status ?? this.status,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = error;
    map['message'] = message;
    if (response != null) {
      map['response'] = response?.toJson();
    }
    map['status'] = status;
    return map;
  }

}

class Response {
  Response({
      this.companyCr, 
      this.groupId, 
      this.profilePic, 
      this.fullName, 
      this.emailId, 
      this.employeeId, 
      this.userName, 
      this.countryFlagClass, 
      this.userId, 
      this.countryId, 
      this.countryPhoneCode, 
      this.tenantId, 
      this.contactNumber, 
      this.regexForCountry, 
      this.currencyId, 
      this.onboardingFlag,});

  Response.fromJson(dynamic json) {
    companyCr = json['companyCr'];
    groupId = json['groupId'];
    profilePic = json['profilePic'];
    fullName = json['fullName'];
    emailId = json['emailId'];
    employeeId = json['employeeId'];
    userName = json['userName'];
    countryFlagClass = json['countryFlagClass'];
    userId = json['userId'];
    countryId = json['countryId'];
    countryPhoneCode = json['countryPhoneCode'];
    tenantId = json['tenantId'];
    contactNumber = json['contactNumber'];
    regexForCountry = json['regexForCountry'];
    currencyId = json['currencyId'];
    onboardingFlag = json['onboarding_flag'];
  }
  String? companyCr;
  String? groupId;
  dynamic profilePic;
  String? fullName;
  String? emailId;
  String? employeeId;
  String? userName;
  String? countryFlagClass;
  String? userId;
  num? countryId;
  String? countryPhoneCode;
  String? tenantId;
  String? contactNumber;
  String? regexForCountry;
  num? currencyId;
  bool? onboardingFlag;
Response copyWith({  String? companyCr,
  String? groupId,
  dynamic profilePic,
  String? fullName,
  String? emailId,
  String? employeeId,
  String? userName,
  String? countryFlagClass,
  String? userId,
  num? countryId,
  String? countryPhoneCode,
  String? tenantId,
  String? contactNumber,
  String? regexForCountry,
  num? currencyId,
  bool? onboardingFlag,
}) => Response(  companyCr: companyCr ?? this.companyCr,
  groupId: groupId ?? this.groupId,
  profilePic: profilePic ?? this.profilePic,
  fullName: fullName ?? this.fullName,
  emailId: emailId ?? this.emailId,
  employeeId: employeeId ?? this.employeeId,
  userName: userName ?? this.userName,
  countryFlagClass: countryFlagClass ?? this.countryFlagClass,
  userId: userId ?? this.userId,
  countryId: countryId ?? this.countryId,
  countryPhoneCode: countryPhoneCode ?? this.countryPhoneCode,
  tenantId: tenantId ?? this.tenantId,
  contactNumber: contactNumber ?? this.contactNumber,
  regexForCountry: regexForCountry ?? this.regexForCountry,
  currencyId: currencyId ?? this.currencyId,
  onboardingFlag: onboardingFlag ?? this.onboardingFlag,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['companyCr'] = companyCr;
    map['groupId'] = groupId;
    map['profilePic'] = profilePic;
    map['fullName'] = fullName;
    map['emailId'] = emailId;
    map['employeeId'] = employeeId;
    map['userName'] = userName;
    map['countryFlagClass'] = countryFlagClass;
    map['userId'] = userId;
    map['countryId'] = countryId;
    map['countryPhoneCode'] = countryPhoneCode;
    map['tenantId'] = tenantId;
    map['contactNumber'] = contactNumber;
    map['regexForCountry'] = regexForCountry;
    map['currencyId'] = currencyId;
    map['onboarding_flag'] = onboardingFlag;
    return map;
  }

}