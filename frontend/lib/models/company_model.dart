import 'dart:convert';

class CompanyModel {
  CompanyModel({
    required this.id,
    required this.name,
    required this.location,
  });

  int id;
  String name;
  String location;

  factory CompanyModel.fromJson(String str) =>
      CompanyModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CompanyModel.fromMap(Map<String, dynamic> json) => CompanyModel(
        id: json["id"],
        name: json["name"],
        location: json["location"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "location": location,
      };
}
