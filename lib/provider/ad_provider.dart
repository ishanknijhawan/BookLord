import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io';

import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

import '../models/ad_model.dart';
import '../data/categories.dart';
import '../models/ad_location.dart';
import '../models/user.dart';

class AdProvider with ChangeNotifier {
  List<AdModel> _items = [];
  AdModel _adModel = AdModel();
  var cats = Categories.storedCategories;
  var loc = AdLocation();

  List<AdModel> get items {
    return [..._items];
  }

  void addCategory(String cat) {
    cats.add(cat);
  }

  String getLocationFromLatLang({double latitude, double longitude}) {
    final API_KEY = 'AIzaSyCR1_gIXbLa3EOI1BB-VGfj4jo9jj1KvX4';
    final url =
        'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$API_KEY';
    return url;
  }

  Future<UserModel> getUserDataFromUid(String uid) async {
    final userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final user = UserModel();
    user.email = userData['email'];
    user.userName = userData['name'];
    user.profilePicture = userData['profilePicture'];
    user.uid = userData['uid'];

    return user;
  }

  Future<AdLocation> getUserLocation() async {
    if (loc.latitude == null) {
      final location = Location();

      final locData = await location.getLocation();
      loc.latitude = locData.latitude;
      loc.longitude = locData.longitude;
      return loc;
    } else {
      return loc;
    }
  }

  Future<double> getDistanceFromCoordinates(double lat, double long) async {
    final location = Location();

    final locData = await location.getLocation();
    loc.latitude = locData.latitude;
    loc.longitude = locData.longitude;

    final distance = Geolocator.distanceBetween(
      loc.latitude,
      loc.longitude,
      lat,
      long,
    );
    return distance;
  }

  double getDistanceFromCoordinates2(
    double lat1,
    double long1,
    double lat2,
    double long2,
  ) {
    final distance = Geolocator.distanceBetween(
      lat1,
      long1,
      lat2,
      long2,
    );
    return distance;
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
    _adModel.fileImages = images;
  }

  void addImageAssets(List<Asset> images) {
    if (_adModel == null) {
      _adModel = AdModel();
    }

    _adModel.imageAssets = images;
  }

  void addLocation(double price, AdLocation location) {
    if (_adModel == null) {
      _adModel = AdModel();
    }
    _adModel.price = price;
    _adModel.location = location;
  }

  Future<void> uploadProfilePicture(File imgFile) async {
    print('coming here 1');
    var userId = FirebaseAuth.instance.currentUser;
    var emailForImage = userId.email;
    var uid = userId.uid;
    print('uid is $uid');
    if (imgFile != null) {
      print('coming here as well');
      final ref = FirebaseStorage.instance
          .ref()
          .child(emailForImage)
          .child('ProfilePicture')
          .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
      await ref.putFile(imgFile);
      final url = await ref.getDownloadURL();
      print('url is $url');

      await FirebaseFirestore.instance
          .collection('users')
          .doc(
            uid,
          )
          .update({'profilePicture': url});
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(
            uid,
          )
          .update({'profilePicture': ''});
    }
  }

  Future<void> uploadImage(
    File imgFile,
    String documentId,
    String senderId,
    String receiverId,
  ) async {
    var userId = FirebaseAuth.instance.currentUser;
    var emailForImage = userId.email;
    final ts = Timestamp.now();
    var uid = userId.uid;
    print('uid is $uid');
    if (imgFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child(emailForImage)
          .child('chat_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
      await ref.putFile(imgFile);
      final url = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(
            documentId,
          )
          .collection('messages')
          .add({
        'message': 'Photo',
        'imageUrl': url,
        'senderId': senderId,
        'receiverId': receiverId,
        'timeStamp': ts,
      });
      await FirebaseFirestore.instance.collection('chats').doc(documentId).set(
        {
          'docId': documentId,
          'lastMessage': 'Photo',
          'senderId': senderId,
          'timeStamp': ts,
        },
      );
    }
  }

  Future<void> pushToFirebase() async {
    var userId = FirebaseAuth.instance.currentUser;
    var emailForImage = userId.email;
    var uid = userId.uid;
    final createdAt = Timestamp.now();
    final imageChildPath = DateTime.now().toIso8601String();
    final id = DateTime.now().millisecondsSinceEpoch;
    List<String> downloadedPaths = [];
    print('email is $emailForImage');
    if (_adModel == null) {
      print('coming here null');
      _adModel = AdModel();
    }
    if (_adModel.imageAssets == null) {
      print('coming here 1');
      for (int i = 0; i < _adModel.fileImages.length; i++) {
        final ref = FirebaseStorage.instance
            .ref()
            .child(emailForImage)
            .child(imageChildPath)
            .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
        await ref.putFile(_adModel.fileImages[i]);
        final url = await ref.getDownloadURL();
        downloadedPaths.add(url);
      }
    } else if (_adModel.fileImages == null) {
      print('coming here 2');
      for (int i = 0; i < _adModel.imageAssets.length; i++) {
        ByteData byteData = await _adModel.imageAssets[i].getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        final ref = FirebaseStorage.instance
            .ref()
            .child(emailForImage)
            .child(imageChildPath)
            .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
        UploadTask uploadTask = ref.putData(imageData);
        final url = await (await uploadTask).ref.getDownloadURL();
        downloadedPaths.add(url);
      }
    }
    await FirebaseFirestore.instance
        .collection('products')
        .doc(
          id.toString(),
        )
        .set({
      'id': id,
      'createdAt': createdAt,
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
  }
}
