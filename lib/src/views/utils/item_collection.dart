import 'dart:math';

import 'package:bottle_cap_gallery/src/business_logic/services/store_key_value_on_disk_manager/key_value_manager.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:flutter/foundation.dart';

class Collection extends ChangeNotifier {
  late Collection _collection;
  KeyValueManager keyValueManager = KeyValueManager();

  Collection get collection => _collection;
  //late Collection _collection;
  List<Item> itemList = [];

  void add(Item item) {
    itemList.add(item);
    keyValueManager.save(item.key.toString(), item);
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

  void readTest() async {
    print("111until here it works!!");
    Item dataItem = Item.fromJson(await keyValueManager
        .read(itemList[Random().nextInt(itemList.length)].key.toString()));
    print("until here it works!!");
    itemList.add(dataItem);
    notifyListeners();
  }
}
