class AddCustomerModel {
  final String salutation;
  final String firstName;
  final String firstNameArabic;
  final String secondName;
  final String secondNameArabic;
  final String companyName;
  final String companyNameArabic;
  final String email;
  final String mobile;
  final String workPhone;
  final String customerType;

  final String phoneCode;
  final String mobileCode;
  final String cpPhnCode;
  final String cpMobCode;
  final int branchId;
  final int currencyId;
  final String openingAmount;
  final String expiryDate;
  final String documentType;
  final String documentNumber;
  final String remark;

  final Map<String, String> billingAddress;
  final Map<String, String> shippingAddress;

  final Map<String, String> errors;

  AddCustomerModel({
    required this.salutation,
    required this.firstName,
    required this.firstNameArabic,
    required this.secondName,
    required this.secondNameArabic,
    required this.companyName,
    required this.companyNameArabic,
    required this.email,
    required this.mobile,
    required this.workPhone,
    required this.customerType,
    required this.phoneCode,
    required this.mobileCode,
    required this.cpPhnCode,
    required this.cpMobCode,
    required this.branchId,
    required this.currencyId,
    required this.openingAmount,
    required this.expiryDate,
    required this.documentType,
    required this.documentNumber,
    required this.remark,
    required this.billingAddress,
    required this.shippingAddress,
    this.errors = const {},
  });

  AddCustomerModel copyWith({
    String? salutation,
    String? firstName,
    String? secondName,
    String? companyName,
    String? email,
    String? mobile,
    String? workPhone,
    String? customerType,
    String? phoneCode,
    String? mobileCode,
    String? cpPhnCode,
    String? cpMobCode,
    int? branchId,
    int? currencyId,
    String? openingAmount,
    String? expiryDate,
    String? documentType,
    String? documentNumber,
    String? remark,
    Map<String, String>? billingAddress,
    Map<String, String>? shippingAddress,
    Map<String, String>? errors,
  }) {
    return AddCustomerModel(
      salutation: salutation ?? this.salutation,
      firstName: firstName ?? this.firstName,
      secondName: secondName ?? this.secondName,
      companyName: companyName ?? this.companyName,
      firstNameArabic: '',
      secondNameArabic: '',
      companyNameArabic: '',
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      workPhone: workPhone ?? this.workPhone,
      customerType: customerType ?? this.customerType,
      phoneCode: phoneCode ?? this.phoneCode,
      mobileCode: mobileCode ?? this.mobileCode,
      cpPhnCode: cpPhnCode ?? this.cpPhnCode,
      cpMobCode: cpMobCode ?? this.cpMobCode,
      branchId: branchId ?? this.branchId,
      currencyId: currencyId ?? this.currencyId,
      openingAmount: openingAmount ?? this.openingAmount,
      expiryDate: expiryDate ?? this.expiryDate,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber ?? this.documentNumber,
      remark: remark ?? this.remark,
      billingAddress: billingAddress ?? this.billingAddress,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      errors: errors ?? this.errors,

    );
  }

  Map<String, dynamic> toJson() => {
        "salutation": salutation,
        "firstName": firstName,
        "secondName": secondName,
        "companyName": companyName,
        "email": email,
        "mobile": mobile,
        "workPhone": workPhone,
        "customerType": customerType,
        "phoneCode": phoneCode,
        "mobileCode": mobileCode,
        "cpPhnCode": cpPhnCode,
        "cpMobCode": cpMobCode,
        "branchId": branchId,
        "currencyId": currencyId,
        "openingAmount": openingAmount,
        "expiryDate": expiryDate,
        "documentType": documentType,
        "documentNumber": documentNumber,
        "remark": remark,
        "billingAddress": billingAddress,
        "shippingAddress": shippingAddress,
        "errors": errors,
      };
}
