import 'package:bottle_cap_gallery/src/business_logic/services/database_services/sqflite_collection.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:flutter/foundation.dart';

//Manages SQFliteCollection
//Adds the next operations:
//add
//remove
//edit
//sortBy

class Collection extends ChangeNotifier {
  late Collection _collection;

  SQFliteCollection handler = SQFliteCollection();

  Collection get collection => _collection;
  //late Collection _collection;
  List<Item> itemList = [];

  void add(Item item) async {
    int resultId = await handler.insertItem(item);
    print("Item " +
        item.brandName +
        " with id $resultId was inserted succesfully");
    item.id = resultId;
    itemList.add(item);
    notifyListeners();
  }

  void remove(Item item) {
    itemList.remove(item);
    handler.deleteItem(item.id);
    int itemId = item.id;
    print(
        "Item " + item.brandName + " with id $itemId was removed succesfully");
    notifyListeners();
  }

  void edit(Item item) {
    int i = itemList.indexOf(item);
    handler.updateItem(item);
    itemList[i] = item;
    int itemId = item.id;
    print("Item " + item.brandName + " with id $itemId was edited succesfully");
    notifyListeners();
  }

  void sortByText() {
    itemList.sort((a, b) => a.brandName.compareTo(b.brandName));
    notifyListeners();
  }

  void readTest() async {
    /*
    int numberOfItems = await handler.getNumberOfItems();
    print("number of items in datbase" + numberOfItems.toString());
*/
    List<Item> retrievedList = await handler.retrieveItems();
    int itemId;

    for (var item in retrievedList) {
      itemId = item.id;
      itemList.add(item);
    }

    notifyListeners();
  }

  void countItems() async {
    int numberOfItems = await handler.getNumberOfItems();
    print("number of items in datbase" + numberOfItems.toString());
    int itemId;
    List<Item> retrievedList = await handler.retrieveItems();

    for (var item in retrievedList) {
      itemId = item.id;
      print(itemId.toString());
    }
  }

  void removeTest(int i) {
    handler.deleteItem(i);

    print("deleted");
    notifyListeners();
  }
}
