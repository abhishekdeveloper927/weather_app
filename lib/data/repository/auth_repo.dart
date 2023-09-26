import 'package:shared_preferences/shared_preferences.dart';

import '../../../util/app_constants.dart';

class AuthRepo {
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.sharedPreferences});

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }
}
