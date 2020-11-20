import 'package:chat_app/models/ad_location.dart';
import 'package:chat_app/models/ad_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/home/ad_item.dart';

class Search extends SearchDelegate {
  final List<dynamic> docs;
  Search(this.docs);

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
    final suggestionList = query.isEmpty
        ? docs
        : docs
            .where(
              (element) =>
                  element['title'].toString().toLowerCase().contains(query),
            )
            .toList();

    String uid = FirebaseAuth.instance.currentUser.uid;
    print('query is $query');

    // void getData() async {
    //   var data = await FirebaseFirestore.instance
    //       .collection('products')
    //       .where('isSold', isEqualTo: false)
    //       .where(('title').toLowerCase(), isEqualTo: query.toLowerCase())
    //       .get();
    //   documents = data.docs;

    //   documents.map((e) {
    //     ttList.add(AdModel(
    //       title: e.data()['title'],
    //       author: e.data()['author'],
    //       categories: e.data()['categories'],
    //       isFav: e.data()['isFav'],
    //       isSold: e.data()['isSold'],
    //       condition: e.data()['condition'],
    //       description: e.data()['description'],
    //       id: e.data()['id'],
    //       location: AdLocation(
    //         latitude: e.data()['location']['latitude'],
    //         longitude: e.data()['location']['longitude'],
    //         address: e.data()['location']['address'],
    //       ),
    //       price: e.data()['price'],
    //       userId: e.data()['uid'],
    //     ));
    //     images.add(e.data()['images'] as List<String>);
    //   });
    // }

    // void getUserData() {
    //   final user = FirebaseAuth.instance.currentUser;
    //   uid = user.uid;
    // }

    // getData();
    // getUserData();

    return Padding(
      padding: EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, i) {
          return AdItem(
            suggestionList[i],
            suggestionList[i]['uid'] == uid,
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
