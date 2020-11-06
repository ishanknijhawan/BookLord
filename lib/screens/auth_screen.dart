import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import '../widgets/auth/auth_form.dart';
import 'tabs/chat_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  void submitFunction(
    String userName,
    String email,
    String password,
    bool isLogin,
    BuildContext context,
  ) async {
    try {
      setState(() {
        isLoading = true;
      });
      AuthResult authResult;
      if (!isLogin) {
        authResult = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Firestore.instance
            .collection('users')
            .document(authResult.user.uid)
            .setData({
          'email': email,
          'name': userName,
        });
        //not needed if using StreamBuilder in main.dart
        // Navigator.of(context).pushNamed(
        //   ChatScreen.routeName,
        // );
      } else {
        authResult = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        //not needed if using StreamBuilder in main.dart
        // Navigator.of(context).pushNamed(
        //   ChatScreen.routeName,
        // );
      }
    } on PlatformException catch (error) {
      setState(() {
        isLoading = false;
      });
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occured, please check your credentials'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(
        submitFunction,
        isLoading,
      ),
    );
  }
}
