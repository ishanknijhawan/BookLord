import 'package:chat_app/widgets/add/info_form.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/bottom_button.dart';

class BookInfoOne extends StatefulWidget {
  static const routeName = './book_info';
  @override
  _BookInfoOneState createState() => _BookInfoOneState();
}

class _BookInfoOneState extends State<BookInfoOne> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tell us more!'),
      ),
      body: BookInfoForm(),
      // bottomNavigationBar: BottomButton(
      //   'Next',
      //   () {},
      //   Icons.arrow_forward,
      // ),
    );
  }
}
