import 'package:flutter/material.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chat_app/provider/ad_provider.dart';

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
  BuildContext ctx;
  File _storedImage;
  File _pickedImage;
  bool isLoading = false;
  var documentId = '';

  void _pickImage(BuildContext context, ImageSource src) async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.getImage(
      source: src,
      maxWidth: 600,
      imageQuality: 70,
    );

    if (pickedImageFile == null) {
      return;
    }

    _storedImage = File(pickedImageFile.path);

    //very important lines!
    final appDir = await pPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(_storedImage.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    _pickedImage = savedImage;

    if (widget.senderId.compareTo(widget.receiverId) > 0) {
      documentId = widget.receiverId + widget.senderId;
    } else {
      documentId = widget.senderId + widget.receiverId;
    }

    await Provider.of<AdProvider>(context, listen: false).uploadImage(
      _pickedImage,
      documentId,
      widget.senderId,
      widget.receiverId,
    );
  }

  void _sendMessage() async {
    //FocusScope.of(context).unfocus();
    final ts = Timestamp.now();
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
      'timeStamp': ts,
    });
    await Firestore.instance
        .collection('chats')
        .document(widget.documentId)
        .setData(
      {
        'docId': widget.documentId,
        'lastMessage': enteredMessage,
        'senderId': widget.senderId,
        'timeStamp': ts,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
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
                  suffixIcon: IconButton(
                    icon: Icon(Icons.attach_file),
                    onPressed: () => showDialog(
                      context: ctx,
                      builder: (context) {
                        return Dialog(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                onTap: () {
                                  _pickImage(
                                    ctx,
                                    ImageSource.camera,
                                  );
                                  Navigator.of(ctx).pop();
                                },
                                title: Text('Camera'),
                              ),
                              ListTile(
                                onTap: () {
                                  _pickImage(
                                    ctx,
                                    ImageSource.gallery,
                                  );
                                  Navigator.of(ctx).pop();
                                },
                                title: Text('Gallery'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
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
