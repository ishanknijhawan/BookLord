import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:chat_app/provider/ad_provider.dart';
import 'package:chat_app/screens/add/adding_images_screen.dart';
import 'package:chat_app/widgets/bottom_button.dart';

class BookInfoForm extends StatefulWidget {
  @override
  _BookInfoFormState createState() => _BookInfoFormState();
}

class _BookInfoFormState extends State<BookInfoForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String desc = '';
  String author = '';
  String _prevValue = '';
  Map<String, String> sliderValueMap = {
    '0': 'Ughh',
    '25': 'Managable',
    '50': 'Good',
    '75': 'Rarely used',
    '100': 'Brand New',
  };
  var sliderValue = 50.0;
  //var textController = TextEditingController();
  var counterText = 0;
  var isLogin = true;

  void trySubmit() {
    final isValidate = _formKey.currentState.validate();
    //to remove soft keyboard after submitting
    FocusScope.of(context).unfocus();
    if (isValidate) {
      _formKey.currentState.save();
      Provider.of<AdProvider>(
        context,
        listen: false,
      ).addTitleAndStuff(
        title,
        desc,
        author,
        sliderValueMap[sliderValue.toInt().toString()],
      );
      Navigator.of(context).pushNamed(AddingImagesScreen.routeName);
    }
  }

  Widget counter(
    BuildContext context, {
    int currentLength,
    int maxLength,
    bool isFocused,
  }) {
    return Text(
      '$currentLength/$maxLength',
      style: TextStyle(
        color: Colors.grey,
      ),
      semanticsLabel: 'character count',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        key: ValueKey('title'),
                        validator: (value) {
                          if (value.length > 10) {
                            return null;
                          } else {
                            return 'Title should be more than 10 characters';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Title',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        onSaved: (newValue) {
                          title = newValue;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        key: ValueKey('author'),
                        validator: (value) {
                          if (value.length > 7) {
                            return null;
                          } else {
                            return 'Aurhor name should be more than 7 characters';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Author',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        onSaved: (newValue) {
                          author = newValue;
                        },
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        key: ValueKey('desc'),
                        onChanged: (value) {
                          if (_prevValue.length > value.length) {
                            setState(() {
                              counterText--;
                            });
                          } else {
                            setState(() {
                              counterText++;
                            });
                          }
                          _prevValue = value;
                        },
                        validator: (value) {
                          if (value.length > 15) {
                            return null;
                          } else {
                            return 'description must be atleast 15 characters';
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: InputDecoration(
                          alignLabelWithHint: true,
                          counterText: '$counterText/100',
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        onSaved: (newValue) {
                          desc = newValue;
                        },
                        maxLength: 100,
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      Text(
                        'Select the condition of book',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                        ),
                      ),
                      Slider.adaptive(
                        value: sliderValue,
                        min: 0,
                        max: 100,
                        divisions: 4,
                        label: sliderValueMap[sliderValue.toInt().toString()],
                        onChanged: (value) {
                          setState(() {
                            sliderValue = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        BottomButton(
          'Next',
          trySubmit,
          Icons.arrow_forward,
        ),
      ],
    );
  }
}
