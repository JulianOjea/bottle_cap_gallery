import 'package:bottle_cap_gallery/src/business_logic/services/database_services/sqflite_collection.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:flutter/foundation.dart';

class Collection extends ChangeNotifier {
  late Collection _collection;

  SQFliteCollection handler = SQFliteCollection();

  Collection get collection => _collection;
  //late Collection _collection;
  List<Item> itemList = [];

  void add(Item item) async {
    int resultId = await handler.insertItem(item);
    print("Item " + item.text + " with id $resultId was inserted succesfully");
    item.id = resultId;
    itemList.add(item);
    notifyListeners();
  }

  void remove(Item item) {
    itemList.remove(item);
    handler.deleteItem(item.id);
    int itemId = item.id;
    print("Item " + item.text + " with id $itemId was removed succesfully");
    notifyListeners();
  }

  void edit(Item item) {
    int i = itemList.indexOf(item);
    handler.updateItem(item);
    itemList[i] = item;
    int itemId = item.id;
    print("Item " + item.text + " with id $itemId was edited succesfully");
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
      print("Item " + item.text + " with id $itemId was retrieved succesfully");
      itemList.add(item);
    }

    notifyListeners();
  }
}
