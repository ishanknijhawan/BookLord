import 'package:chat_app/screens/tabs/users_chat_screen.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/models/user.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:chat_app/widgets/chat/messages.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = './chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context).settings.arguments as UserModel;
    print('data is $userData');
    print('name is ${userData.userName}');
    print('email is ${userData.email}');
    print('profile is ${userData.profilePicture}');
    print('uid is ${userData.uid}');
    var documentId = '';

    final uid = FirebaseAuth.instance.currentUser.uid;

    if (userData.uid.compareTo(uid) > 0) {
      documentId = uid + userData.uid;
    } else {
      documentId = userData.uid + uid;
    }

    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: EdgeInsets.fromLTRB(15, 0, 0, 0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              userData.profilePicture != ''
                  ? CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(
                        userData.profilePicture,
                      ),
                    )
                  : Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        'assets/images/boy.svg',
                      ),
                    ),
            ],
          ),
        ),
        title: Text(userData.userName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Messages(
              documentId: documentId,
              senderId: uid,
              receiverId: userData.uid,
            ),
          ),
          NewMessage(
            documentId: documentId,
            senderId: uid,
            receiverId: userData.uid,
          ),
        ],
      ),
    );
  }
}
