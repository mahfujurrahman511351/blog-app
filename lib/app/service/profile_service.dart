import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:blog/app/constants/api_string.dart';

import '../constants/app_string.dart';
import '../constants/helper_function.dart';
import '../models/auth/user.dart';
import '../models/drawer/api_response.dart';

class ProfileService {
  Future<ApiResponse> getUser() async {
    ApiResponse apiResponse = ApiResponse();

    try {
      var url = Uri.parse(profileApi);

      String token = await getToken();

      var headers = {"Accept": "application/json", 'Authorization': 'Bearer $token'};

      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        apiResponse.data = User.fromJson(json);

        
        //
      } else {
        var json = jsonDecode(response.body);
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }
}
