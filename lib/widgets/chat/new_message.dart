import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  final String documentId;
  final String senderId;
  final String receiverId;
  NewMessage({
    this.documentId,
    this.senderId,
    this.receiverId,
  });
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController messageController = TextEditingController();
  var enteredMessage = '';

  void _sendMessage() async {
    //FocusScope.of(context).unfocus();
    messageController.clear();
    await Firestore.instance
        .collection('chats')
        .document(widget.documentId)
        .collection('messages')
        .add({
      'message': enteredMessage,
      'imageUrl': '',
      'senderId': widget.senderId,
      'receiverId': widget.receiverId,
      'timeStamp': Timestamp.now(),
    });
    await Firestore.instance
        .collection('chats')
        .document(widget.documentId)
        .setData(
      {'docId': widget.documentId},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                right: 10,
              ),
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  //background color of box
                  BoxShadow(
                    color: Colors.grey[500],
                    blurRadius: 25.0, // soften the shadow
                    spreadRadius: 2.0, //extend the shadow
                    offset: Offset(
                      -15.0, // Move to right 10  horizontally
                      15.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    enteredMessage = value;
                  });
                },
                controller: messageController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Start typing...',
                  suffixIcon: Icon(
                    Icons.attach_file,
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: enteredMessage.isEmpty
                  ? Colors.grey
                  : Theme.of(context).primaryColor,
            ),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              onPressed: enteredMessage.isEmpty ? null : _sendMessage,
            ),
          )
        ],
      ),
    );
  }
}
