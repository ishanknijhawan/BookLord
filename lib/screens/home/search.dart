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
    var suggestionList = [];
    var donateList = [];
    if (query.contains('donate:')) {
      final queryDonate = query.replaceAll('donate:', '');
      donateList = docs
          .where(
            (element) => (element['price'] as double) == 0,
          )
          .toList();
      suggestionList = query.isEmpty
          ? donateList
          : donateList
              .where(
                (element) =>
                    element['title']
                        .toString()
                        .trim()
                        .toLowerCase()
                        .contains(queryDonate.trim()) ||
                    element['description']
                        .toString()
                        .trim()
                        .toLowerCase()
                        .contains(queryDonate.trim()) ||
                    element['author']
                        .toString()
                        .trim()
                        .toLowerCase()
                        .contains(queryDonate.trim()),
              )
              .toList();
    } else {
      suggestionList = query.isEmpty
          ? docs
          : docs
              .where(
                (element) =>
                    element['title']
                        .toString()
                        .trim()
                        .toLowerCase()
                        .contains(query.trim()) ||
                    element['description']
                        .toString()
                        .trim()
                        .toLowerCase()
                        .contains(query.trim()) ||
                    element['author']
                        .toString()
                        .toLowerCase()
                        .trim()
                        .contains(query.trim()),
              )
              .toList();
    }

    String uid = FirebaseAuth.instance.currentUser.uid;

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
