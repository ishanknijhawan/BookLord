import 'package:chat_app/models/ad_location.dart';
import 'package:chat_app/models/ad_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:chat_app/widgets/home/ad_item.dart';

class Search extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<AdModel> ttList = [];
    List<List<String>> images = [];
    List<DocumentSnapshot> documents = [];
    String uid;
    print('query is $query');

    void getData() async {
      var data = await Firestore.instance
          .collection('products')
          .where('isSold', isEqualTo: false)
          .where(('title').toLowerCase(), isEqualTo: query.toLowerCase())
          .getDocuments();
      documents = data.documents;

      documents.map((e) {
        ttList.add(AdModel(
          title: e['title'],
          author: e['author'],
          categories: e['categories'],
          isFav: e['isFav'],
          isSold: e['isSold'],
          condition: e['condition'],
          description: e['description'],
          id: e['id'],
          location: AdLocation(
            latitude: e['location']['latitude'],
            longitude: e['location']['longitude'],
            address: e['location']['address'],
          ),
          price: e['price'],
          userId: e['uid'],
        ));
        images.add(e['images'] as List<String>);
      });
    }

    void getUserData() async {
      final user = await FirebaseAuth.instance.currentUser();
      uid = user.uid;
    }

    getData();
    getUserData();

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
                  uid,
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
  }
}
