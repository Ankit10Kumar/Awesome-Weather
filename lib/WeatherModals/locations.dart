import 'dart:convert';

List<City> locationFromJson(String str) =>
    List<City>.from(json.decode(str).map((x) => City.fromJson(x)));

String locationToJson(List<City> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class City {
  City({
    required this.name,
    required this.lat,
    required this.lon,
    required this.country,
  });

  String name;
  double lat;
  double lon;
  String country;

  double get() => lat;

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
        country: json["country"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "lat": lat,
        "lon": lon,
        "country": country,
      };
}
