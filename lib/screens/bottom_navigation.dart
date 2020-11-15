import 'package:flutter/material.dart';

import './tabs/home_screen.dart';
import 'tabs/users_chat_screen.dart';
import './tabs/profile_screen.dart';
import 'tabs/ads_tab_screen.dart';
import 'tabs/add_product_screen.dart';

import 'package:chat_app/screens/home/search.dart';

class BottomNavigationScreen extends StatefulWidget {
  static const routeName = './bottom_navigation';
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
        'pages': AdsTabScreen(),
        'title': 'My Ads',
      },
      {
        'pages': AddProduct(),
        'title': 'Sell a Book!',
      },
      {
        'pages': UsersChatScreen(),
        'title': 'Chats',
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
      appBar: selectedPageIndex == 1
          ? null
          : AppBar(
              title: Text(
                _pages[selectedPageIndex]['title'],
                style: TextStyle(
                  fontFamily: 'Poppins',
                ),
              ),
              actions: selectedPageIndex == 0
                  ? [
                      IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          showSearch(context: context, delegate: Search());
                        },
                      )
                    ]
                  : [],
            ),
      body: _pages[selectedPageIndex]['pages'],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        iconSize: 28,
        currentIndex: selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).accentColor,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Theme.of(context).primaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            //backgroundColor: Theme.of(context).primaryColor,
            icon: selectedPageIndex == 0
                ? Icon(
                    Icons.home_rounded,
                  )
                : Icon(
                    Icons.home_outlined,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'My Ads',
            icon: selectedPageIndex == 1
                ? Icon(
                    Icons.book,
                  )
                : Icon(
                    Icons.book_outlined,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Add',
            icon: selectedPageIndex == 2
                ? Icon(
                    Icons.add_circle,
                  )
                : Icon(
                    Icons.add_circle_outline,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Chats',
            icon: selectedPageIndex == 3
                ? Icon(
                    Icons.chat_bubble,
                  )
                : Icon(
                    Icons.chat_bubble_outline,
                  ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: selectedPageIndex == 4
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
