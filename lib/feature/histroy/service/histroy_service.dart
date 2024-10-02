import 'dart:convert';

import 'package:print_app/base/base_service.dart';
import 'package:print_app/feature/histroy/models/histroy_model.dart';
import 'package:print_app/network/api_constants.dart';
import 'package:print_app/network/api_response.dart';
import 'package:print_app/network/network_manager.dart';
import 'package:print_app/network/network_request.dart';

class HistroyService extends BaseService {
  //get all histroy data

  Future<ApiResponse<List<HistroyModel>>> getAllHistroyService() async {
    NetworkRequest request = NetworkRequest(
      "${ApiConstants.baseUrl}${ApiConstants.getHistroyUrl}",
      RequestMethod.get,
      headers: getHeaders(),
    );

    final result =
        await NetworkManager.instance.perform<List<HistroyModel>>(request);

    if (result.json != null) {
      var userMap = result.json;

      result.data = userMap
          .map<HistroyModel>((json) => HistroyModel.fromJson(jsonEncode(json)))
          .toList();
    }
    return result;
  }
}
