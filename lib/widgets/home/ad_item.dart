import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:chat_app/screens/home/product_detail_screen.dart';

class AdItem extends StatefulWidget {
  final dynamic documents;
  final bool isMe;
  final String myId;
  AdItem(
    this.documents,
    this.isMe,
    this.myId,
  );
  @override
  _AdItemState createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: InkWell(
        onTap: () => Navigator.of(context).pushNamed(
          ProductDetailScreen.routeName,
          arguments: {
            'documents': widget.documents,
            'isMe': widget.isMe,
          },
        ),
        child: GridTile(
          child: Hero(
            tag: widget.documents['id'],
            child: CachedNetworkImage(
              imageUrl: widget.documents['images'][0],
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          header: !widget.isMe
              ? Container(
                  padding: EdgeInsets.fromLTRB(0, 6, 2, 0),
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[900],
                          blurRadius: 15.0, // soften the shadow
                          spreadRadius: 2.0, //extend the shadow
                          offset: Offset(
                            5.0, // Move to right 10  horizontally
                            5.0, // Move to bottom 5 Vertically
                          ),
                        )
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('products')
                            .doc(widget.documents['id'].toString())
                            .update({'isFav': !widget.documents['isFav']});
                      },
                      alignment: Alignment.center,
                      icon: widget.documents['isFav']
                          ? Icon(
                              Icons.favorite,
                              color: Colors.red[700],
                            )
                          : Icon(
                              Icons.favorite_border,
                              color: Colors.red[700],
                            ),
                    ),
                  ),
                )
              : null,
          footer: GridTileBar(
            backgroundColor: Colors.black.withOpacity(0.54),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.documents['title'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                if (widget.documents['isSold'])
                  Text(
                    'Sold',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (!widget.documents['isSold'])
                  Text(
                    widget.documents['price'] == 0
                        ? 'Donate'
                        : '₹${widget.documents['price'].toString()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: widget.documents['price'] == 0
                          ? Colors.pink[200]
                          : Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
