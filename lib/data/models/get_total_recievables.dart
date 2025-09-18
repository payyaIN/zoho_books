class GetTotalRecievables {
  GetTotalRecievables({
      this.error, 
      this.message, 
      this.response, 
      this.status,});

  GetTotalRecievables.fromJson(dynamic json) {
    error = json['error'];
    message = json['message'];
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
    status = json['status'];
  }
  bool? error;
  String? message;
  Response? response;
  bool? status;
GetTotalRecievables copyWith({  bool? error,
  String? message,
  Response? response,
  bool? status,
}) => GetTotalRecievables(  error: error ?? this.error,
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
      this.total, 
      this.current, 
      this.overdue, 
      this.currency, 
      this.overdueBreakdown,});

  Response.fromJson(dynamic json) {
    total = json['total'];
    current = json['current'];
    overdue = json['overdue'];
    currency = json['currency'];
    overdueBreakdown = json['overdueBreakdown'] != null ? OverdueBreakdown.fromJson(json['overdueBreakdown']) : null;
  }
  num? total;
  num? current;
  num? overdue;
  dynamic currency;
  OverdueBreakdown? overdueBreakdown;
Response copyWith({  num? total,
  num? current,
  num? overdue,
  dynamic currency,
  OverdueBreakdown? overdueBreakdown,
}) => Response(  total: total ?? this.total,
  current: current ?? this.current,
  overdue: overdue ?? this.overdue,
  currency: currency ?? this.currency,
  overdueBreakdown: overdueBreakdown ?? this.overdueBreakdown,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['total'] = total;
    map['current'] = current;
    map['overdue'] = overdue;
    map['currency'] = currency;
    if (overdueBreakdown != null) {
      map['overdueBreakdown'] = overdueBreakdown?.toJson();
    }
    return map;
  }

}

class OverdueBreakdown {
  OverdueBreakdown({
      this.aboveFortyFiveDays, 
      this.thirtyOneToFortyFiveDays, 
      this.sixteenToThirtyDays, 
      this.oneToFifteenDays,});

  OverdueBreakdown.fromJson(dynamic json) {
    aboveFortyFiveDays = json['AboveFortyFiveDays'];
    thirtyOneToFortyFiveDays = json['ThirtyOneToFortyFiveDays'];
    sixteenToThirtyDays = json['SixteenToThirtyDays'];
    oneToFifteenDays = json['OneToFifteenDays'];
  }
  num? aboveFortyFiveDays;
  num? thirtyOneToFortyFiveDays;
  num? sixteenToThirtyDays;
  num? oneToFifteenDays;
OverdueBreakdown copyWith({  num? aboveFortyFiveDays,
  num? thirtyOneToFortyFiveDays,
  num? sixteenToThirtyDays,
  num? oneToFifteenDays,
}) => OverdueBreakdown(  aboveFortyFiveDays: aboveFortyFiveDays ?? this.aboveFortyFiveDays,
  thirtyOneToFortyFiveDays: thirtyOneToFortyFiveDays ?? this.thirtyOneToFortyFiveDays,
  sixteenToThirtyDays: sixteenToThirtyDays ?? this.sixteenToThirtyDays,
  oneToFifteenDays: oneToFifteenDays ?? this.oneToFifteenDays,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['AboveFortyFiveDays'] = aboveFortyFiveDays;
    map['ThirtyOneToFortyFiveDays'] = thirtyOneToFortyFiveDays;
    map['SixteenToThirtyDays'] = sixteenToThirtyDays;
    map['OneToFifteenDays'] = oneToFifteenDays;
    return map;
  }

}