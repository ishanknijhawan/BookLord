import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

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
      //typical android way
      // home: FirebaseAuth.instance.currentUser() == null
      //     ? AuthScreen()
      //     : ChatScreen(),

      //alternatinve way, here the screen will get changed as soon as
      //the authstate changes
      //you don't need to call navigator.of.pushnamed in auth screen as
      //this method will get called as soon as the authstate changes
      home: StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (context, snapshot) {
          return snapshot.hasData ? ChatScreen() : AuthScreen();
        },
      ),
      routes: {
        ChatScreen.routeName: (context) => ChatScreen(),
      },
    );
  }
}
