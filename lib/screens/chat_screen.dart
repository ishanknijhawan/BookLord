import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  static const routeName = '/chatScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatApp'),
        actions: [
          //this is one way
          // DropdownButton(
          //   icon: Icon(
          //     Icons.more_vert_outlined,
          //     color: Colors.white,
          //   ),
          //   items: [
          //     DropdownMenuItem(
          //       value: 'Logout',
          //       child: Container(
          //         child: Row(
          //           children: [
          //             Icon(
          //               Icons.logout,
          //               color: Colors.black,
          //             ),
          //             SizedBox(
          //               width: 8,
          //             ),
          //             Text('Logout'),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ],
          //   onChanged: (value) {
          //     if (value == 'Logout') {
          //       FirebaseAuth.instance.signOut();
          //     }
          //   },
          // ),

          //second way is using popup menu button
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('Logout'),
                  value: 'logout',
                ),
              ];
            },
            onSelected: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('chats/EPm2rHc5LsxeCDrplh8c/messages')
              .snapshots(),
          builder: (ctx, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var documents = snapShot.data.documents;
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, i) => Container(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    documents[i]['text'],
                  ),
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
