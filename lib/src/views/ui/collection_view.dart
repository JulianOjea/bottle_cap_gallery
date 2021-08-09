import 'package:bottle_cap_gallery/src/views/ui/add_item_view.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_displayer.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';

import 'package:flutter/material.dart';

class ColectionView extends StatefulWidget {
  ColectionView({Key? key}) : super(key: key);

  @override
  _ColectionViewState createState() => _ColectionViewState();
}

class _ColectionViewState extends State<ColectionView> {
  List<DisplayItem> _itemList = [];
  int _itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection'),
      ),
      body: GridView.builder(
        itemCount: _itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return _itemList[index];
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _navigateAndReturnNewItem(context);
        },
      ),
    );
  }

  /*
  void _fillItemList(Item item) {
    setState(() {
      _itemCount++;
      _itemList.add(DisplayItem(item));
    });
  }*/

  void _navigateAndReturnNewItem(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItem()),
    );
    /*
    print(result.text);
    if (result.text != "") {
      _fillItemList(result);
    }*/
  }
}
