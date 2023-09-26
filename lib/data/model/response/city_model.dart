// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

CityModel cityModelFromJson(String str) => CityModel.fromJson(json.decode(str));

String cityModelToJson(CityModel data) => json.encode(data.toJson());

class CityModel {
  int? id;
  String? cityName;
  String? lat;
  String? lng;

  CityModel({
    this.id,
    this.cityName,
    this.lat,
    this.lng,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json["id"],
        cityName: json["city_name"],
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city_name": cityName,
        "lat": lat,
        "lng": lng,
      };
}
