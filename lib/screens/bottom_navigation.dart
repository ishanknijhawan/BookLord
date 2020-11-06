import 'package:flutter/material.dart';

import './tabs/home_screen.dart';
import './tabs/chat_screen.dart';
import './tabs/profile_screen.dart';
import './tabs/my_ads_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  @override
  _BottomNavigationScreenState createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int selectedPageIndex = 0;
  List<Map<String, Object>> _pages;

  @override
  void initState() {
    _pages = [
      {
        'pages': HomeScreen(),
        'title': 'Home',
      },
      {
        'pages': ChatScreen(),
        'title': 'Chats',
      },
      {
        'pages': MyAds(),
        'title': 'My Ads',
      },
      {
        'pages': ProfileScreen(),
        'title': 'Profile',
      }
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pages[selectedPageIndex]['title'],
          style: TextStyle(
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: _pages[selectedPageIndex]['pages'],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        currentIndex: selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).accentColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColor,
        //showSelectedLabels: false,
        //showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            //backgroundColor: Theme.of(context).primaryColor,
            icon: selectedPageIndex == 0
                ? Icon(
                    Icons.home,
                  )
                : Icon(
                    Icons.home_outlined,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Chats',
            icon: selectedPageIndex == 1
                ? Icon(
                    Icons.chat_bubble,
                  )
                : Icon(
                    Icons.chat_bubble_outline,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'My Ads',
            icon: selectedPageIndex == 2
                ? Icon(
                    Icons.book,
                  )
                : Icon(
                    Icons.book_outlined,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: selectedPageIndex == 3
                ? Icon(
                    Icons.person,
                  )
                : Icon(
                    Icons.person_outline,
                  ),
          ),
        ],
        onTap: (index) {
          setState(() {
            selectedPageIndex = index;
          });
        },
      ),
    );
  }
}
