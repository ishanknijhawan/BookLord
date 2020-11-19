import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fauth;
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:chat_app/widgets/home/ad_item.dart';
import 'package:chat_app/provider/ad_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

          final firebaseMessaging = FirebaseMessaging();
          firebaseMessaging.getToken().then((token) => Firestore.instance
                  .collection('users')
                  .document(userData.data.uid)
                  .updateData(
                {'token': token},
              ));

          return StreamBuilder(
            stream: Firestore.instance
                .collection('products')
                .orderBy('createdAt', descending: true)
                //.where('isSold', isEqualTo: false)
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
