import 'package:chat_app/models/ad_location.dart';

import '../models/ad_model.dart';

class DummyData {
  static List<AdModel> adList = [
    AdModel(
      id: DateTime.now().toString(),
      title: 'A Book',
      userId: null,
      categories: ['category1', 'category2', 'category3'],
      location: Location(address: null, latitude: null, longitude: null),
      price: 150,
      images: [
        'https://assets.entrepreneur.com/content/3x2/2000/20191219170611-GettyImages-1152794789.jpeg',
        'https://assets.entrepreneur.com/content/3x2/2000/20191219170611-GettyImages-1152794789.jpeg'
      ],
    )
  ];
}
