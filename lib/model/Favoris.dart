class Favoris {
  String? id;
  String? chaletId;
  String? userId;
  Favoris({this.id, this.chaletId, this.userId});

  Favoris.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chaletId = json['chaletId'];
    userId = json['userId'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['chaletId'] = chaletId;
    data['id'] = id;
    data['userId'] = userId;
    return data;
  }
}
