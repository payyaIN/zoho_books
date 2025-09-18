class GetTotalPayables {
  final bool error;
  final String message;
  final ResponseData response;
  final bool status;

  GetTotalPayables({
    required this.error,
    required this.message,
    required this.response,
    required this.status,
  });

  factory GetTotalPayables.fromJson(Map<String, dynamic> json) {
    return GetTotalPayables(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      response: ResponseData.fromJson(json['response'] ?? {}),
      status: json['status'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'message': message,
      'response': response.toJson(),
      'status': status,
    };
  }
}

class ResponseData {
  final double total;
  final double current;
  final double overdue;
  final String? currency;
  final OverdueBreakdown overdueBreakdown;

  ResponseData({
    required this.total,
    required this.current,
    required this.overdue,
    this.currency,
    required this.overdueBreakdown,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      total: (json['total'] ?? 0.0).toDouble(),
      current: (json['current'] ?? 0.0).toDouble(),
      overdue: (json['overdue'] ?? 0.0).toDouble(),
      currency: json['currency'],
      overdueBreakdown: OverdueBreakdown.fromJson(json['overdueBreakdown'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'current': current,
      'overdue': overdue,
      'currency': currency,
      'overdueBreakdown': overdueBreakdown.toJson(),
    };
  }
}

class OverdueBreakdown {
  final double oneToFifteenDays;
  final double aboveFortyFiveDays;
  final double thirtyOneToFortyFiveDays;
  final double sixteenToThirtyDays;

  OverdueBreakdown({
    required this.oneToFifteenDays,
    required this.aboveFortyFiveDays,
    required this.thirtyOneToFortyFiveDays,
    required this.sixteenToThirtyDays,
  });

  factory OverdueBreakdown.fromJson(Map<String, dynamic> json) {
    return OverdueBreakdown(
      oneToFifteenDays: (json['OneToFifteenDays'] ?? 0.0).toDouble(),
      aboveFortyFiveDays: (json['AboveFortyFiveDays'] ?? 0.0).toDouble(),
      thirtyOneToFortyFiveDays: (json['ThirtyOneToFortyFiveDays'] ?? 0.0).toDouble(),
      sixteenToThirtyDays: (json['SixteenToThirtyDays'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OneToFifteenDays': oneToFifteenDays,
      'AboveFortyFiveDays': aboveFortyFiveDays,
      'ThirtyOneToFortyFiveDays': thirtyOneToFortyFiveDays,
      'SixteenToThirtyDays': sixteenToThirtyDays,
    };
  }
}
