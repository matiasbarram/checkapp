// To parse this JSON data, do
//
//     final popularResponse = popularResponseFromMap(jsonString);

import 'dart:convert';

class WorkersModel {
  WorkersModel({
    required this.userId,
    required this.rut,
    required this.role,
    required this.picture,
    required this.attendances,
  });

  int userId;
  String rut;
  String role;
  String picture;
  List<Attendance> attendances;

  factory WorkersModel.fromJson(String str) =>
      WorkersModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory WorkersModel.fromMap(Map<String, dynamic> json) => WorkersModel(
        userId: json["user_id"],
        rut: json["rut"],
        role: json["role"],
        picture: json["picture"],
        attendances: List<Attendance>.from(
            json["attendances"].map((x) => Attendance.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "user_id": userId,
        "rut": rut,
        "role": role,
        "picture": picture,
        "attendances": List<dynamic>.from(attendances.map((x) => x.toMap())),
      };
}

class Attendance {
  Attendance({
    required this.attendanceId,
    required this.eventType,
    required this.expectedTime,
    required this.pending,
    required this.eventTime,
    required this.comments,
    required this.timeDiff,
  });

  int attendanceId;
  String eventType;
  String expectedTime;
  bool pending;
  DateTime eventTime;
  String comments;
  String timeDiff;

  factory Attendance.fromJson(String str) =>
      Attendance.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Attendance.fromMap(Map<String, dynamic> json) => Attendance(
        attendanceId: json["attendance_id"],
        eventType: json["event_type"],
        expectedTime: json["expected_time"],
        pending: json["pending"],
        eventTime: DateTime.parse(json["event_time"]),
        comments: json["comments"],
        timeDiff: json["time_diff"],
      );

  Map<String, dynamic> toMap() => {
        "attendance_id": attendanceId,
        "event_type": eventType,
        "expected_time": expectedTime,
        "pending": pending,
        "event_time": eventTime.toIso8601String(),
        "comments": comments,
        "time_diff": timeDiff,
      };
}
