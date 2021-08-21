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
    print("Item " +
        item.brandName +
        " with id $resultId was inserted succesfully");
    item.id = resultId;
    itemList.add(item);
    notifyListeners();
  }

  void remove(Item item) {
    print("pasa1");
    itemList.remove(item);
    handler.deleteItem(item.id);
    print("pasa");
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
      /*  print("Item " +
          item.brandName +
          " with id $itemId was retrieved succesfully");
      print("type: " + item.type);
      print("description: " + item.description);
      print("country: " + item.country);
      print("city: " + item.city);
      print("releaseDate: " + item.releaseDate.toString());
      print("folder: " + item.folder);
      print("creationDate: " + item.creationDate.toString()); */
      //print(item.type);
      itemList.add(item);
    }

    notifyListeners();
  }
}
