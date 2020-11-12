import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;

import 'package:chat_app/widgets/home/ad_item.dart';

class FavoriteAdsScreen extends StatefulWidget {
  @override
  _FavoriteAdsScreenState createState() => _FavoriteAdsScreenState();
}

class _FavoriteAdsScreenState extends State<FavoriteAdsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid;

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    uid = user.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('products')
          .where('isFav', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
        var documents = snapshot.data.documents;
        if (snapshot.data.documents.length == 0) {
          return Center(
            child: Text('No ads here'),
          );
        }
        return Padding(
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            itemCount: documents.length,
            itemBuilder: (context, i) {
              return documents[i]['uid'] == uid
                  ? null
                  : AdItem(
                      documents[i],
                      documents[i]['uid'] == uid,
                    );
            },
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 3 / 2,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
          ),
        );
      },
    );
  }
}
