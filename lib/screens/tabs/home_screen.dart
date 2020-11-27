import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';

import 'package:chat_app/widgets/home/ad_item.dart';
import 'package:chat_app/screens/home/search.dart';
import 'package:chat_app/provider/ad_provider.dart';
import 'package:chat_app/models/ad_model.dart';
import 'package:chat_app/models/ad_location.dart';
import 'package:chat_app/widgets/home/filter.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final uid = FirebaseAuth.instance.currentUser.uid;
  List<dynamic> documents = [];
  List<AdModel> prods = [];
  bool isProd = false;
  double distance;
  RangeValues range = RangeValues(0, 2000);

  void setFilters(RangeValues rv) {
    print('coming here set filters 2');
    print('start is ${rv.start}');
    setState(() {
      range = rv;
      prods = prods.where(
        (element) {
          print('element price is ${element.price}');
          print('range start is ${range.start} and ${range.end}');
          return (element.price >= range.start) && (element.price <= range.end);
        },
      ).toList();
      isProd = true;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_alt_outlined),
            onPressed: () {
              return showDialog(
                context: context,
                builder: (context) {
                  return Dialog(
                    child: Filter(
                      setFilters,
                    ),
                  );
                },
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.sort_outlined,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        'Sort by',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () async {
                        final location = Location();
                        print('coming here 111');
                        final locData = await location.getLocation();

                        print(
                            'locations is ${locData.latitude},${locData.longitude}');

                        for (int i = 0; i < prods.length; i++) {
                          prods[i].fromLoc =
                              Provider.of<AdProvider>(context, listen: false)
                                  .getDistanceFromCoordinates2(
                            prods[i].location.latitude,
                            prods[i].location.longitude,
                            locData.latitude,
                            locData.longitude,
                          );
                          print('distance is ${(prods[i].fromLoc)}');
                        }

                        prods.sort((m1, m2) {
                          return m1.fromLoc.compareTo(m2.fromLoc);
                        });
                        print(
                          prods.map(
                            (e) => print('final distance is ${e.fromLoc}'),
                          ),
                        );
                        setState(() {
                          isProd = true;
                        });
                        Navigator.of(context).pop();
                      },
                      title: Text(
                        'Nearest first',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          isProd = false;
                        });
                        Navigator.of(context).pop();
                      },
                      title: Text(
                        'Recents first',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () => showSearch(
              context: context,
              delegate: Search(documents),
            ),
          )
        ],
      ),
      body: isProd
          ? Padding(
              padding: EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: prods.length,
                itemBuilder: (context, i) {
                  dynamic document = {
                    'id': prods[i].id,
                    'title': prods[i].title,
                    'author': prods[i].author,
                    'description': prods[i].description,
                    'price': prods[i].price,
                    'condition': prods[i].condition,
                    'images': prods[i].images,
                    'createdAt': prods[i].createdAt,
                    'categories': prods[i].categories,
                    'location': {
                      'latitude': prods[i].location.latitude,
                      'longitude': prods[i].location.longitude,
                      'address': prods[i].location.address,
                    },
                    'isFav': prods[i].isFav,
                    'isSold': prods[i].isSold,
                    'uid': prods[i].userId,
                  };

                  return AdItem(
                    document,
                    document['uid'] == uid,
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
            )
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .orderBy('createdAt', descending: true)
                  //.where('isSold', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final fcm = FirebaseMessaging();
                fcm.getToken().then((token) => FirebaseFirestore.instance
                        .collection('users')
                        .doc(uid)
                        .update(
                      {'token': token},
                    ));

                documents = snapshot.data.documents;

                prods = documents
                    .map<AdModel>(
                      (documents) => AdModel(
                        id: documents['id'].toString(),
                        createdAt: documents['createdAt'],
                        price: documents['price'],
                        title: documents['title'],
                        author: documents['author'],
                        categories: documents['categories'],
                        description: documents['description'],
                        images: documents['images'],
                        userId: documents['uid'],
                        location: AdLocation(
                          latitude: documents['location']['latitude'],
                          longitude: documents['location']['longitude'],
                          address: documents['location']['address'],
                        ),
                        condition: documents['condition'],
                        isSold: documents['isSold'],
                        isFav: documents['isFav'],
                        fromLoc: 0.0,
                      ),
                    )
                    .toList();

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
              },
            ),
    );
  }
}
