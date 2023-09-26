import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/controller/auth_controller.dart';
import 'package:weather_app/util/dimensions.dart';
import 'package:weather_app/util/images.dart';
import 'package:weather_app/view/base/button.dart';
import 'package:weather_app/view/screen/home/city_data_screen.dart';

import '../../../data/model/response/city_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CityModel> cityList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cityList = Get.find<AuthController>().getCityList();
    });
    print(DateFormat('yyyy-MM-dd').format(DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.primaryColor,
            bottom: const TabBar(
              isScrollable: true,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: "Today Weather"),
                Tab(text: "7 Days Weather"),
                Tab(text: "7 Days Weather Of 7 City"),
              ],
            ),
          ),
          backgroundColor: Get.theme.cardColor,
          body: TabBarView(
            children: [
              GetBuilder<AuthController>(
                builder: (authController) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const SizedBox(
                        height: 300,
                      ),
                      !authController.isLoading
                          ? Button(
                              title: "Choose Location",
                              onTap: () {
                                Get.find<AuthController>().fetchLocation();
                              })
                          : const Center(child: CircularProgressIndicator()),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        authController.position != null
                            ? "Longitude : ${authController.position!.longitude}"
                            : "",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                      const SizedBox(
                        height: Dimensions.paddingSizeDefault,
                      ),
                      Text(
                        authController.position != null
                            ? "Latitude : ${authController.position!.latitude}"
                            : "",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                      const SizedBox(
                        height: Dimensions.paddingSizeDefault,
                      ),
                      Row(
                        children: [
                          Text(
                            authController.weatherModel != null &&
                                    authController
                                            .weatherModel!.currentWeather !=
                                        null
                                ? "Temperature : ${authController.weatherModel!.currentWeather!.temperature ?? ""}"
                                : "",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: Dimensions.fontSizeLarge),
                          ),
                          const Icon(
                            Icons.sunny,
                            color: Colors.yellow,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: Dimensions.paddingSizeDefault,
                      ),
                    ],
                  );
                },
              ),
              GetBuilder<AuthController>(
                builder: (authController) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      !authController.isLoading
                          ? Button(
                              title: "Choose Location",
                              onTap: () {
                                Get.find<AuthController>().fetchLocation();
                              })
                          : const Center(child: CircularProgressIndicator()),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        authController.position != null
                            ? "Longitude : ${authController.position!.longitude ?? ""}"
                            : "",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                      const SizedBox(
                        height: Dimensions.paddingSizeDefault,
                      ),
                      Text(
                        authController.position != null
                            ? "Latitude : ${authController.position!.latitude}"
                            : "",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.fontSizeLarge),
                      ),
                      const SizedBox(
                        height: Dimensions.paddingSizeDefault,
                      ),
                      authController.weatherModel2 != null
                          ? SizedBox(
                              height: 120,
                              width: 100,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: authController
                                      .weatherModel2!.hourly!.time!.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      decoration: BoxDecoration(
                                          color: Get.theme.primaryColor),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      authController.weatherModel !=
                                                                  null &&
                                                              authController
                                                                      .weatherModel!
                                                                      .currentWeather !=
                                                                  null
                                                          ? "Temperature : ${authController.weatherModel2!.hourly!.temperature2M![index] ?? ""}"
                                                          : "",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: Dimensions
                                                              .fontSizeDefault),
                                                    ),
                                                    const Icon(
                                                      Icons.sunny,
                                                      color: Colors.yellow,
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  authController.weatherModel !=
                                                              null &&
                                                          authController
                                                                  .weatherModel!
                                                                  .currentWeather !=
                                                              null
                                                      ? "${authController.weatherModel2!.hourly!.time![index] ?? ""}"
                                                      : "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Dimensions
                                                          .fontSizeDefault),
                                                ),
                                                Text(
                                                  authController.weatherModel !=
                                                              null &&
                                                          authController
                                                                  .weatherModel!
                                                                  .currentWeather !=
                                                              null
                                                      ? "Date & Time"
                                                      : "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Dimensions
                                                          .fontSizeDefault),
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
              ),
              GetBuilder<AuthController>(
                builder: (authController) {
                  return ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      GridView.builder(
                        itemCount: cityList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 16,
                                crossAxisSpacing: 16),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () async {
                              authController
                                  .updateSelectedCity(cityList[index]);
                              await Get.find<AuthController>()
                                  .get7DaysWeatherFromLatLng(
                                      cityList[index].lat!,
                                      cityList[index].lng!);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Get.theme.primaryColor,
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.radiusDefault)),
                              child: Center(
                                child: Text(
                                  cityList[index].cityName!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Dimensions.fontSizeDefault,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
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
                              "Longitude : ${authController.selectedCityModel!.lng}",
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
                              "City : ${authController.selectedCityModel!.cityName}",
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
                                      decoration: BoxDecoration(
                                          color: Get.theme.primaryColor),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Temperature : ${authController.newWeatherModel2!.hourly!.temperature2M![index] ?? ""}",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: Dimensions
                                                              .fontSizeDefault),
                                                    ),
                                                    const Icon(
                                                      Icons.sunny,
                                                      color: Colors.yellow,
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  authController
                                                          .newWeatherModel2!
                                                          .hourly!
                                                          .time![index] ??
                                                      "",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Dimensions
                                                          .fontSizeDefault),
                                                ),
                                                Text(
                                                  "Date & Time",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: Dimensions
                                                          .fontSizeDefault),
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
              ),
            ],
          )),
    );
  }

  urlLaunch(Uri url) async {
    if (await canLaunchUrl(url)) {
      launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
