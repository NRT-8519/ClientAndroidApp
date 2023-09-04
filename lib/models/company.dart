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
}