import 'package:flutter/material.dart';

import '../favs/my_ads_screen.dart';
import '../favs/favorite_ads_screen.dart';

class AdsTabScreen extends StatefulWidget {
  @override
  _AdsTabScreenState createState() => _AdsTabScreenState();
}

class _AdsTabScreenState extends State<AdsTabScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: new AppBar(
          elevation: 5,
          flexibleSpace: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new TabBar(
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: TextStyle(
                  fontSize: 17,
                ),
                tabs: [
                  Tab(
                    text: '   Posted   ',
                  ),
                  Tab(
                    text: '  Favorites  ',
                  ),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyAds(),
            FavoriteAdsScreen(),
          ],
        ),
      ),
    );
  }
}
