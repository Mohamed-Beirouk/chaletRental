class Comment {
  String? id;
  String? chaletId;
  String? comment;
  String? name;
  int? rating;
  String? userId;
  Comment(
      {this.id,
        this.chaletId,
        this.comment,
        this.name,
        this.rating,
        this.userId
      });

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    chaletId = json['chaletId'];
    comment = json['comment'];
    rating = json['rating'];
    userId = json['userId'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['chaletId'] = chaletId;
    data['id'] = id;
    data['name'] = name;
    data['comment'] = comment;
    data['rating'] = rating;
    data['userId'] = userId;
    return data;
  }
}
