import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:blog/app/constants/api_string.dart';
import 'package:http_parser/http_parser.dart';

import '../constants/app_string.dart';
import '../constants/helper_function.dart';
import '../models/auth/user.dart';
import '../models/drawer/api_response.dart';
import '../models/response_status.dart';

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

  Future<ApiResponse> updateProfile({required String body}) async {
    var url = Uri.parse(updateProfileApi);
    ApiResponse apiResponse = ApiResponse();

    String token = await getToken();

    var headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.put(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        apiResponse.data = ResponseStatus.fromJson(json);
      } else {
        var json = jsonDecode(response.body);
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SERVER_ERROR;
    }

    return apiResponse;
  }

  Future<ApiResponse> updateProfilePhoto(String profileImage) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      final token = await getToken();
      var headers = {"Authorization": "Bearer $token"};

      var url = Uri.parse(updateProfilePhotoApi);

      var request = http.MultipartRequest("POST", url);

      request.headers.addAll(headers);

      String ext = profileImage.split('.').last;

      var file = await http.MultipartFile.fromPath("image", profileImage, contentType: MediaType('image', ext));

      request.files.add(file);

      final response = await request.send();

      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);

      final json = jsonDecode(responseString);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // apiResponse.data = ResponseStatus.fromJson(json);
        final status = ResponseStatus.fromJson(json);

        status.data = json["avatar"] ?? '';

        apiResponse.data = status;
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }
}
