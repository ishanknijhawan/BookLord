import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math' as math;

import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as pPath;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/provider/ad_provider.dart';
import 'package:chat_app/widgets/bottom_button.dart';
import 'package:chat_app/screens/add/price_and_location_screen.dart';

class AddingImagesScreen extends StatefulWidget {
  static const routeName = './adding_images_screen';
  @override
  _AddingImagesScreenState createState() => _AddingImagesScreenState();
}

class _AddingImagesScreenState extends State<AddingImagesScreen> {
  File _storedImage;
  File _pickedImage;
  int current = 0;
  List<File> pathList = [];
  bool isCamera = true;
  List<Asset> images = List<Asset>();
  String _error;
  var listt = [];

  Future<void> loadAssets() async {
    isCamera = false;
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 3,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
    if (resultList == null) return;

    setState(() {
      images = resultList;
      listt = images;
      if (error == null) _error = 'No Error Dectected';
    });
  }

  Future<void> _takePicture() async {
    isCamera = true;
    final picker = ImagePicker();
    final imageUri = await picker.getImage(
      source: ImageSource.camera,
      maxWidth: 600,
      imageQuality: 70,
    );
    if (imageUri == null) {
      return;
    }

    setState(() {
      _storedImage = File(imageUri.path);
      pathList.add(_storedImage);
      listt = pathList;
    });
    //very important lines!
    final appDir = await pPath.getApplicationDocumentsDirectory();
    final fileName = path.basename(_storedImage.path);
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    _pickedImage = savedImage;
  }

  void submitImage() {
    if (isCamera) {
      Provider.of<AdProvider>(context, listen: false).addImagePaths(pathList);
    } else {
      Provider.of<AdProvider>(context, listen: false).addImageAssets(images);
    }
    Navigator.of(context).pushNamed(PriceAndLocationScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    BuildContext ctx = context;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add some images'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 250,
                  child: listt.isEmpty
                      ? Center(
                          child: Text('No Image Selected'),
                        )
                      : Stack(children: [
                          CarouselSlider(
                            items: isCamera
                                ? pathList.map((e) {
                                    return Image.file(e);
                                  }).toList()
                                : List.generate(images.length, (index) {
                                    Asset asset = images[index];
                                    return AssetThumb(
                                      asset: asset,
                                      width: 300,
                                      height: 250,
                                    );
                                  }),
                            options: CarouselOptions(
                              height: 250.0,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  current = index;
                                });
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: isCamera
                                  ? pathList.map((url) {
                                      int index = pathList.indexOf(url);
                                      return Container(
                                        width: 8.0,
                                        height: 8.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: current == index
                                              ? Theme.of(context).accentColor
                                              : Colors.grey,
                                        ),
                                      );
                                    }).toList()
                                  : images.map((url) {
                                      int index = images.indexOf(url);
                                      return Container(
                                        width: 8.0,
                                        height: 8.0,
                                        margin: EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 2.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: current == index
                                              ? Theme.of(context).accentColor
                                              : Colors.grey,
                                        ),
                                      );
                                    }).toList(),
                            ),
                          )
                        ]),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: listt.length < 3
                              ? _takePicture
                              : () => showDialog(
                                    context: ctx,
                                    builder: (context) {
                                      return AlertDialog(
                                        content:
                                            Text('You can add upto 3 photos'),
                                        actions: [
                                          FlatButton(
                                            child: Text('OK'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          )
                                        ],
                                      );
                                    },
                                  ),
                          splashColor: Theme.of(context).primaryColor,
                          child: Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.width / 3 - 10,
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  size: 40,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                _storedImage == null
                                    ? Text(
                                        'Camera',
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      )
                                    : Text(
                                        'Add More',
                                        style: TextStyle(fontFamily: 'Poppins'),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: loadAssets,
                            splashColor: Theme.of(context).primaryColor,
                            child: Container(
                              alignment: Alignment.center,
                              height:
                                  MediaQuery.of(context).size.width / 3 - 10,
                              color: Colors.grey[200],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    size: 40,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Gallery',
                                    style: TextStyle(fontFamily: 'Poppins'),
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Container(
                            color: Theme.of(context).accentColor,
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Transform.rotate(
                          angle: math.pi / 12,
                          child: Icon(
                            Icons.lightbulb_outline,
                            color: Colors.amber,
                            size: 35,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tip!',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Try to upload pictures of any page or table of contents for better chances of selling!',
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BottomButton(
            'Next',
            submitImage,
            Icons.arrow_forward,
          ),
        ],
      ),
    );
  }
}
