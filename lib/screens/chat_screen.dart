import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chatScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text('Hola'),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Firestore.instance
              .collection('chats/EPm2rHc5LsxeCDrplh8c/messages')
              .snapshots()
              .listen((data) {
            data.documents.forEach((element) {
              print(element['text']);
            });
          });
        },
      ),
    );
  }
}
