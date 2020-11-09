import 'package:flutter/material.dart';

import 'package:chat_app/widgets/categories/category_item.dart';
import 'package:chat_app/data/categories.dart';

class AddProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select the type of book you want to sell',
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.grey[700],
              fontFamily: 'Poppins',
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: GridView.builder(
              itemCount: Categories.categories.length,
              itemBuilder: (context, index) {
                return CategoryItem(index);
              },
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
