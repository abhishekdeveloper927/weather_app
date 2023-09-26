import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/auth_controller.dart';
import '../data/repository/auth_repo.dart';

Future<void> init() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);

  //Repo
  Get.lazyPut(() => AuthRepo(sharedPreferences: Get.find()));

  //Controller
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
}
