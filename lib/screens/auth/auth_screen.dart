import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLoading = false;
  AuthResult authResult;

  Future<AuthResult> _signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    authResult = await FirebaseAuth.instance.signInWithCredential(credential);
    Firestore.instance
        .collection('users')
        .document(authResult.user.uid)
        .setData({
      'email': authResult.user.email,
      'name': authResult.user.displayName,
      'uid': authResult.user.uid,
      'profilePicture': authResult.user.photoUrl,
    });
    return authResult;
  }

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
          'uid': authResult.user.uid,
          'profilePicture': '',
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
      body: Container(
        margin: EdgeInsets.fromLTRB(0, 100, 0, 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Transform.rotate(
                angle: -math.pi / 18,
                child: Container(
                  padding: EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'BookLord',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Theme.of(context).primaryColor,
                      fontSize: 40,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              AuthForm(
                submitFunction,
                isLoading,
              ),
              SizedBox(
                height: 20,
              ),
              SignInButton(Buttons.Google, onPressed: _signInWithGoogle),
            ],
          ),
        ),
      ),
    );
  }
}
