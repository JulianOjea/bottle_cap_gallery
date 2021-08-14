import 'dart:math';

import 'package:bottle_cap_gallery/src/business_logic/services/database_services/sqflite_collection.dart';
import 'package:bottle_cap_gallery/src/business_logic/services/store_key_value_on_disk_manager/key_value_manager.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:flutter/foundation.dart';

class Collection extends ChangeNotifier {
  late Collection _collection;
  KeyValueManager keyValueManager = KeyValueManager();

  SQFliteCollection handler = SQFliteCollection();

  Collection get collection => _collection;
  //late Collection _collection;
  List<Item> itemList = [];

  void add(Item item) async {
    itemList.add(item);
    int resultId = await handler.insertItem(item);
    print("Item" + item.text + " with id $resultId was inserted succesfully");
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
    List<Item> retrievedList = await handler.retrieveItems();
    int itemId;

    for (var item in retrievedList) {
      itemId = item.id;
      print("Item" + item.text + " with id $itemId was retrieved succesfully");
      itemList.add(item);
    }

    notifyListeners();
  }
}
