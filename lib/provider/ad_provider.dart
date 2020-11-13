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

  Future<User> getUserDataFromUid(String uid) async {
    final userData =
        await Firestore.instance.collection('users').document(uid).get();
    final user = User();
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

  void addLocation(double price, AdLocation location) {
    if (_adModel == null) {
      _adModel = AdModel();
    }
    _adModel.price = price;
    _adModel.location = location;
  }

  Future<void> uploadProfilePicture(File imgFile) async {
    print('coming here 1');
    var userId = await FirebaseAuth.instance.currentUser();
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
      await ref.putFile(imgFile).onComplete;
      final url = await ref.getDownloadURL();
      print('url is $url');

      await Firestore.instance
          .collection('users')
          .document(
            uid,
          )
          .updateData({'profilePicture': url});
    } else {
      await Firestore.instance
          .collection('users')
          .document(
            uid,
          )
          .updateData({'profilePicture': ''});
    }
  }

  Future<void> uploadImage(
    File imgFile,
    String documentId,
    String senderId,
    String receiverId,
  ) async {
    var userId = await FirebaseAuth.instance.currentUser();
    var emailForImage = userId.email;
    var uid = userId.uid;
    print('uid is $uid');
    if (imgFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child(emailForImage)
          .child('chat_images')
          .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
      await ref.putFile(imgFile).onComplete;
      final url = await ref.getDownloadURL();

      await Firestore.instance
          .collection('chats')
          .document(
            documentId,
          )
          .collection('messages')
          .add({
        'message': '',
        'imageUrl': url,
        'senderId': senderId,
        'receiverId': receiverId,
        'timeStamp': Timestamp.now(),
      });
      await Firestore.instance.collection('chats').document(documentId).setData(
        {
          'docId': documentId,
          'lastMessage': 'Photo',
          'senderId': senderId,
        },
      );
    }
  }

  Future<void> pushToFirebase() async {
    var userId = await FirebaseAuth.instance.currentUser();
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
      for (int i = 0; i < _adModel.images.length; i++) {
        final ref = FirebaseStorage.instance
            .ref()
            .child(emailForImage)
            .child(imageChildPath)
            .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
        await ref.putFile(_adModel.images[i]).onComplete;
        final url = await ref.getDownloadURL();
        downloadedPaths.add(url);
      }
    } else if (_adModel.images == null) {
      print('coming here 2');
      for (int i = 0; i < _adModel.imageAssets.length; i++) {
        ByteData byteData = await _adModel.imageAssets[i].getByteData();
        List<int> imageData = byteData.buffer.asUint8List();
        final ref = FirebaseStorage.instance
            .ref()
            .child(emailForImage)
            .child(imageChildPath)
            .child(DateTime.now().millisecondsSinceEpoch.toString() + '.jpg');
        StorageUploadTask uploadTask = ref.putData(imageData);
        final url = await (await uploadTask.onComplete).ref.getDownloadURL();
        downloadedPaths.add(url);
      }
    }
    await Firestore.instance
        .collection('products')
        .document(
          id.toString(),
        )
        .setData({
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
