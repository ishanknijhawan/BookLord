import 'package:flutter/material.dart';
import 'dart:io';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/ad_model.dart';
import '../data/categories.dart';
import '../models/ad_location.dart';

class AdProvider with ChangeNotifier {
  List<AdModel> _items = [];
  AdModel _adModel = AdModel();
  var cats = Categories.storedCategories;

  List<AdModel> get items {
    return [..._items];
  }

  void addCategory(String cat) {
    cats.add(cat);
  }

  void addTitleAndStuff(
    String title,
    String desc,
    String author,
    String condition,
  ) {
    if (_adModel == null) {
      _adModel = AdModel();
    }
    _adModel.title = title;
    _adModel.categories = cats;
    _adModel.author = author;
    _adModel.isFav = false;
    _adModel.isSold = false;
    _adModel.condition = condition;
    _adModel.description = desc;
  }

  void addImagePaths(List<File> images) {
    if (_adModel == null) {
      _adModel = AdModel();
    }
    _adModel.images = images;
  }

  void addImageAssets(List<Asset> images) {
    if (_adModel == null) {
      _adModel = AdModel();
    }

    _adModel.imageAssets = images;
  }

  void addLocation(double price, Location location) {
    if (_adModel == null) {
      _adModel = AdModel();
    }
    _adModel.price = price;
    _adModel.location = location;
  }

  Future<void> pushToFirebase() async {
    var userId = await FirebaseAuth.instance.currentUser();
    var emailForImage = userId.email;
    var uid = userId.uid;
    var id = DateTime.now().toString();
    print('email is $emailForImage');
    if (_adModel == null) {
      print('coming here null');
      _adModel = AdModel();
    }
    if (_adModel.imageAssets == null) {
      List<String> downloadedPaths = [];
      for (int i = 0; i < _adModel.images.length; i++) {
        final ref = FirebaseStorage.instance
            .ref()
            .child(emailForImage)
            .child(id + '.jpg');
        await ref.putFile(_adModel.images[i]).onComplete;
        final url = await ref.getDownloadURL();
        print('url is $url');
        downloadedPaths.add(url);
      }
      await Firestore.instance
          .collection('products')
          .document(
            id,
          )
          .setData({
        'id': id,
        'createdAt': Timestamp.now(),
        'price': _adModel.price,
        'title': _adModel.title,
        'author': _adModel.author,
        'description': _adModel.description,
        'categories': _adModel.categories,
        'images': downloadedPaths,
        'uid': uid,
        'location': {
          'latitude': _adModel.location.latitude,
          'longitude': _adModel.location.longitude,
          'address': _adModel.location.address,
        },
        'condition': _adModel.condition,
        'isSold': _adModel.isSold,
        'isFav': _adModel.isFav,
      });
    } else if (_adModel.images == null) {
      _adModel.images = [];
    }
  }
}
