import 'dart:ffi';
import 'dart:io';

class Chalets {
  String? id;
  String? OwnerId;
  String? name;
  String? dateRange;
  String? email;
  String? phone;
  // String? whatsappLink;
  String? location;
  bool? chaletsStatus;
  String? imageURL;
  int? price;
  int? offer;
  String? description;
  double? lon;
  double? lat;
  File? file;
  List<dynamic>? arrayImagesURL;

  List<dynamic>? iconServicesName;

  Chalets(
      {this.name,
        this.email,
        this.OwnerId,
        this.id,
        this.imageURL,
        this.phone,
        // this.whatsappLink,
        this.file,
        this.location,
        this.offer,
        this.chaletsStatus,
        this.description,
        this.dateRange,
        this.lon,
        this.lat,
        this.iconServicesName,
        this.arrayImagesURL,
        this.price});

  Chalets.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    OwnerId = json['OwnerId'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    // whatsappLink = json['whatsappLink'];
    chaletsStatus = json['chaletsStatus'];
    location = json['location'];
    description = json['description'];
    dateRange = json['dateRange'];
    lon = json['lon'];
    lat = json['lat'];
    imageURL = json['imageURL'];
    offer = json['offer'];
    price = json['price'];
    arrayImagesURL = json['arrayImagesURL'];
    iconServicesName = json['iconServicesName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['email'] = email;
    data['id'] = id;
    data['OwnerId'] = OwnerId;
    data['name'] = name;
    data['chaletsStatus'] = chaletsStatus;
    data['location'] = location;
    data['description'] = description;
    data['dateRange'] = dateRange;
    data['phone'] = phone;
    // data['whatsappLink'] = whatsappLink;
    data['imageURL'] = imageURL;
    data['offer'] = offer;
    data['price'] = price;
    data['lon'] = lon;
    data['lat'] = lat;
    data['arrayImagesURL'] = arrayImagesURL;
    data['iconServicesName'] = iconServicesName;
    return data;
  }
}
