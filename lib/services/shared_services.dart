import 'dart:convert';

import 'package:get/get.dart';
import 'package:grocery_app_admin/models/login_model.dart';
import 'package:grocery_app_admin/pages/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedService {
  static Future<bool> setLoginDetails(LoginModel? model) async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.setString(
        "login_details", model != null ? jsonEncode(model.toJson()) : "null");
  }

  static Future<LoginModel?> loginDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return (prefs.getString("login_details") != "null" &&
            prefs.getString("login_details") != null)
        ? LoginModel.fromJson(jsonDecode(prefs.getString("login_details")!))
        : null;
  }

  static Future<bool> isLogedIn() async {
    final prefs = await SharedPreferences.getInstance();

    return (prefs.getString("login_details") != "null" &&
            prefs.getString("login_details") != null)
        ? true
        : false;
  }

  static Future<void> logOut() async {
    await setLoginDetails(null);
    Get.offAll(() => LoginPage());
  }
}
