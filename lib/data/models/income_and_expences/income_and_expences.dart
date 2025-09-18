class IncomeAndExpenses {
  final bool? error;
  final String? message;
  final ResponseData? response;
  final bool? status;

  IncomeAndExpenses({
    this.error,
    this.message,
    this.response,
    this.status,
  });

  factory IncomeAndExpenses.fromJson(Map<String, dynamic> json) {
    return IncomeAndExpenses(
      error: json['error'],
      message: json['message'],
      response: json['response'] != null
          ? ResponseData.fromJson(json['response'])
          : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() => {
    'error': error,
    'message': message,
    'response': response?.toJson(),
    'status': status,
  };

  IncomeAndExpenses copyWith({
    bool? error,
    String? message,
    ResponseData? response,
    bool? status,
  }) {
    return IncomeAndExpenses(
      error: error ?? this.error,
      message: message ?? this.message,
      response: response ?? this.response,
      status: status ?? this.status,
    );
  }
}

class ResponseData {
  final IncomeSeries? incomeSeries;
  final num? totalIncome;
  final ExpenseSeries? expenseSeries;
  final num? totalExpense;

  ResponseData({
    this.incomeSeries,
    this.totalIncome,
    this.expenseSeries,
    this.totalExpense,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) {
    return ResponseData(
      incomeSeries: json['incomeSeries'] != null
          ? IncomeSeries.fromJson(json['incomeSeries'])
          : null,
      totalIncome: json['totalIncome'],
      expenseSeries: json['expenseSeries'] != null
          ? ExpenseSeries.fromJson(json['expenseSeries'])
          : null,
      totalExpense: json['totalExpense'],
    );
  }

  Map<String, dynamic> toJson() => {
    'incomeSeries': incomeSeries?.toJson(),
    'totalIncome': totalIncome,
    'expenseSeries': expenseSeries?.toJson(),
    'totalExpense': totalExpense,
  };

  ResponseData copyWith({
    IncomeSeries? incomeSeries,
    num? totalIncome,
    ExpenseSeries? expenseSeries,
    num? totalExpense,
  }) {
    return ResponseData(
      incomeSeries: incomeSeries ?? this.incomeSeries,
      totalIncome: totalIncome ?? this.totalIncome,
      expenseSeries: expenseSeries ?? this.expenseSeries,
      totalExpense: totalExpense ?? this.totalExpense,
    );
  }
}

class IncomeSeries {
  final String? name;
  final List<ChartData>? data;

  IncomeSeries({this.name, this.data});

  factory IncomeSeries.fromJson(Map<String, dynamic> json) {
    return IncomeSeries(
      name: json['name'],
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => ChartData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'data': data?.map((item) => item.toJson()).toList(),
  };

  IncomeSeries copyWith({
    String? name,
    List<ChartData>? data,
  }) {
    return IncomeSeries(
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }
}

class ExpenseSeries {
  final String? name;
  final List<ChartData>? data;

  ExpenseSeries({this.name, this.data});

  factory ExpenseSeries.fromJson(Map<String, dynamic> json) {
    return ExpenseSeries(
      name: json['name'],
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => ChartData.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'data': data?.map((item) => item.toJson()).toList(),
  };

  ExpenseSeries copyWith({
    String? name,
    List<ChartData>? data,
  }) {
    return ExpenseSeries(
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }
}

class ChartData {
  final String? x;
  final dynamic y;

  ChartData({this.x, this.y});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      x: json['x'],
      y: json['y'],
    );
  }

  Map<String, dynamic> toJson() => {
    'x': x,
    'y': y,
  };

  ChartData copyWith({String? x, dynamic y}) {
    return ChartData(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }
}
