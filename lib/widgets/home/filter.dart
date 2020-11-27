import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  final Function(RangeValues rv) range;
  Filter(this.range);
  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  RangeValues rv = RangeValues(0, 2000);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Price',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        RangeSlider(
          key: ValueKey('price'),
          min: 0,
          max: 2000,
          values: rv,
          onChanged: (value) {
            setState(() {
              rv = value;
            });
          },
          divisions: 100,
          labels: RangeLabels(
            rv.start.toStringAsFixed(0),
            rv.end.toStringAsFixed(0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: Text('Apply'),
            onPressed: () => widget.range(rv),
          ),
        )
      ],
    );
  }
}
