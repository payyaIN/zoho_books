class CashFlowModel {
  final bool error;
  final String message;
  final ResponseData response;
  final bool status;

  CashFlowModel({
    required this.error,
    required this.message,
    required this.response,
    required this.status,
  });

  factory CashFlowModel.fromJson(Map<String, dynamic> json) {
    return CashFlowModel(
      error: json['error'],
      message: json['message'],
      response: ResponseData.fromJson(json['response']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'error': error,
    'message': message,
    'response': response.toJson(),
    'status': status,
  };
}

class ResponseData {
  final num totalOutgoing;
  final Balance periodEndingBalance;
  final num totalIncoming;
  final List<PerMonthData> perMonthAdditionalData;
  final Series series;
  final Balance periodOpeningBalance;

  ResponseData({
    required this.totalOutgoing,
    required this.periodEndingBalance,
    required this.totalIncoming,
    required this.perMonthAdditionalData,
    required this.series,
    required this.periodOpeningBalance,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      totalOutgoing: json['totalOutgoing'],
      periodEndingBalance: Balance.fromJson(json['periodEndingBalance']),
      totalIncoming: json['totalIncoming'],
      perMonthAdditionalData: (json['perMonthAdditionalData'] as List)
          .map((item) => PerMonthData.fromJson(item))
          .toList(),
      series: Series.fromJson(json['series']),
      periodOpeningBalance: Balance.fromJson(json['periodOpeningBalance']),
    );
  }

  Map<String, dynamic> toJson() => {
    'totalOutgoing': totalOutgoing,
    'periodEndingBalance': periodEndingBalance.toJson(),
    'totalIncoming': totalIncoming,
    'perMonthAdditionalData': perMonthAdditionalData.map((e) => e.toJson()).toList(),
    'series': series.toJson(),
    'periodOpeningBalance': periodOpeningBalance.toJson(),
  };
}

class Balance {
  final String date;
  final num balance;

  Balance({required this.date, required this.balance});

  factory Balance.fromJson(Map<String, dynamic> json) {
    return Balance(
      date: json['date'],
      balance: json['balance'],
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'balance': balance,
  };
}

class PerMonthData {
  final String date;
  final num incoming;
  final num outgoing;
  final num openingBalance;

  PerMonthData({
    required this.date,
    required this.incoming,
    required this.outgoing,
    required this.openingBalance,
  });

  factory PerMonthData.fromJson(Map<String, dynamic> json) {
    return PerMonthData(
      date: json['date'],
      incoming: json['incoming'],
      outgoing: json['outgoing'],
      openingBalance: json['openingBalance'],
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'incoming': incoming,
    'outgoing': outgoing,
    'openingBalance': openingBalance,
  };
}

class Series {
  final String name;
  final List<SeriesData> data;

  Series({required this.name, required this.data});

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      name: json['name'],
      data: (json['data'] as List)
          .map((item) => SeriesData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class SeriesData {
  final String x;
  final num? y; // ✅ Nullable

  SeriesData({required this.x, this.y});

  factory SeriesData.fromJson(Map<String, dynamic> json) {
    return SeriesData(
      x: json['x'],
      y: json['y'], // can be null
    );
  }

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
  };
}
