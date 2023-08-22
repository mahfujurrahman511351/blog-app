class Like {
  bool? isLiked;
  int? likeCount;

  Like({this.isLiked, this.likeCount});

  Like.fromJson(Map<String, dynamic> json) {
    isLiked = json['isLiked'] ?? false;
    likeCount = int.parse(json['likeCount'].toString());
  }
}
