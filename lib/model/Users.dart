import 'dart:io';

class Users {
  String? id;
  String? name;
  String? email;
  String? type;
  String? phone;
  bool? userStatus;
  String? imageURL;
  String? password;
  String? about;
  File? file;
  Users(
      {this.name,
      this.email,
      this.type,
      this.id,
      this.imageURL,
      this.phone,
      this.file,
      this.userStatus,
      this.about,
      this.password});

  Users.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    about = json['about'];
    type = json['type'];
    imageURL = json['imageURL'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['email'] = email;
    data['id'] = id;
    data['name'] = name;
    data['about'] = about;
    data['type'] = type;
    data['phone'] = phone;
    data['imageURL'] = imageURL;
    return data;
  }
}
