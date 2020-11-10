import 'package:flutter/cupertino.dart';

import '../models/ad_model.dart';
import '../data/categories.dart';

class AdProvider with ChangeNotifier {
  List<AdModel> _items = [];
  AdModel _adModel = AdModel();
  var cats = Categories.storedCategories;

  List<AdModel> get items {
    return [..._items];
  }

  void addCategory(String cat) {
    cats.add(cat);
  }

  void addTitleAndStuff(String title, String desc, String condition) {
    if (_adModel == null) {
      _adModel = AdModel();
    }

    _adModel.title = title;
    _adModel.condition = condition;
    _adModel.description = desc;
  }
}
