import 'package:flutter/material.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:chat_app/provider/ad_provider.dart';
import 'package:chat_app/widgets/profile/image_picker_button.dart';
import 'package:chat_app/widgets/profile/profile_switches.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  BuildContext ctx;
  bool isLoading = false;
  File _storedImage;
  File _pickedImage;

  void _signOut() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
  }

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
                padding: EdgeInsets.all(0),
                child: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Stack(
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
                                  child: ImagePickerButton(
                                    isLoading: isLoading,
                                    ctx: ctx,
                                    pickImage: _pickImage,
                                    profilePic: snapshot.data['profilePicture'],
                                  )),
                            ],
                          ),
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
                          height: 5,
                        ),
                        Text(
                          snapshot.data['email'],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ProfileSwitches(),
                        SizedBox(
                          height: 25,
                        ),
                        RaisedButton.icon(
                          icon: Icon(
                            Icons.logout,
                          ),
                          onPressed: () => showDialog(
                              context: ctx,
                              builder: (context) => AlertDialog(
                                    title: Text('Logout ?'),
                                    content: Text('Do you want to log out ?'),
                                    actions: [
                                      FlatButton(
                                        child: Text(
                                          'NO',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                      ),
                                      RaisedButton(
                                        child: Text('YES'),
                                        onPressed: () {
                                          _signOut();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  )),
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
