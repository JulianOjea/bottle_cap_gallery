import 'dart:typed_data';

import 'package:bottle_cap_gallery/src/business_logic/services/database_services/sqflite_collection.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_displayer.dart';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

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

  @override
  void initState() {
    super.initState();
    this.handler = SQFliteCollection();
    this.handler.initializeDB();
    var collection = context.read<Collection>();
    collection.readTest();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Material(
        child: PageView(
          scrollDirection: Axis.horizontal,
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              //_index = index;
            });
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
                    image: Uint8List(0),
                    releaseDate: -1,
                    type: ''),
                "a",
                context),
            gridHeader(),
            //_customScrollView(),
          ],
        ),
      ),
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
    List<String> differentValues = [];
    displayItemList.sort((a, b) => a.item.country.compareTo(b.item.country));
    for (var i = 0; i < collection.itemList.length; i++) {
      differentValues.add(displayItemList[i].item.country);
    }
    differentValues = differentValues.toSet().toList();

    //generate a map grouping by country
    var groupedList =
        displayItemList.groupListsBy((element) => element.item.country);

    return new ListView.builder(
      itemCount: collection.itemList.length,
      itemBuilder: (context, index) {
        return new StickyHeader(
          header: new Container(
            height: 38.0,
            color: Colors.white,
            padding: new EdgeInsets.symmetric(horizontal: 12.0),
            alignment: Alignment.centerLeft,
            child: new Text(
              differentValues[index],
              style: const TextStyle(
                  color: Colors.purple,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          content: Container(
            child: GridView.builder(
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
                  color: Colors.purpleAccent,
                  child: groupedList[differentValues[index]]?[indx],
                );
              },
            ),
          ),
        );
      },
      shrinkWrap: true,
    );
  }

  _customScrollView() {
    return CustomScrollView(
      slivers: [
        _GridAppBar(),
        _ItemSliver(),
      ],
    );
  }

  void onButtonTapped(int index, BuildContext context) {
    controller.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
    );
  }
}

class _ItemSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 2,
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
