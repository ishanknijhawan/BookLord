import 'package:flutter/material.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;

import 'package:chat_app/provider/ad_provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  BuildContext ctx;
  bool isLoading = false;
  File _storedImage;
  File _pickedImage;
  void _pickImage(BuildContext context, ImageSource src) async {
    final picker = ImagePicker();
    final pickedImageFile = await picker.getImage(
      source: src,
      maxWidth: 600,
      imageQuality: 70,
    );

    if (pickedImageFile == null) {
      return;
    }

    _storedImage = File(pickedImageFile.path);

    //very important lines!
    final appDir = await pPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(_storedImage.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    _pickedImage = savedImage;

    setState(() {
      isLoading = true;
    });
    await Provider.of<AdProvider>(context, listen: false)
        .uploadProfilePicture(_pickedImage);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            );
          }
          return StreamBuilder(
            stream: Firestore.instance
                .collection('users')
                .document(snapshot.data.uid)
                .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                );
              }

              return Padding(
                padding: EdgeInsets.all(32),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.black, width: 2),
                              ),
                              child: snapshot.data['profilePicture'] == ''
                                  ? SvgPicture.asset(
                                      'assets/images/boy.svg',
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      backgroundImage: NetworkImage(
                                        snapshot.data['profilePicture'],
                                      ),
                                    ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(0, 6, 2, 0),
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.amber,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[900],
                                        blurRadius: 15.0, // soften the shadow
                                        spreadRadius: 2.0, //extend the shadow
                                        offset: Offset(
                                          5.0, // Move to right 10  horizontally
                                          5.0, // Move to bottom 5 Vertically
                                        ),
                                      )
                                    ],
                                  ),
                                  child: isLoading
                                      ? CircularProgressIndicator()
                                      : IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: ctx,
                                              builder: (context) {
                                                return Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      ListTile(
                                                        onTap: () {
                                                          _pickImage(
                                                            ctx,
                                                            ImageSource.camera,
                                                          );
                                                          Navigator.of(ctx)
                                                              .pop();
                                                        },
                                                        title: Text('Camera'),
                                                      ),
                                                      ListTile(
                                                        onTap: () {
                                                          _pickImage(
                                                            ctx,
                                                            ImageSource.gallery,
                                                          );
                                                          Navigator.of(ctx)
                                                              .pop();
                                                        },
                                                        title: Text('Gallery'),
                                                      ),
                                                      ListTile(
                                                        onTap: () {
                                                          Provider.of<AdProvider>(
                                                                  ctx,
                                                                  listen: false)
                                                              .uploadProfilePicture(
                                                                  null);
                                                          Navigator.of(ctx)
                                                              .pop();
                                                        },
                                                        title: Text('Remove'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          alignment: Alignment.center,
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          snapshot.data['name'],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        RaisedButton.icon(
                          icon: Icon(
                            Icons.logout,
                          ),
                          onPressed: () => FirebaseAuth.instance.signOut(),
                          label: Text('Logout'),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }
}
