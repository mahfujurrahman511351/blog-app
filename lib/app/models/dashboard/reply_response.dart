import 'reply.dart';

class ReplyResponse {
  Reply? reply;
  int? replyCount;

  ReplyResponse({this.reply, this.replyCount});

  ReplyResponse.fromJson(Map<String, dynamic> json) {
    reply = json['reply'] != null ? Reply.fromJson(json['reply']) : null;
    replyCount = int.parse(json['replyCount'].toString());
  }
}
