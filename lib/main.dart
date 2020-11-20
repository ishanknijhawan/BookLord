import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/tabs/users_chat_screen.dart';
import 'screens/auth/auth_screen.dart';
import './screens/bottom_navigation.dart';
import 'screens/add/further_cat.dart';
import 'screens/add/book_info_one.dart';
import 'provider/ad_provider.dart';
import 'screens/add/adding_images_screen.dart';
import 'screens/add/price_and_location_screen.dart';
import 'screens/home/product_detail_screen.dart';
import 'screens/chats/chat_screen.dart';
import 'screens/tabs/users_chat_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => AdProvider(),
              ),
            ],
            child: ThemeProvider(
              saveThemesOnChange: true,
              themes: [
                AppTheme(
                  id: "light_theme", // Id(or name) of the theme(Has to be unique)
                  description: 'ThemeLight',

                  data: ThemeData(
                    fontFamily: 'Roboto',
                    primarySwatch: Colors.indigo,
                    accentColor: Colors.indigo,
                    cardColor: Colors.grey[200],
                    backgroundColor: Colors.indigo,
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      backgroundColor: Colors.white,
                      selectedItemColor: Colors.indigo,
                      unselectedItemColor: Colors.indigo,
                    ),
                    scaffoldBackgroundColor: Colors.white,
                    accentColorBrightness: Brightness.dark,
                    buttonTheme: ButtonTheme.of(context).copyWith(
                      buttonColor: Colors.indigo,
                      textTheme: ButtonTextTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                AppTheme.dark(
                  id: 'dark_theme',
                ).copyWith(
                  id: 'dark_theme',
                  data: ThemeData.dark().copyWith(
                    appBarTheme: AppBarTheme(
                      color: Color(0xff2a2a2a),
                    ),
                    primaryColor: Color(0xff03dac6),
                    accentColor: Color(0xff03dac6),
                    cardColor: Color(0xff2a2a2a),
                    bottomNavigationBarTheme: BottomNavigationBarThemeData(
                      backgroundColor: Color(0xff2a2a2a),
                      selectedItemColor: Color(0xff03dac6),
                      unselectedItemColor: Color(0xff03dac6),
                    ),
                    buttonTheme: ButtonTheme.of(context).copyWith(
                      buttonColor: Color(0xff03dac6),
                      textTheme: ButtonTextTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                )
              ],
              child: ThemeConsumer(
                child: Builder(
                  builder: (themeContext) => MaterialApp(
                    title: 'BookLord',
                    theme: ThemeProvider.themeOf(themeContext).data,
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
                      stream: FirebaseAuth.instance.authStateChanges(),
                      builder: (context, snapshot) {
                        return snapshot.hasData
                            ? BottomNavigationScreen()
                            : AuthScreen();
                      },
                    ),
                    routes: {
                      UsersChatScreen.routeName: (context) => UsersChatScreen(),
                      FurtherCat.routeName: (context) => FurtherCat(),
                      BookInfoOne.routeName: (context) => BookInfoOne(),
                      AddingImagesScreen.routeName: (context) =>
                          AddingImagesScreen(),
                      PriceAndLocationScreen.routeName: (context) =>
                          PriceAndLocationScreen(),
                      BottomNavigationScreen.routeName: (context) =>
                          BottomNavigationScreen(),
                      ProductDetailScreen.routeName: (context) =>
                          ProductDetailScreen(),
                      ChatScreen.routeName: (context) => ChatScreen(),
                    },
                  ),
                ),
              ),
            ),
          );
        });
  }
}
