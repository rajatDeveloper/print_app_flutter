import 'package:flutter/material.dart';
import 'package:print_app/feature/splash/view/splash_view.dart';
import 'package:print_app/provider/main_provider.dart';
import 'package:print_app/res/colors.dart';
import 'package:print_app/utils/router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MainProvider()),
      ],
      child: MaterialApp(
        title: 'KHANAURI JUNCTION',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          useMaterial3: true,
        ),
        routes: getAppRoutes(),
        initialRoute: SplashView.routeName,
      ),
    );
  }
}
