import 'dart:convert';

class Company {
  final String uuid;
  final String name;
  final String country;
  final String city;
  final String address;

  Company(this.uuid, this.name, this.country, this.city, this.address);

  factory Company.fromJson(Map<String, dynamic> parsedJson) {
    return Company(parsedJson["uuid"], parsedJson["name"], parsedJson["country"], parsedJson["city"], parsedJson["address"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "uuid": uuid,
      "name": name,
      "country": country,
      "city": city,
      "address": address
    };
  }

  String asJson() {
    return json.encode(toJson());
  }
}