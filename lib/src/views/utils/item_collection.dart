import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:flutter/foundation.dart';

class Collection extends ChangeNotifier {
  //late Collection _collection;
  List<Item> _itemList = [];

  void add(Item item) {
    _itemList.add(item);
    notifyListeners();
  }
}
