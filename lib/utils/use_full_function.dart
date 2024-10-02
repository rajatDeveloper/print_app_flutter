import 'package:flutter/material.dart';
import 'package:print_app/res/colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';

//function to handle the responvise height
double getDeviceHeight(BuildContext context) =>
    MediaQuery.of(context).size.height;

//function to handle the responvise width
double getDeviceWidth(BuildContext context) =>
    MediaQuery.of(context).size.width;

//using custom snack bar
void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: AppColors.white),
      ),
      backgroundColor: AppColors.primary,
    ),
  );
}

//using this function for responsive text
double getFontSize(double size, double screenWidth) {
  return size * screenWidth / 414;
}

// //shared preferences functions
// Future<void> setDataToLocal(
//     {required String key, required String value}) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.setString(key, value);
// }

// //function to get the saved data using key from local
// Future<String> getSavedDataByKey({required String key}) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();

//   String? data = prefs.getString(key);
//   return data ?? "";
// }

// //remove the local saved data using key
// Future<void> removeDataByKey({required String key}) async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   await prefs.remove(key);
// }
