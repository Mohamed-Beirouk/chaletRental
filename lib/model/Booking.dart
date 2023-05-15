class Booking {
  String? id;
  String? userId;
  String? userEmail;
  String? userPhone;
  String? userName;
  String? bookingStatus;
  String? placeId;
  String? placeName;
  String? description;
  String? placeLocation;
  String? adultsNumber;
  String? childrenNumber;
  String? dateRange;
  int? servicePrice;
  int? price;
  String? imageURL;
  //String? whatsappLink;
  int? dateCount;
  Booking({
    this.userId,
    this.id,
    this.userName,
    this.userEmail,
    this.userPhone,
    this.placeId,
    this.placeName,
    this.placeLocation,
    this.description,
    this.adultsNumber,
    this.childrenNumber,
    this.servicePrice,
    this.dateRange,
    this.price,
    //this.date,
    this.imageURL,
    //this.whatsappLink,
    this.bookingStatus = "Booked",
    this.dateCount,
  });

  Booking.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    id = json['id'];
    dateCount = json['dateCount'];
    price = json['price'];
    userName = json['userName'];
    userEmail = json['userEmail'];
    userPhone = json['userPhone'];
    placeId = json['placeId'];
    placeName = json['placeName'];
    description = json['description'];
    imageURL = json['imageURL'];
    placeLocation = json['placeLocation'];
    dateRange = json['dateRange'];
    bookingStatus = json['bookingStatus'];
    servicePrice = json['servicePrice'];
    childrenNumber = json['childrenNumber'];
    adultsNumber = json['adultsNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['userId'] = userId;
    data['id'] = id;
    data['dateCount'] = dateCount;
    data['userName'] = userName;
    data['userEmail'] = userEmail;
    data['price'] = price;
    data['userPhone'] = userPhone;
    data['placeId'] = placeId;
    data['placeName'] = placeName;
    data['description'] = description;
    data['imageURL'] = imageURL;
    data['placeLocation'] = placeLocation;
    data['dateRange'] = dateRange;
    data['bookingStatus'] = bookingStatus;
    data['servicePrice'] = servicePrice;
    data['childrenNumber'] = childrenNumber;
    data['adultsNumber'] = adultsNumber;

    return data;
  }
}
