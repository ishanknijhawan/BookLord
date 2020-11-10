import '../models/ad_location.dart';

class AdModel {
  String id;
  double price;
  String title;
  String description;
  List<String> categories;
  List<String> images;
  String userId;
  Location location;
  String condition;
  bool isSold;

  AdModel({
    this.id,
    this.price,
    this.title,
    this.categories,
    this.description,
    this.images,
    this.userId,
    this.location,
    this.condition,
    this.isSold,
  });
}
