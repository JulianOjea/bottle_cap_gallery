import 'dart:typed_data';

import 'package:bottle_cap_gallery/src/app.dart';
import 'package:bottle_cap_gallery/src/business_logic/services/database_services/sqflite_collection.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_displayer.dart';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:transparent_image/transparent_image.dart';

import 'add_edit_item_view.dart';

//This file contains the main view of the collection, it uses PageView
//to navigate between the main collection view and the add item View.

//Main page:
//It is built with a CustomScrollView, it only supports a basic grid to show all the items
//using _ItemSliver and _GridAppBar to form the display. Each class work with SliverGrid and
//SliverAddBar.
// ¡¡ This structure is still being implemented !!

//Each item is saved an retrieved using SQFliteCollection package.

//Add Item View:
//Uses AddEditItem class to get the information of the new item and saving it into the gallery.

class CollectionView extends StatefulWidget {
  CollectionView({Key? key}) : super(key: key);

  @override
  _CollectionViewState createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  final PageController controller = PageController(initialPage: 1);
  late SQFliteCollection handler;
  String dropdownValue = "Por defecto";

  Uint8List? noImage;

  @override
  void initState() {
    super.initState();
    this.handler = SQFliteCollection();
    this.handler.initializeDB();
    var collection = context.read<Collection>();
    collection.readTest();

    loadAsset();
  }

  loadAsset() async {
    noImage =
        (await rootBundle.load('assets/no_image.jpg')).buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                handler.dropTable();
              },
              child: Icon(Icons.abc_outlined))
        ],
      ),*/
      body: Material(
        child: PageView(
          scrollDirection: Axis.horizontal,
          controller: controller,
          onPageChanged: (index) {
            setState(() {});
          },
          children: <Widget>[
            AddEditItem(
                onButtonTapped,
                Item(
                    brandName: '',
                    city: '',
                    country: '',
                    creationDate: DateTime.now(),
                    description: '',
                    folder: '',
                    id: -1,
                    image: noImage ?? kTransparentImage,
                    releaseDate: -1,
                    type: ''),
                "a",
                context),
            _selectMainView(),
          ],
        ),
      ),
    );
  }

  Widget _selectMainView() {
    if (this.dropdownValue == "Por defecto") {
      return CustomScrollView(
        slivers: [_mainViewAppBar(), _ItemSliver()],
      );
    } else {
      return NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[_mainViewAppBar()];
        },
        body: gridHeader(),
      );
    }
  }

  _mainViewAppBar() {
    return SliverAppBar(
      //backgroundColor: Color.fromARGB(255, 189, 139, 156),
      backgroundColor: Colors.white,
      title: Text("Bottle Cap Gallery!!",
          style: TextStyle(
              color: //Color.fromARGB(255, 197, 230, 166)
                  Colors.amber)),
      actions: [
        _onSelectedSortOrder(),
      ],
    );
  }

  Widget gridHeader() {
    //obtain item from list
    var collection = context.watch<Collection>();

    //generate display list to work with
    List<DisplayItem> displayItemList = [];
    for (var i = 0; i < collection.itemList.length; i++) {
      displayItemList.add(DisplayItem(collection.itemList[i], i));
    }

    //Obtain different countries in the list
    displayItemList = _sortByAtrib(displayItemList);

    List<String> differentValues = [];
    differentValues = _getItemList(displayItemList, collection);

    //generate a map grouping by country
    var groupedList = _generateMap(displayItemList);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: new ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: differentValues.length,
        itemBuilder: (context, index) {
          return new StickyHeader(
            header: new Container(
              height: 38.0,
              //color: Color.fromARGB(255, 189, 139, 156),
              padding: new EdgeInsets.symmetric(horizontal: 12.0),
              alignment: Alignment.centerLeft,
              child: new Text(
                differentValues[index],
                style: const TextStyle(
                    //color: Color.fromARGB(255, 197, 230, 166),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            content: Container(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: groupedList[differentValues[index]]?.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                ),
                itemBuilder: (contxt, indx) {
                  return Card(
                    margin: EdgeInsets.all(4.0),
                    //color: Color.fromARGB(255, 197, 230, 166),
                    child: groupedList[differentValues[index]]?[indx],
                  );
                },
              ),
            ),
          );
        },
        shrinkWrap: true,
      ),
    );
  }

  void onButtonTapped(int index, BuildContext context) {
    controller.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }

  _onSelectedSortOrder() {
    return DropdownButtonHideUnderline(
        child: DropdownButton2(
      items: MenuItems.items
          .map(
            (item) => DropdownMenuItem<MenuItem>(
              value: item,
              child: MenuItems.buildItem(item),
            ),
          )
          .toList(),
      onChanged: (newValue) {
        setState(() {
          newValue as MenuItem;
          dropdownValue = newValue.text;
        });
      },
      itemHeight: 48,
      itemPadding: const EdgeInsets.only(left: 16, right: 16),
      dropdownWidth: 64,
      dropdownPadding: const EdgeInsets.symmetric(vertical: 6),
      dropdownDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          //color: Color.fromARGB(255, 197, 230, 166),
          color: Colors.white),
      dropdownElevation: 8,
      //offset: const Offset(0, 8),
      customButton: Padding(
        padding: const EdgeInsets.only(right: 5),
        child: const Icon(
          Icons.sort_rounded,
          size: 46,
          //color: Color.fromARGB(255, 197, 230, 166),
          color: Colors.amber,
        ),
      ),
      customItemsIndexes: const [3],
      customItemsHeight: 8,
    ));
  }
  /*_onSelectedSortOrder() {
    return DropdownButton<String>(
      underline: null,
      value: dropdownValue,
      dropdownColor: Colors.blue,
      icon: const Icon(Icons.arrow_downward),
      //elevation: 16,
      style: const TextStyle(color: Colors.white, fontSize: 18),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: <String>['Por defecto', 'Países', 'Bebidas']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }*/

  List<String> _getItemList(List<DisplayItem> displayItemList, var collection) {
    List<String> differentValues = [];
    if (this.dropdownValue == "Bebidas") {
      for (var i = 0; i < collection.itemList.length; i++) {
        differentValues.add(displayItemList[i].item.type);
      }
      return differentValues.toSet().toList();
    } else {
      for (var i = 0; i < collection.itemList.length; i++) {
        differentValues.add(displayItemList[i].item.country);
      }
      return differentValues.toSet().toList();
    }
  }

  List<DisplayItem> _sortByAtrib(List<DisplayItem> displayItemList) {
    if (this.dropdownValue == "Bebidas") {
      displayItemList.sort((a, b) => a.item.type.compareTo(b.item.type));
      return displayItemList;
    } else {
      displayItemList.sort((a, b) => a.item.country.compareTo(b.item.country));
      return displayItemList;
    }
  }

  Map<String, List<DisplayItem>> _generateMap(
      List<DisplayItem> displayItemList) {
    if (this.dropdownValue == "Bebidas") {
      return displayItemList.groupListsBy((element) => element.item.type);
    } else {
      return displayItemList.groupListsBy((element) => element.item.country);
    }
  }
}

class _ItemSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 2,
      crossAxisSpacing: 8,
      mainAxisSpacing: 8,
      children: _auxTest(context),
    );
  }

  List<DisplayItem> _auxTest(BuildContext context) {
    var collection = context.watch<Collection>();

    List<DisplayItem> ret = [];
    for (var i = 0; i < collection.itemList.length; i++) {
      ret.add(DisplayItem(collection.itemList[i], i));
    }
    return ret;
  }
}

class _GridAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: () {
          var collection = context.read<Collection>();
          collection.removeTest(35);
        },
        icon: Icon(Icons.zoom_out),
      ),
      title: Text('Collection'),
    );
  }
}

class MenuItem {
  final String text;
  final IconData icon;

  const MenuItem({
    required this.text,
    required this.icon,
  });
}

class MenuItems {
  static const List<MenuItem> items = [default_menu_item, country, drink];

  static const default_menu_item =
      MenuItem(text: 'Por defecto', icon: Icons.sort_by_alpha);
  static const country = MenuItem(text: 'Países', icon: Icons.flag);
  static const drink = MenuItem(text: 'Bebidas', icon: Icons.local_drink);

  static Widget buildItem(MenuItem item) {
    return Row(
      children: [
        Icon(item.icon,
            color: /*Color.fromARGB(255, 189, 139, 156)*/ Colors.amber,
            size: 22),
        const SizedBox(
          width: 10,
        ),
        /*
        Text(
          item.text,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        */
      ],
    );
  }

  static onChanged(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItems.default_menu_item:
        //Do something
        break;
      case MenuItems.country:
        //Do something
        break;
      case MenuItems.drink:
        //Do something
        break;
    }
  }
}
