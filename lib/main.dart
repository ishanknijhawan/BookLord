import 'package:flutter/material.dart';

import './screens/chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
      routes: {
        ChatScreen.routeName: (context) => ChatScreen(),
      },
    );
  }
}
