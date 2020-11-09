import 'package:flutter/cupertino.dart';

import '../models/ad_location.dart';

class AdModel {
  final String id;
  final double price;
  final String title;
  final List<String> categories;
  final List<String> images;
  final String userId;
  final Location location;

  AdModel({
    this.id,
    this.price,
    this.title,
    this.categories,
    this.images,
    this.userId,
    this.location,
  });
}
