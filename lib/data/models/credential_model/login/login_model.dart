class LoginModel {
  LoginModel({
      this.error, 
      this.message, 
      this.response, 
      this.status,});

  LoginModel.fromJson(dynamic json) {
    error = json['error'];
    message = json['message'];
    response = json['response'] != null ? Response.fromJson(json['response']) : null;
    status = json['status'];
  }
  bool? error;
  dynamic message;
  Response? response;
  bool? status;
LoginModel copyWith({  bool? error,
  dynamic message,
  Response? response,
  bool? status,
}) => LoginModel(  error: error ?? this.error,
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
      this.accessToken, 
      this.refreshToken, 
      this.companyId, 
      this.isFirstLogin, 
      this.refreshExpiresIn, 
      this.notbeforepolicy, 
      this.scope, 
      this.tokenType, 
      this.sessionState, 
      this.expiresIn,});

  Response.fromJson(dynamic json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    companyId = json['companyId'];
    isFirstLogin = json['isFirstLogin'];
    refreshExpiresIn = json['refresh_expires_in'];
    notbeforepolicy = json['not-before-policy'];
    scope = json['scope'];
    tokenType = json['token_type'];
    sessionState = json['session_state'];
    expiresIn = json['expires_in'];
  }
  String? accessToken;
  String? refreshToken;
  num? companyId;
  num? isFirstLogin;
  num? refreshExpiresIn;
  num? notbeforepolicy;
  String? scope;
  String? tokenType;
  String? sessionState;
  num? expiresIn;
Response copyWith({  String? accessToken,
  String? refreshToken,
  num? companyId,
  num? isFirstLogin,
  num? refreshExpiresIn,
  num? notbeforepolicy,
  String? scope,
  String? tokenType,
  String? sessionState,
  num? expiresIn,
}) => Response(  accessToken: accessToken ?? this.accessToken,
  refreshToken: refreshToken ?? this.refreshToken,
  companyId: companyId ?? this.companyId,
  isFirstLogin: isFirstLogin ?? this.isFirstLogin,
  refreshExpiresIn: refreshExpiresIn ?? this.refreshExpiresIn,
  notbeforepolicy: notbeforepolicy ?? this.notbeforepolicy,
  scope: scope ?? this.scope,
  tokenType: tokenType ?? this.tokenType,
  sessionState: sessionState ?? this.sessionState,
  expiresIn: expiresIn ?? this.expiresIn,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = accessToken;
    map['refresh_token'] = refreshToken;
    map['companyId'] = companyId;
    map['isFirstLogin'] = isFirstLogin;
    map['refresh_expires_in'] = refreshExpiresIn;
    map['not-before-policy'] = notbeforepolicy;
    map['scope'] = scope;
    map['token_type'] = tokenType;
    map['session_state'] = sessionState;
    map['expires_in'] = expiresIn;
    return map;
  }
}