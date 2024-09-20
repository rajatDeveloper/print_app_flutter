import 'package:flutter/material.dart';
import 'package:print_app/feature/splash/view_model/splash_view_model.dart';
import 'package:print_app/res/assets.dart';

class SplashView extends StatefulWidget {
  static const String routeName = '/';
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final _viewModel = SplashViewModel();
  @override
  void initState() {
    super.initState();
    _viewModel.navigateToHome(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset(
              AssetsData.splashImage,
            ),
          ),
        ],
      ),
    );
  }
}
