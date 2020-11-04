import 'package:flutter/material.dart';

import './screens/chat_screen.dart';
import './screens/auth_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.white,
          backgroundColor: Colors.indigo,
          accentColorBrightness: Brightness.dark,
          buttonTheme: ButtonTheme.of(context).copyWith(
            buttonColor: Colors.indigo,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          )),
      debugShowCheckedModeBanner: false,
      home: AuthScreen(),
      routes: {
        ChatScreen.routeName: (context) => ChatScreen(),
      },
    );
  }
}
