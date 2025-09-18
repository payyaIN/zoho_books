import 'dart:convert';

class NotificationModel {
  final List<NotificationData> data;
  final int wfNotifyCount;

  NotificationModel({
    required this.data,
    required this.wfNotifyCount,
  });

  factory NotificationModel.fromJson(String str) =>
      NotificationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromMap(Map<String, dynamic> json) {
    List<dynamic> notificationsList = [];

    if (json.containsKey("array")) {
      if (json["array"] is List) {
        notificationsList = json["array"] as List;
      }
    }

    return NotificationModel(
      data: List<NotificationData>.from(notificationsList.map((x) {
        if (x is Map) {
          return NotificationData.fromMap(Map<String, dynamic>.from(x));
        }
        return NotificationData.empty();
      })),
      wfNotifyCount: json["wfNotifyCount"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "array": List<dynamic>.from(data.map((x) => x.toMap())),
        "wfNotifyCount": wfNotifyCount,
      };

  factory NotificationModel.empty() => NotificationModel(
        data: [],
        wfNotifyCount: 0,
      );
}

class NotificationData {
  final String? profilePic;
  final int? id;
  final int? typeId;
  final int? status;
  final String? createdOn;
  final String? message;
  final bool? isBulk;
  final bool? hasViewPermission;
  final int? processId;
  final String? timeAgo;

  NotificationData({
    this.profilePic,
    this.id,
    this.typeId,
    this.status,
    this.createdOn,
    this.message,
    this.isBulk,
    this.hasViewPermission,
    this.processId,
    this.timeAgo,
  });

  factory NotificationData.fromMap(Map<String, dynamic> json) {
    String? timeAgo;
    if (json["wfNotifyCreatedOn"] != null &&
        json["wfNotifyCreatedOn"].contains("(")) {
      try {
        final regex = RegExp(r'\((.*?)\)');
        final match = regex.firstMatch(json["wfNotifyCreatedOn"]);
        if (match != null) {
          timeAgo = match.group(1);
        }
      } catch (e) {
        print("Error parsing timeAgo: $e");
      }
    }

    return NotificationData(
      profilePic: json["wfNotifyProfilePic"],
      id: json["wfNotifyId"],
      typeId: json["wfNotifyTypeId"],
      status: json["wfNotifyStatus"],
      createdOn: json["wfNotifyCreatedOn"],
      message: json["wfNotifyMessage"],
      isBulk: json["wfNotifyIsBulk"] ?? false,
      hasViewPermission: json["wfNotifyHasViewPermission"] ?? false,
      processId: json["wfNotifyProcessId"],
      timeAgo: timeAgo,
    );
  }

  Map<String, dynamic> toMap() => {
        "wfNotifyProfilePic": profilePic,
        "wfNotifyId": id,
        "wfNotifyTypeId": typeId,
        "wfNotifyStatus": status,
        "wfNotifyCreatedOn": createdOn,
        "wfNotifyMessage": message,
        "wfNotifyIsBulk": isBulk,
        "wfNotifyHasViewPermission": hasViewPermission,
        "wfNotifyProcessId": processId,
      };

  factory NotificationData.empty() => NotificationData(
        profilePic: "",
        id: 0,
        typeId: 0,
        status: 0,
        createdOn: "",
        message: "",
        isBulk: false,
        hasViewPermission: false,
        processId: 0,
        timeAgo: "Recently",
      );
}
