class ResponseStatus {
  String? message;
  bool? success;
  Object? data;

  ResponseStatus({this.message, this.success});

  ResponseStatus.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    success = json['success'] ?? false;
  }
}
