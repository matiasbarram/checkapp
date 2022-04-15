// To parse this JSON data, do
//
//     final popularResponse = popularResponseFromMap(jsonString);

import 'dart:convert';

class UserModel {
  UserModel({
    required this.id,
    required this.companyId,
    required this.name,
    required this.rut,
    required this.role,
    required this.deviceId,
  });

  int id;
  int companyId;
  String name;
  String rut;
  String role;
  int deviceId;

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        companyId: json["company_id"],
        name: json["name"],
        rut: json["rut"],
        role: json["role"],
        deviceId: json["device_id"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "company_id": companyId,
        "name": name,
        "rut": rut,
        "role": role,
        "device_id": deviceId,
      };
}
