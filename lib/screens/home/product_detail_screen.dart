import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:chat_app/models/ad_location.dart';
import 'package:chat_app/provider/ad_provider.dart';
import 'package:chat_app/screens/chats/chat_screen.dart';
import 'package:chat_app/models/user.dart';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = './product_detail_screen';
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final Map<int, String> cal = {
    1: 'Jan',
    2: 'Fab',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };
  int current = 0;
  AdLocation loc;
  BuildContext ctx;
  var docId;

  void deleteAd(BuildContext ctx) async {
    Navigator.of(ctx).pop();
    await Firestore.instance
        .collection('products')
        .document(
          docId.toString(),
        )
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    User userData;
    final args =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    final DocumentSnapshot documents = args['documents'];
    docId = documents['id'];
    final bool isMe = args['isMe'];
    final images = documents['images'] as List<dynamic>;
    Timestamp dateTime = documents['createdAt'];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          documents['title'],
        ),
        actions: isMe
            ? [
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      child: Text('Delete this Ad'),
                      value: 'delete',
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'delete') {
                      showDialog(
                        context: ctx,
                        builder: (context) => AlertDialog(
                          title: Text('Delete this Ad ?'),
                          content:
                              Text('Are you sure you want to delete this ad ?'),
                          actions: [
                            FlatButton(
                              child: Text(
                                'NO',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            RaisedButton(
                              color: Theme.of(context).primaryColor,
                              textColor: Colors.white,
                              child: Text('YES'),
                              onPressed: () {
                                deleteAd(context);
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        ),
                      );
                    }
                  },
                ),
              ]
            : [],
      ),
      body: FutureBuilder(
          future: Provider.of<AdProvider>(context).getUserDataFromUid(
            documents['uid'],
          ),
          builder: (context, userSnapshot) {
            userData = userSnapshot.data;
            return FutureBuilder(
                future: Provider.of<AdProvider>(context, listen: false)
                    .getDistanceFromCoordinates(
                  documents['location']['latitude'] as double,
                  documents['location']['longitude'] as double,
                ),
                builder: (context, locSnapshot) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Hero(
                                tag: documents['id'],
                                child: CarouselSlider.builder(
                                  itemCount: images.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      width: double.infinity,
                                      height: 200,
                                      child: Image.network(
                                        images[i],
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                  //₹
                                  options: CarouselOptions(
                                    height: 200.0,
                                    enableInfiniteScroll: false,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        current = index;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 0,
                                right: 0,
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: images.map((url) {
                                      int index = images.indexOf(url);
                                      return Container(
                                        width: 8.0,
                                        height: 8.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: current == index
                                              ? Theme.of(context).accentColor
                                              : Colors.grey,
                                        ),
                                      );
                                    }).toList()),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              documents['description'],
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '₹${documents['price']}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.menu_book_outlined,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(
                                            documents['condition'] +
                                                ' condition',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: locSnapshot.connectionState ==
                                                  ConnectionState.waiting
                                              ? Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    backgroundColor:
                                                        Colors.black,
                                                  ),
                                                )
                                              : Text(
                                                  '${locSnapshot.data} kms from your location',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                  ),
                                                ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_today,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Posted on',
                                          style:
                                              TextStyle(fontFamily: 'Poppins'),
                                        ),
                                        Text(
                                          cal[dateTime.toDate().month] +
                                              ' ' +
                                              dateTime.toDate().day.toString(),
                                          style:
                                              TextStyle(fontFamily: 'Poppins'),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.indigo.withOpacity(
                                  0.2,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  userSnapshot.data.profilePicture == ''
                                      ? Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          child: SvgPicture.asset(
                                              'assets/images/boy.svg'),
                                        )
                                      : CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            userSnapshot.data.profilePicture,
                                          ),
                                        ),
                                  SizedBox(
                                    width: 25,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Ad Posted by',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        isMe
                                            ? 'You'
                                            : userSnapshot.data.userName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              child: Center(
                                child: Text('No location'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 70,
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }),
      floatingActionButton: !isMe
          ? FloatingActionButton.extended(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              elevation: 15,
              label: Text('Chat'),
              icon: Icon(
                Icons.chat_bubble_outline,
              ),
              onPressed: () => Navigator.of(context).pushNamed(
                ChatScreen.routeName,
                arguments: userData,
              ),
            )
          : null,
    );
  }
}
