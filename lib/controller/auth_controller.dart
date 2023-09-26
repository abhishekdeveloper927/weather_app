import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/data/model/dummy_data/city_data.dart';
import 'package:weather_app/data/model/response/city_model.dart';
import 'package:weather_app/data/model/response/weather_model.dart';

import '../data/model/response/address_model.dart';
import '../data/model/response/weather_model2.dart';
import '../data/repository/auth_repo.dart';

import 'package:http/http.dart' as http;

import '../view/base/show_snackbar.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  bool isLoading = false;

  CustomAddress customAddress = CustomAddress();
  CityModel? selectedCityModel;

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  updateSelectedCity(CityModel cityModel) {
    selectedCityModel = cityModel;
    update();
  }

  clearSelectedCity() {
    selectedCityModel = null;
    update();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  List<CityModel> getCityList() {
    return cityDataList;
  }

  Position? position;

  updatePosition(Position p) {
    position = p;
    update();
  }

  Future<void> fetchLocation() async {
    isLoading = true;
    update();
    if (kDebugMode) {
      print('aaa1');
    }
    await updatePosition(await determinePosition());
    if (position != null) {
      await getWeatherFromLatLng(
          position!.latitude.toString(), position!.longitude.toString());
      await get7DaysWeatherFromLatLng(
          position!.latitude.toString(), position!.longitude.toString());
    }
    isLoading = false;
    update();
  }

  AddressModel? currentAddressModel;

  Future<void> getAddressFromLatLng(String lat, String lng) async {
    await http
        .get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCjUv0dmUvMZGgvW3QRtDq-k5VIq-M2xW4'))
        .then((value) {
      currentAddressModel = addressModelFromJson(value.body);
    });
    update();
  }

  WeatherModel? weatherModel;

  Future<void> getWeatherFromLatLng(String lat, String lng) async {
    await http
        .get(Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current_weather=true"))
        .then((value) {
      weatherModel = weatherModelFromJson(value.body);
      print(value.body);
    });
    update();
  }

  WeatherModel2? weatherModel2;
  WeatherModel2? newWeatherModel2;

  Future<void> get7DaysWeatherFromLatLng(String lat, String lng) async {
    await http
        .get(Uri.parse(
        "https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lng&current_weather=true&start_date=${DateFormat(
            'yyyy-MM-dd').format(DateTime.now())}&end_date=${DateFormat(
            'yyyy-MM-dd').format(DateTime.now().add(
            const Duration(days: 6)))}&hourly=temperature_2m"))
        .then((value) {
      if (selectedCityModel != null) {
        newWeatherModel2 = weatherModel2FromJson(value.body);
      } else {
        weatherModel2 = weatherModel2FromJson(value.body);
      }
      print(value.body);
    });
    update();
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      if (kDebugMode) {
        print("ERROR$error");
      }
    });
    return await Geolocator.getCurrentPosition();
  }
}

class CustomAddress {
  String? address;

  String? lat;
  String? lng;

  CustomAddress({this.address, this.lat, this.lng});
}
