import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:flutter/foundation.dart';

class Collection extends ChangeNotifier {
  late Collection _collection;

  Collection get collection => _collection;
  //late Collection _collection;
  List<Item> itemList = [];

  void add(Item item) {
    itemList.add(item);
    notifyListeners();
  }

  void remove(Item item) {
    itemList.remove(item);
    notifyListeners();
  }

  void edit(Item item) {
    int i = itemList.indexOf(item);
    itemList[i] = item;

    notifyListeners();
  }

  void sortByText() {
    itemList.sort((a, b) => a.text.compareTo(b.text));
    notifyListeners();
  }
}
