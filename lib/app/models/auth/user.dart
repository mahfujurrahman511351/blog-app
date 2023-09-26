// ignore_for_file: unnecessary_new, unnecessary_this, prefer_collection_literals

class User {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? avatar;
  String? shortBio;
  bool? isDeleted;
  String? createdAt;
  String? token;
  int? postCount;

  User({
    this.id,
    this.name,
    this.email,
    this.createdAt,
    this.phone,
    this.avatar,
    this.shortBio,
    this.isDeleted,
    this.token,
    this.postCount,
  });

  User.fromJson(Map<String, dynamic> json) {
    var user = json['user'];
    //
    id = user['_id'];
    name = user['name'] ?? "";
    email = user['email'] ?? "";
    phone = user['phone'] ?? "";
    avatar = user['avatar'] ?? "";
    shortBio = user['shortBio'] ?? "";
    isDeleted = user['isDeleted'] ?? false;
    createdAt = user['createdAt'] ?? "";
    postCount = user['postsCount'] ?? 0;

    token = json['token'] ?? "";
  }
}
//phone avatar shortBio isDeleted