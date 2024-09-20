// import 'dart:developer';

import 'dart:developer';

class BaseService {
  //simple header for json
  Map<String, String> getHeaders() {
    return {
      "Accept": "application/json",
      "Content-Type": "application/json",
      // "Authorization": AppData.scretAPIToken
    };
  }

  // Map<String, String> getAuthorizationHeaders() {
  //   log("Token of user ${AppData.userToken}");
  //   return {
  //     "Accept": "application/json",
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer ${AppData.userToken}"
  //   };
  // }

  // Map<String, String> getAuthorizationHeadersWithMultiMediaType() {
  //   log("Token of user ${TokenClass.token}");
  //   return {
  //     "Content-Type": "multipart/form-data",
  //     "Authorization": "Bearer ${TokenClass.token}"
  //   };
  // }
}
