import 'dart:convert';

import 'package:print_app/base/base_service.dart';
import 'package:print_app/feature/print_cart/models/print_cart_model.dart';
import 'package:print_app/feature/print_cart/models/product_model.dart';
import 'package:print_app/network/api_constants.dart';
import 'package:print_app/network/api_response.dart';
import 'package:print_app/network/network_manager.dart';
import 'package:print_app/network/network_request.dart';

class PrintCartService extends BaseService {
  //get all products

  Future<ApiResponse<List<ProductModel>>> getAllProductsService() async {
    NetworkRequest request = NetworkRequest(
      "${ApiConstants.baseUrl}${ApiConstants.getProductUrl}",
      RequestMethod.get,
      headers: getHeaders(),
    );

    final result =
        await NetworkManager.instance.perform<List<ProductModel>>(request);

    if (result.json != null) {
      var userMap = result.json;

      result.data = userMap
          .map<ProductModel>((json) => ProductModel.fromJson(jsonEncode(json)))
          .toList();
    }
    return result;
  }

  //get all print cart data

  Future<ApiResponse<List<PrintCartModel>>> getAllPrintCartData() async {
    NetworkRequest request = NetworkRequest(
      "${ApiConstants.baseUrl}${ApiConstants.getPrintCartDataUrl}",
      RequestMethod.get,
      headers: getHeaders(),
    );

    final result =
        await NetworkManager.instance.perform<List<PrintCartModel>>(request);

    if (result.json != null) {
      var userMap = result.json;

      result.data = userMap
          .map<PrintCartModel>(
              (json) => PrintCartModel.fromJson(jsonEncode(json)))
          .toList();
    }
    return result;
  }

  //update the qunaity of the product in the print cart
  // print-cart/11/
  Future<ApiResponse> updateTheQuanityService({
    required String id,
    required int quantity,
  }) async {
    var data = {"quantity": quantity};
    NetworkRequest request = NetworkRequest(
      "${ApiConstants.baseUrl}print-cart/$id/",
      RequestMethod.patch,
      data: data,
      headers: getHeaders(),
    );

    final result = await NetworkManager.instance.perform(request);

    if (result.json != null) {
      var userMap = result.json;

      result.data = userMap;
    }
    return result;
  }

  //remove the product from the print cart
  Future<ApiResponse> removePrintCartProductService({
    required String id,
    required bool isRemove,
  }) async {
    var data = {"isInCart": isRemove};
    NetworkRequest request = NetworkRequest(
      "${ApiConstants.baseUrl}print-cart/$id/",
      RequestMethod.patch,
      data: data,
      headers: getHeaders(),
    );

    final result = await NetworkManager.instance.perform(request);

    if (result.json != null) {
      var userMap = result.json;

      result.data = userMap;
    }
    return result;
  }

  //add to print cart

  Future<ApiResponse> addToPrintCartService(
      {required int quantity, required int productId}) async {
    var data = {"quantity": quantity, "isInCart": true, "product": productId};
    NetworkRequest request = NetworkRequest(
      "${ApiConstants.baseUrl}print-cart/create/",
      RequestMethod.post,
      data: data,
      headers: getHeaders(),
    );

    final result = await NetworkManager.instance.perform(request);

    if (result.json != null) {
      var userMap = result.json;

      result.data = userMap;
    }
    return result;
  }

  Future<ApiResponse> createHistroyService(
      {required List<int> printProduuctCartIds,
      required String payemtMode}) async {
    var data = {
      "date": DateTime.now().toString(),
      "payment_mode": payemtMode,
      "print_cart": printProduuctCartIds
    };
    NetworkRequest request = NetworkRequest(
      "${ApiConstants.baseUrl}history/create/",
      RequestMethod.post,
      data: data,
      headers: getHeaders(),
    );

    final result = await NetworkManager.instance.perform(request);

    if (result.json != null) {
      var userMap = result.json;

      result.data = userMap;
    }
    return result;
  }
}
