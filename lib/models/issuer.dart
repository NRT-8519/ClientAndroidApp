import 'dart:convert';

class Issuer {
  final String uuid;
  final String name;
  final String city;
  final String area;

  Issuer(this.uuid, this.name, this.city, this.area);

  factory Issuer.fromJson(Map<String, dynamic> parsedJson) {
    return Issuer(parsedJson["uuid"], parsedJson["name"], parsedJson["city"], parsedJson["area"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "name": name,
      "city": city,
      "area": area
    };
  }

  String asJson() {
    return json.encode(toJson());
  }
}