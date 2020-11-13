import 'dart:io';

import 'package:multi_image_picker/multi_image_picker.dart';

import '../models/ad_location.dart';

class AdModel {
  String id;
  double price;
  String title;
  String author;
  String description;
  List<String> categories;
  List<File> images;
  List<Asset> imageAssets;
  String userId;
  AdLocation location;
  String condition;
  bool isSold;
  bool isFav;

  AdModel({
    this.id,
    this.price,
    this.title,
    this.author,
    this.categories,
    this.description,
    this.images,
    this.imageAssets,
    this.userId,
    this.location,
    this.condition,
    this.isSold,
    this.isFav,
  });
}
