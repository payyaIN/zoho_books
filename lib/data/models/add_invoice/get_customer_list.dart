class Customer {
  final String? displayName;
  final String? emailAddress;
  final String? mobileCode;
  final int? phone;
  final int? mobile;
  final int? partyId;
  final String? companyName;

  Customer({
    this.displayName,
    this.emailAddress,
    this.mobileCode,
    this.phone,
    this.mobile,
    this.partyId,
    this.companyName,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      displayName: json['displayName'],
      emailAddress: json['emailAddress'],
      mobileCode: json['mobileCode'],
      phone: json['phone'],
      mobile: json['mobile'],
      partyId: json['partyId'],
      companyName: json['companyName'],
    );
  }
}
