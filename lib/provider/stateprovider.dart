import 'package:flutter/material.dart';

class MyProvider extends ChangeNotifier {
  List<Map<String, String?>> _items = [];
  List<Map<String, String?>> get items => _items;

  void toggleFavorite({
    String? title,
    String? imageurl,
    String? date,
    String? url,
  }) {
    final news = {
      'title': title,
      'imageurl': imageurl,
      'date': date,
      'url': url,
    };

    final isExist = _items.any((item) =>
        item['title'] == title &&
        item['imageurl'] == imageurl &&
        item['date'] == date &&
        item['url'] == url);

    if (isExist) {
      _items.removeWhere((item) =>
          item['title'] == title &&
          item['imageurl'] == imageurl &&
          item['date'] == date &&
          item['url'] == url);
    } else {
      _items.add(news);
    }
    notifyListeners();
  }

  bool isFavourite({String? title}) {
    notifyListeners();
    return _items.any((item) => item['title'] == title);
  }
}
