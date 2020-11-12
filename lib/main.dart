import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'screens/tabs/chat_screen.dart';
import 'screens/auth/auth_screen.dart';
import './screens/bottom_navigation.dart';
import 'screens/add/further_cat.dart';
import 'screens/add/book_info_one.dart';
import 'provider/ad_provider.dart';
import 'screens/add/adding_images_screen.dart';
import 'screens/add/price_and_location_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AdProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'BookLord',
        theme: ThemeData(
            fontFamily: 'Roboto',
            primarySwatch: Colors.indigo,
            accentColor: Colors.white,
            backgroundColor: Colors.indigo,
            scaffoldBackgroundColor: Colors.white,
            accentColorBrightness: Brightness.dark,
            textTheme: TextTheme(
              headline6: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
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
            return snapshot.hasData ? BottomNavigationScreen() : AuthScreen();
          },
        ),
        routes: {
          ChatScreen.routeName: (context) => ChatScreen(),
          FurtherCat.routeName: (context) => FurtherCat(),
          BookInfoOne.routeName: (context) => BookInfoOne(),
          AddingImagesScreen.routeName: (context) => AddingImagesScreen(),
          PriceAndLocationScreen.routeName: (context) =>
              PriceAndLocationScreen(),
          BottomNavigationScreen.routeName: (context) =>
              BottomNavigationScreen(),
        },
      ),
    );
  }
}
