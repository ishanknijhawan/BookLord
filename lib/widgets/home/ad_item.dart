import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class AdItem extends StatefulWidget {
  final dynamic documents;
  AdItem(
    this.documents,
  );
  @override
  _AdItemState createState() => _AdItemState();
}

class _AdItemState extends State<AdItem> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: GridTile(
        child: Image.network(
          widget.documents['images'][0],
          fit: BoxFit.cover,
        ),
        header: Container(
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
                Firestore.instance
                    .collection('products')
                    .document(widget.documents['id'].toString())
                    .updateData({'isFav': !widget.documents['isFav']});
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
        ),
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
              Text(
                '₹${widget.documents['price'].toString()}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
