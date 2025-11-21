// add_customer_model.dart
class AddCustomerModel {
  AddCustomerModel({
    this.primaryContact,
    this.primaryContactArabic,
    this.customerType,
    this.partyType,
    this.taxedOrganization,
    this.governmentEntity,
    this.companyName,
    this.companyNameArabic,
    this.displayName,
    this.emailAddress,
    this.phoneCode,
    this.phone,
    this.mobileCode,
    this.mobile,
    this.openingBalance,
    this.vatNumber,
    this.crNum,
    this.documents,
    this.remark,
    this.customFields,
    this.reportingTag,
    this.billingAddress,
    this.shippingAddress,
    this.contactPersons,
    this.sameAddressFlag,
  });

  AddCustomerModel.fromJson(dynamic json) {
    primaryContact = json['primaryContact'] != null
        ? PrimaryContact.fromJson(json['primaryContact'])
        : null;
    primaryContactArabic = json['primaryContactArabic'] != null
        ? PrimaryContactArabic.fromJson(json['primaryContactArabic'])
        : null;
    customerType = json['customerType'];
    partyType = json['partyType'];
    taxedOrganization = json['taxedOrganization'];
    governmentEntity = json['governmentEntity'];
    companyName = json['companyName'];
    companyNameArabic = json['companyNameArabic'];
    displayName = json['displayName'];
    emailAddress = json['emailAddress'];
    phoneCode = json['phoneCode'];
    phone = json['phone'];
    mobileCode = json['mobileCode'];
    mobile = json['mobile'];
    openingBalance = json['openingBalance'] != null
        ? OpeningBalance.fromJson(json['openingBalance'])
        : null;
    vatNumber = json['vatNumber'];
    crNum = json['crNum'];
    if (json['documents'] != null) {
      documents = List<Documents>.from(
          (json['documents'] as List).map((v) => Documents.fromJson(v)));
    }
    remark = json['remark'] != null ? Remark.fromJson(json['remark']) : null;
    customFields = json['customFields'];
    reportingTag = json['reportingTag'];
    billingAddress = json['billingAddress'] != null
        ? BillingAddress.fromJson(json['billingAddress'])
        : null;
    shippingAddress = json['shippingAddress'] != null
        ? ShippingAddress.fromJson(json['shippingAddress'])
        : null;
    if (json['contactPersons'] != null) {
      contactPersons = List<ContactPersons>.from(
          (json['contactPersons'] as List).map((v) => ContactPersons.fromJson(v)));
    }
    sameAddressFlag = json['sameAddressFlag'];
  }

  PrimaryContact? primaryContact;
  PrimaryContactArabic? primaryContactArabic;
  String? customerType;
  String? partyType;
  bool? taxedOrganization;
  bool? governmentEntity;
  String? companyName;
  String? companyNameArabic;
  String? displayName;
  String? emailAddress;
  String? phoneCode;
  String? phone;
  String? mobileCode;
  String? mobile;
  OpeningBalance? openingBalance;
  String? vatNumber;
  String? crNum;
  List<Documents>? documents;
  Remark? remark;
  dynamic customFields;
  dynamic reportingTag;
  BillingAddress? billingAddress;
  ShippingAddress? shippingAddress;
  List<ContactPersons>? contactPersons;
  bool? sameAddressFlag;

  AddCustomerModel copyWith({
    PrimaryContact? primaryContact,
    PrimaryContactArabic? primaryContactArabic,
    String? customerType,
    String? partyType,
    bool? taxedOrganization,
    bool? governmentEntity,
    String? companyName,
    String? companyNameArabic,
    String? displayName,
    String? emailAddress,
    String? phoneCode,
    String? phone,
    String? mobileCode,
    String? mobile,
    OpeningBalance? openingBalance,
    String? vatNumber,
    String? crNum,
    List<Documents>? documents,
    Remark? remark,
    dynamic customFields,
    dynamic reportingTag,
    BillingAddress? billingAddress,
    ShippingAddress? shippingAddress,
    List<ContactPersons>? contactPersons,
    bool? sameAddressFlag,
  }) =>
      AddCustomerModel(
        primaryContact: primaryContact ?? this.primaryContact,
        primaryContactArabic: primaryContactArabic ?? this.primaryContactArabic,
        customerType: customerType ?? this.customerType,
        partyType: partyType ?? this.partyType,
        taxedOrganization: taxedOrganization ?? this.taxedOrganization,
        governmentEntity: governmentEntity ?? this.governmentEntity,
        companyName: companyName ?? this.companyName,
        companyNameArabic: companyNameArabic ?? this.companyNameArabic,
        displayName: displayName ?? this.displayName,
        emailAddress: emailAddress ?? this.emailAddress,
        phoneCode: phoneCode ?? this.phoneCode,
        phone: phone ?? this.phone,
        mobileCode: mobileCode ?? this.mobileCode,
        mobile: mobile ?? this.mobile,
        openingBalance: openingBalance ?? this.openingBalance,
        vatNumber: vatNumber ?? this.vatNumber,
        crNum: crNum ?? this.crNum,
        documents: documents ?? this.documents,
        remark: remark ?? this.remark,
        customFields: customFields ?? this.customFields,
        reportingTag: reportingTag ?? this.reportingTag,
        billingAddress: billingAddress ?? this.billingAddress,
        shippingAddress: shippingAddress ?? this.shippingAddress,
        contactPersons: contactPersons ?? this.contactPersons,
        sameAddressFlag: sameAddressFlag ?? this.sameAddressFlag,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (primaryContact != null) {
      map['primaryContact'] = primaryContact?.toJson();
    }
    if (primaryContactArabic != null) {
      map['primaryContactArabic'] = primaryContactArabic?.toJson();
    }
    map['customerType'] = customerType;
    map['partyType'] = partyType;
    map['taxedOrganization'] = taxedOrganization;
    map['governmentEntity'] = governmentEntity;
    map['companyName'] = companyName;
    map['companyNameArabic'] = companyNameArabic;
    map['displayName'] = displayName;
    map['emailAddress'] = emailAddress;
    map['phoneCode'] = phoneCode;
    map['phone'] = phone;
    map['mobileCode'] = mobileCode;
    map['mobile'] = mobile;
    if (openingBalance != null) {
      map['openingBalance'] = openingBalance?.toJson();
    }
    map['vatNumber'] = vatNumber;
    map['crNum'] = crNum;
    if (documents != null) {
      map['documents'] = documents?.map((v) => v.toJson()).toList();
    }
    if (remark != null) {
      map['remark'] = remark?.toJson();
    }
    map['customFields'] = customFields;
    map['reportingTag'] = reportingTag;
    if (billingAddress != null) {
      map['billingAddress'] = billingAddress?.toJson();
    }
    if (shippingAddress != null) {
      map['shippingAddress'] = shippingAddress?.toJson();
    }
    if (contactPersons != null) {
      map['contactPersons'] = contactPersons?.map((v) => v.toJson()).toList();
    }
    map['sameAddressFlag'] = sameAddressFlag;
    return map;
  }
}

class ContactPersons {
  ContactPersons({
    this.firstName,
    this.lastName,
    this.emailAddress,
    this.events,
    this.cpMobCode,
    this.mobileNo,
  });

  ContactPersons.fromJson(dynamic json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    emailAddress = json['emailAddress'];
    events = json['events'] != null ? List<dynamic>.from(json['events']) : null;
    cpMobCode = json['cpMobCode'];
    mobileNo = json['mobileNo'];
  }

  String? firstName;
  String? lastName;
  String? emailAddress;
  List<dynamic>? events;
  String? cpMobCode;
  String? mobileNo;

  ContactPersons copyWith({
    String? firstName,
    String? lastName,
    String? emailAddress,
    List<dynamic>? events,
    String? cpMobCode,
    String? mobileNo,
  }) =>
      ContactPersons(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        emailAddress: emailAddress ?? this.emailAddress,
        events: events ?? this.events,
        cpMobCode: cpMobCode ?? this.cpMobCode,
        mobileNo: mobileNo ?? this.mobileNo,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['emailAddress'] = emailAddress;
    if (events != null) {
      map['events'] = events;
    }
    map['cpMobCode'] = cpMobCode;
    map['mobileNo'] = mobileNo;
    return map;
  }
}

class ShippingAddress {
  ShippingAddress({
    this.addressId,
    this.countryRegion,
    this.buildingNumber,
    this.streetName,
    this.streetAddress,
    this.streetAddressArabic,
    this.city,
    this.cityArabic,
    this.state,
    this.zipCode,
  });

  ShippingAddress.fromJson(dynamic json) {
    addressId = json['addressId'];
    countryRegion = json['countryRegion'];
    buildingNumber = json['buildingNumber'];
    streetName = json['streetName'];
    streetAddress = json['streetAddress'];
    streetAddressArabic = json['streetAddressArabic'];
    city = json['city'];
    cityArabic = json['cityArabic'];
    state = json['state'];
    zipCode = json['zipCode'];
  }

  int? addressId;
  String? countryRegion;
  String? buildingNumber;
  dynamic streetName;
  String? streetAddress;
  String? streetAddressArabic;
  String? city;
  String? cityArabic;
  dynamic state; // changed to dynamic (id or name)
  String? zipCode;

  ShippingAddress copyWith({
    int? addressId,
    String? countryRegion,
    String? buildingNumber,
    dynamic streetName,
    String? streetAddress,
    String? streetAddressArabic,
    String? city,
    String? cityArabic,
    dynamic state,
    String? zipCode,
  }) =>
      ShippingAddress(
        addressId: addressId ?? this.addressId,
        countryRegion: countryRegion ?? this.countryRegion,
        buildingNumber: buildingNumber ?? this.buildingNumber,
        streetName: streetName ?? this.streetName,
        streetAddress: streetAddress ?? this.streetAddress,
        streetAddressArabic: streetAddressArabic ?? this.streetAddressArabic,
        city: city ?? this.city,
        cityArabic: cityArabic ?? this.cityArabic,
        state: state ?? this.state,
        zipCode: zipCode ?? this.zipCode,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (addressId != null) map['addressId'] = addressId;
    map['countryRegion'] = countryRegion;
    map['buildingNumber'] = buildingNumber;
    map['streetName'] = streetName;
    map['streetAddress'] = streetAddress;
    map['streetAddressArabic'] = streetAddressArabic;
    map['city'] = city;
    map['cityArabic'] = cityArabic;
    map['state'] = state;
    map['zipCode'] = zipCode;
    return map;
  }
}

class BillingAddress {
  BillingAddress({
    this.addressId,
    this.countryRegion,
    this.buildingNumber,
    this.streetName,
    this.streetAddress,
    this.streetAddressArabic,
    this.city,
    this.cityArabic,
    this.state,
    this.zipCode,
  });

  BillingAddress.fromJson(dynamic json) {
    addressId = json['addressId'];
    countryRegion = json['countryRegion'];
    buildingNumber = json['buildingNumber'];
    streetName = json['streetName'];
    streetAddress = json['streetAddress'];
    streetAddressArabic = json['streetAddressArabic'];
    city = json['city'];
    cityArabic = json['cityArabic'];
    state = json['state'];
    zipCode = json['zipCode'];
  }

  int? addressId;
  String? countryRegion;
  String? buildingNumber;
  dynamic streetName;
  String? streetAddress;
  String? streetAddressArabic;
  String? city;
  String? cityArabic;
  dynamic state; // changed to dynamic (id or name)
  String? zipCode;

  BillingAddress copyWith({
    int? addressId,
    String? countryRegion,
    String? buildingNumber,
    dynamic streetName,
    String? streetAddress,
    String? streetAddressArabic,
    String? city,
    String? cityArabic,
    dynamic state,
    String? zipCode,
  }) =>
      BillingAddress(
        addressId: addressId ?? this.addressId,
        countryRegion: countryRegion ?? this.countryRegion,
        buildingNumber: buildingNumber ?? this.buildingNumber,
        streetName: streetName ?? this.streetName,
        streetAddress: streetAddress ?? this.streetAddress,
        streetAddressArabic: streetAddressArabic ?? this.streetAddressArabic,
        city: city ?? this.city,
        cityArabic: cityArabic ?? this.cityArabic,
        state: state ?? this.state,
        zipCode: zipCode ?? this.zipCode,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (addressId != null) map['addressId'] = addressId;
    map['countryRegion'] = countryRegion;
    map['buildingNumber'] = buildingNumber;
    map['streetName'] = streetName;
    map['streetAddress'] = streetAddress;
    map['streetAddressArabic'] = streetAddressArabic;
    map['city'] = city;
    map['cityArabic'] = cityArabic;
    map['state'] = state;
    map['zipCode'] = zipCode;
    return map;
  }
}

class Remark {
  Remark({
    this.remark,
  });

  Remark.fromJson(dynamic json) {
    remark = json['remark'];
  }

  String? remark;

  Remark copyWith({
    String? remark,
  }) =>
      Remark(
        remark: remark ?? this.remark,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['remark'] = remark;
    return map;
  }
}

class Documents {
  Documents({
    this.attachmentList,
    this.documentType,
    this.expirydate,
    this.documentNumber,
    this.file,
  });

  Documents.fromJson(dynamic json) {
    attachmentList = json['attachmentList'] != null ? List<dynamic>.from(json['attachmentList']) : null;
    documentType = json['documentType'];
    expirydate = json['expirydate'];
    documentNumber = json['documentNumber'];
    file = json['file'] != null ? List<dynamic>.from(json['file']) : null;
  }

  List<dynamic>? attachmentList;
  String? documentType;
  dynamic expirydate;
  String? documentNumber;
  List<dynamic>? file;

  Documents copyWith({
    List<dynamic>? attachmentList,
    String? documentType,
    dynamic expirydate,
    String? documentNumber,
    List<dynamic>? file,
  }) =>
      Documents(
        attachmentList: attachmentList ?? this.attachmentList,
        documentType: documentType ?? this.documentType,
        expirydate: expirydate ?? this.expirydate,
        documentNumber: documentNumber ?? this.documentNumber,
        file: file ?? this.file,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (attachmentList != null) {
      map['attachmentList'] = attachmentList;
    }
    map['documentType'] = documentType;
    map['expirydate'] = expirydate;
    map['documentNumber'] = documentNumber;
    if (file != null) {
      map['file'] = file;
    }
    return map;
  }
}

class OpeningBalance {
  OpeningBalance({
    this.branch,
    this.currency,
    this.amount,
  });

  OpeningBalance.fromJson(dynamic json) {
    branch = json['branch'];
    currency = json['currency'];
    amount = json['amount'];
  }

  dynamic branch;
  num? currency;
  dynamic amount;

  OpeningBalance copyWith({
    dynamic branch,
    num? currency,
    dynamic amount,
  }) =>
      OpeningBalance(
        branch: branch ?? this.branch,
        currency: currency ?? this.currency,
        amount: amount ?? this.amount,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['branch'] = branch;
    map['currency'] = currency;
    map['amount'] = amount;
    return map;
  }
}

class PrimaryContactArabic {
  PrimaryContactArabic({
    this.firstNameArabic,
    this.lastNameArabic,
  });

  PrimaryContactArabic.fromJson(dynamic json) {
    firstNameArabic = json['firstNameArabic'];
    lastNameArabic = json['lastNameArabic'];
  }

  String? firstNameArabic;
  String? lastNameArabic;

  PrimaryContactArabic copyWith({
    String? firstNameArabic,
    String? lastNameArabic,
  }) =>
      PrimaryContactArabic(
        firstNameArabic: firstNameArabic ?? this.firstNameArabic,
        lastNameArabic: lastNameArabic ?? this.lastNameArabic,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstNameArabic'] = firstNameArabic;
    map['lastNameArabic'] = lastNameArabic;
    return map;
  }
}

class PrimaryContact {
  PrimaryContact({
    this.firstName,
    this.lastName,
  });

  PrimaryContact.fromJson(dynamic json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  String? firstName;
  String? lastName;

  PrimaryContact copyWith({
    String? firstName,
    String? lastName,
  }) =>
      PrimaryContact(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    return map;
  }
}
