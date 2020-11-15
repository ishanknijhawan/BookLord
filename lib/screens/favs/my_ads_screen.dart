import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;

import 'package:chat_app/widgets/home/ad_item.dart';

class MyAds extends StatefulWidget {
  @override
  _MyAdsState createState() => _MyAdsState();
}

class _MyAdsState extends State<MyAds> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, userData) {
          if (userData.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          }
          return StreamBuilder(
            stream: Firestore.instance
                .collection('products')
                .where('uid', isEqualTo: userData.data.uid)
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
                    return AdItem(
                      documents[i],
                      documents[i]['uid'] == userData.data.uid,
                      userData.data.uid,
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
        });
  }
}
