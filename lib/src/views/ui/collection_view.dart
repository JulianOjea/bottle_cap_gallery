import 'package:bottle_cap_gallery/src/views/ui/add_item_view.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection'),
      ),
      body: ItemList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateAndReturnNewItem(context);
        },
      ),
    );
  }

  void _navigateAndReturnNewItem(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItem()),
    );
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
