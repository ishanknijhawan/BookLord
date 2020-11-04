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
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('chats/EPm2rHc5LsxeCDrplh8c/messages')
              .snapshots(),
          builder: (ctx, snapShot) {
            var documents = snapShot.data.documents;
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, i) => Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(documents[i]['text']),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Firestore.instance
              .collection('chats/EPm2rHc5LsxeCDrplh8c/messages')
              .add(
            {'text': 'Hi There'},
          );
        },
      ),
    );
  }
}
