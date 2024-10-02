import 'package:flutter/material.dart';
import 'package:print_app/feature/admin/view/device_list.dart';
import 'package:print_app/feature/histroy/view/histroy_view.dart';
import 'package:print_app/feature/main_bar_view.dart';
import 'package:print_app/feature/print_cart/view/print_cart_view.dart';
import 'package:print_app/feature/print_cart/view/product_view.dart';
import 'package:print_app/feature/splash/view/splash_view.dart';

Map<String, Widget Function(BuildContext)> getAppRoutes() {
  Map<String, Widget Function(BuildContext)> appRoutes = {
    //  AgentListScreen.routeName: (context) {
    //       var args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    //       var listData = args['listData'] as List<AgentModel>;
    //       var caseModel = args['caseModel'] as CaseModel;

    //       return AgentListScreen(
    //         agents: listData,
    //         caseModel: caseModel,
    //       );
    //     },
    SplashView.routeName: (context) => const SplashView(),
    PrintCartView.routeName: (context) => const PrintCartView(),
    HistroyView.routeName: (context) => const HistroyView(),
    ProductView.routeName: (context) => const ProductView(),
    MainBarScreen.routeName: (context) {
      var index = ModalRoute.of(context)!.settings.arguments as int;
      return MainBarScreen(index: index);
    },
    DeviceList.routeName: (context) => DeviceList(),
  };

  return appRoutes;
}
