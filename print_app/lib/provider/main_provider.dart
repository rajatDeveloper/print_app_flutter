// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:print_app/feature/histroy/models/histroy_model.dart';
import 'package:print_app/feature/histroy/service/histroy_service.dart';
import 'package:print_app/feature/print_cart/models/print_cart_model.dart';
import 'package:print_app/feature/print_cart/models/product_model.dart';
import 'package:print_app/feature/print_cart/service/print_cart_service.dart';
import 'package:print_app/utils/use_full_function.dart';

class MainProvider extends ChangeNotifier {
  final PrintCartService _printCartService = PrintCartService();
  final HistroyService _histroyService = HistroyService();
  //Product List
  List<ProductModel>? userProduct;
  List<ProductModel>? mainSearchedProduct;

  //print cart list

  List<PrintCartModel>? printCartList;

  //Histroy list
  List<HistroyModel>? histroyList;

  //function calls

  void filterProducts(String searchText) {
    mainSearchedProduct = userProduct!
        .where((element) =>
            element.name!.toLowerCase().contains(searchText.toLowerCase()))
        .toList();
    notifyListeners(); // Trigger rebuild
  }

  //get All product

  Future<void> getAllProduct({required BuildContext context}) async {
    try {
      userProduct = null;
      mainSearchedProduct = null;
      notifyListeners();

      var res = await _printCartService.getAllProductsService();

      res.handleResponse(onFailed: () {
        showSnackBar(context, res.error!.errorMsg);
      }, onSuccess: () {
        userProduct = res.data;
        mainSearchedProduct = userProduct;
        notifyListeners();
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getAllPrintCartData({required BuildContext context}) async {
    try {
      printCartList = null;
      notifyListeners();

      var res = await _printCartService.getAllPrintCartData();

      res.handleResponse(onFailed: () {
        showSnackBar(context, res.error!.errorMsg);
      }, onSuccess: () {
        printCartList = res.data;
        notifyListeners();
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get All histroy data
  Future<void> getAllHistroyData({required BuildContext context}) async {
    try {
      histroyList = null;
      notifyListeners();

      var res = await _histroyService.getAllHistroyService();

      res.handleResponse(onFailed: () {
        showSnackBar(context, res.error!.errorMsg);
      }, onSuccess: () {
        histroyList = res.data;
        notifyListeners();
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> updateTheQuanity({
    required BuildContext context,
    required int id,
    required int quantity,
  }) async {
    try {
      var res = await _printCartService.updateTheQuanityService(
          id: id.toString(), quantity: quantity);

      res.handleResponse(onSuccess: () async {
        getAllPrintCartData(context: context);
        showSnackBar(context, "Quantity updated successfully");
      }, onFailed: () {
        showSnackBar(context, res.error!.errorMsg);
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> removeTheProduct({
    required BuildContext context,
    required int id,
    required bool isRemove,
  }) async {
    try {
      var res = await _printCartService.removePrintCartProductService(
          id: id.toString(), isRemove: isRemove);

      res.handleResponse(onSuccess: () async {
        getAllPrintCartData(context: context);
        showSnackBar(context, "Product removed successfully");
      }, onFailed: () {
        showSnackBar(context, res.error!.errorMsg);
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> addToPrintCartService({
    required BuildContext context,
    required int productId,
    required int quantity,
  }) async {
    try {
      var res = await _printCartService.addToPrintCartService(
          quantity: quantity, productId: productId);

      res.handleResponse(onSuccess: () async {
        // getAllPrintCartData(context: context);
        showSnackBar(context, "Item added to invoice successfully");
      }, onFailed: () {
        showSnackBar(context, res.error!.errorMsg);
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> createHistoryData(
      {required BuildContext context,
      required List<int> printProductIds,
      required String paymentMode}) async {
    try {
      var res = await _printCartService.createHistroyService(
          printProduuctCartIds: printProductIds, payemtMode: paymentMode);

      res.handleResponse(onSuccess: () async {
        getAllPrintCartData(context: context);
        showSnackBar(context, "History created successfully");
      }, onFailed: () {
        showSnackBar(context, res.error!.errorMsg);
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
