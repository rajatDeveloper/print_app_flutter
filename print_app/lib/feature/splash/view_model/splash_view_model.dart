import 'package:flutter/material.dart';
import 'package:print_app/feature/main_bar_view.dart';

class SplashViewModel {
  navigateToHome(BuildContext context) async {
    //1 sec wait
    await Future.delayed(Duration(seconds: 1));

    Navigator.pushNamedAndRemoveUntil(
      context,
      MainBarScreen.routeName,
      arguments: 1,
      (route) => false,
    );
  }
}
