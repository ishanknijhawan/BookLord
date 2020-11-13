import 'package:chat_app/screens/bottom_navigation.dart';
import 'package:chat_app/widgets/bottom_button.dart';
import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/provider/ad_provider.dart';
import 'package:chat_app/models/ad_location.dart';

class PriceAndLocationScreen extends StatefulWidget {
  static const routeName = './price_and_location_screen';
  @override
  _PriceAndLocationScreenState createState() => _PriceAndLocationScreenState();
}

class _PriceAndLocationScreenState extends State<PriceAndLocationScreen> {
  var isDonate = false;
  var currLocation = '';
  double latitude = 0.0;
  double longitude = 0.0;
  var containerHeight = 80.0;
  var textController = TextEditingController();
  var isLoading = false;

  Future<void> getUserLocation() async {
    final location = Location();

    final locData = await location.getLocation();
    latitude = locData.latitude;
    longitude = locData.longitude;
    setState(() {
      currLocation = '$latitude,$longitude';
    });
  }

  Future<void> submitLocation() async {
    Provider.of<AdProvider>(
      context,
      listen: false,
    ).addLocation(
      double.parse(textController.text),
      AdLocation(
        latitude: latitude,
        longitude: longitude,
        address: '',
      ),
    );
    setState(() {
      isLoading = true;
    });
    await Provider.of<AdProvider>(
      context,
      listen: false,
    ).pushToFirebase();
    setState(() {
      isLoading = false;
    });
    Navigator.of(context)
        .pushReplacementNamed(BottomNavigationScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget appBar = AppBar(
      title: Text('Enter the price'),
    );
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          height: (MediaQuery.of(context).size.height -
              appBar.preferredSize.height -
              MediaQuery.of(context).padding.top),
          child: isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Sit back and relax, while we post your ad!',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: containerHeight,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: textController,
                              decoration: InputDecoration(
                                prefix: Text(
                                  '₹',
                                  style: TextStyle(fontSize: 20),
                                ),
                                labelText: 'Price',
                                labelStyle: TextStyle(
                                    fontSize: 20, fontFamily: 'Poppins'),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'I want to donate this book',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 17,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          IconButton(
                            icon: isDonate
                                ? Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 40,
                                  )
                                : Icon(
                                    Icons.favorite_border,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                            onPressed: () {
                              setState(() {
                                if (isDonate) {
                                  containerHeight = 80;
                                } else {
                                  containerHeight = 0;
                                }
                                isDonate = !isDonate;
                              });
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text('No location selected'),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          OutlinedButton.icon(
                            icon: Icon(
                              Icons.location_on_outlined,
                            ),
                            label: Text('Use Current location'),
                            onPressed: getUserLocation,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: BottomButton(
                        'Post',
                        submitLocation,
                        Icons.post_add_outlined,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
