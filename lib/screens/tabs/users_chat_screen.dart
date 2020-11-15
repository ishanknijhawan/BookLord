import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'package:chat_app/screens/chats/chat_screen.dart';
import 'package:chat_app/models/user.dart';

class UsersChatScreen extends StatelessWidget {
  static const routeName = '/chatScreen';
  var docId;
  var receiverId;
  var receiverName;
  var receiverProfile;
  var receiverEmail;

  // Future<void> getUserByReceiverId(String id) async {
  //   final user =
  //       await Firestore.instance.collection('users').document(id).get();
  //   receiverName = user.data['name'];
  //   receiverProfile = user.data['profilePicture'];
  //   receiverEmail = user.data['email'];
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (context, userData) {
            if (userData.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              );
            }
            return StreamBuilder(
              stream: Firestore.instance.collection('chats').snapshots(),
              builder: (context, snapShot) {
                if (snapShot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                  );
                }
                var documents = snapShot.data.documents;

                //14th commit
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    docId = documents[index]['docId'].toString();
                    if (docId.contains(userData.data.uid)) {
                      receiverId =
                          docId.replaceAll(userData.data.uid, '').trim();

                      return FutureBuilder(
                          future: Firestore.instance
                              .collection('users')
                              .document(receiverId)
                              .get(),
                          builder: (context, receiverData) {
                            if (receiverData.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            }
                            receiverEmail = receiverData.data['email'];
                            receiverName = receiverData.data['name'];
                            receiverProfile =
                                receiverData.data['profilePicture'];
                            return Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 0,
                              ),
                              child: ListTile(
                                onTap: () => Navigator.of(context).pushNamed(
                                  ChatScreen.routeName,
                                  arguments: User(
                                    userName: receiverName,
                                    email: receiverEmail,
                                    profilePicture: receiverProfile,
                                    uid: receiverId,
                                  ),
                                ),
                                leading: receiverProfile == ''
                                    ? Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle),
                                        child: SvgPicture.asset(
                                            'assets/images/boy.svg'),
                                      )
                                    : CircleAvatar(
                                        radius: 25,
                                        backgroundImage:
                                            NetworkImage(receiverProfile),
                                      ),
                                title: Text(
                                  receiverName,
                                  style: TextStyle(fontSize: 20),
                                ),
                                subtitle: Text(
                                  documents[index]['senderId'] == receiverId
                                      ? documents[index]['lastMessage']
                                      : 'You: ${documents[index]['lastMessage']}',
                                ),
                                trailing: Text(
                                  DateFormat('HH:mm').format(
                                    (documents[index]['timeStamp'] as Timestamp)
                                        .toDate(),
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            );
                          });
                    } else
                      return Container();
                  },
                );
              },
            );
          }),
    );
  }
}
