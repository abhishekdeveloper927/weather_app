import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app/controller/auth_controller.dart';

import '../../../util/dimensions.dart';
import '../../../util/images.dart';

class CityDataScreen extends StatefulWidget {
  const CityDataScreen({super.key});

  @override
  State<CityDataScreen> createState() => _CityDataScreenState();
}

class _CityDataScreenState extends State<CityDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<AuthController>(
      builder: (authController) {
        return ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            authController.selectedCityModel != null
                ? Text(
                    "Latitude : ${authController.selectedCityModel!.lat}",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.fontSizeLarge),
                  )
                : SizedBox(),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            authController.selectedCityModel != null
                ? Text(
                    authController.position != null
                        ? "Longitude : ${authController.selectedCityModel!.lng}"
                        : "",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.fontSizeLarge),
                  )
                : SizedBox(),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            authController.selectedCityModel != null
                ? Text(
                    authController.position != null
                        ? "City : ${authController.selectedCityModel!.cityName}"
                        : "",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: Dimensions.fontSizeLarge),
                  )
                : SizedBox(),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
            authController.newWeatherModel2 != null
                ? SizedBox(
                    height: 120,
                    width: 100,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: authController
                            .newWeatherModel2!.hourly!.time!.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 16),
                            decoration:
                                BoxDecoration(color: Get.theme.primaryColor),
                            child: Stack(
                              children: [
                                Image.asset(
                                  Images.weather,
                                  fit: BoxFit.cover,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Temperature : ${authController.newWeatherModel2!.hourly!.temperature2M![index] ?? ""}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    Dimensions.fontSizeDefault),
                                          ),
                                          const Icon(
                                            Icons.sunny,
                                            color: Colors.yellow,
                                          )
                                        ],
                                      ),
                                      Text(
                                        "${authController.newWeatherModel2!.hourly!.time![index] ?? ""}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                Dimensions.fontSizeDefault),
                                      ),
                                      Text(
                                        "Date & Time",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                Dimensions.fontSizeDefault),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  )
                : const SizedBox(),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            ),
          ],
        );
      },
    ));
  }
}
