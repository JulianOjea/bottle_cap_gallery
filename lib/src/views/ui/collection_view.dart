import 'package:bottle_cap_gallery/src/business_logic/services/database_services/sqflite_collection.dart';
import 'package:bottle_cap_gallery/src/views/ui/add_item_view.dart';
import 'package:bottle_cap_gallery/src/views/ui/pages_view.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_displayer.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ColectionView extends StatefulWidget {
  ColectionView({Key? key}) : super(key: key);

  @override
  _ColectionViewState createState() => _ColectionViewState();
}

class _ColectionViewState extends State<ColectionView> {
  late SQFliteCollection handler;

  @override
  void initState() {
    super.initState();
    this.handler = SQFliteCollection();
    this.handler.initializeDB();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _appBar(),
        Pages(),
      ],
      /* floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateAndReturnNewItem(context);
        },
      ), */
    );
  }

  _appBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          var collection = context.read<Collection>();
          collection.readTest();
        },
        icon: Icon(Icons.zoom_out),
      ),
      actions: [
        IconButton(
            onPressed: () {
              _sortByText(context);
            },
            icon: Icon(Icons.sort)),
      ],
      title: Text('Collection'),
    );
  }

  void _navigateAndReturnNewItem(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItem()),
    );
  }

  void _sortByText(BuildContext context) {
    var collection = context.read<Collection>();
    collection.sortByText();
  }
}

class ItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var collection = context.watch<Collection>();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: collection.itemList.length,
      itemBuilder: (BuildContext context, int index) {
        return DisplayItem(collection.itemList[index], index);
      },
    );
  }
}
