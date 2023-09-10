import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants/api_string.dart';
import '../constants/app_string.dart';
import '../constants/helper_function.dart';
import '../models/dashboard/comment.dart';
import '../models/dashboard/comment_response.dart';
import '../models/drawer/api_response.dart';
import '../models/response_status.dart';

class CommentService {
  Future<ApiResponse> getComments(String postId) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      var url = Uri.parse(getCommentApi + postId);

      String token = await getToken();

      var headers = {"Accept": "application/json", 'Authorization': 'Bearer $token'};

      var response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        apiResponse.data = json.map((item) => Comment.fromJson(item)).toList();

        apiResponse.data as List<dynamic>;

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

  Future<ApiResponse> createComments(String body) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      var url = Uri.parse(createCommentApi);

      String token = await getToken();

      var headers = {"Accept": "application/json", "Content-Type": "application/json", 'Authorization': 'Bearer $token'};

      var response = await http.post(url, body: body, headers: headers);

      final json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final responseStatus = ResponseStatus.fromJson(json);
        responseStatus.data = CommentResponse.fromJson(json["data"]);
        apiResponse.data = responseStatus;
        //
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }

  Future<ApiResponse> deleteComment(String commentId) async {
    ApiResponse apiResponse = ApiResponse();

    try {
      var url = Uri.parse(deleteCommentApi + commentId);

      String token = await getToken();

      var headers = {"Accept": "application/json", "Authorization": "Bearer $token"};

      var response = await http.delete(url, headers: headers);

      var json = jsonDecode(response.body);

      if (response.statusCode == 200) {
        apiResponse.data = ResponseStatus.fromJson(json);
      } else {
        apiResponse.error = handleError(response.statusCode, json);
      }
    } catch (e) {
      apiResponse.error = SOMETHING_WENT_WRONG;
    }

    return apiResponse;
  }
}
