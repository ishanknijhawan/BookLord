import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function fn;

  BottomButton(this.title, this.fn, this.icon);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 17, fontFamily: 'Poppins'),
            ),
            SizedBox(
              width: 15,
            ),
            Icon(icon),
          ],
        ),
      ),
      onPressed: fn,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      color: Theme.of(context).primaryColor,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
