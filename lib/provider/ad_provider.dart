import 'package:flutter/cupertino.dart';

import '../models/ad_model.dart';

class AdProvider with ChangeNotifier {
  List<AdModel> _items = [];

  List<AdModel> get items {
    return [..._items];
  }
}
