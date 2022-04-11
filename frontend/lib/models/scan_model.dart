import 'dart:convert';

class ScanModel {
  ScanModel({
    required this.id,
    required this.name,
    required this.location,
  });

  int id;
  String name;
  String location;

  factory ScanModel.fromJson(String str) => ScanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScanModel.fromMap(Map<String, dynamic> json) => ScanModel(
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
