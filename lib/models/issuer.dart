class Issuer {
  final String uuid;
  final String name;
  final String city;
  final String area;

  Issuer(this.uuid, this.name, this.city, this.area);

  factory Issuer.fromJson(Map<String, dynamic> parsedJson) {
    return Issuer(parsedJson["uuid"], parsedJson["name"], parsedJson["city"], parsedJson["area"]);
  }
}