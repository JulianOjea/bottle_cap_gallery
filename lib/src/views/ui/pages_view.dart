import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_displayer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Pages extends StatelessWidget {
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: controller,
      children: <Widget>[
        Center(
          child: Text(
            'First Page',
            style: TextStyle(color: Colors.amber),
          ),
        ),
        Center(
          child: Column(
            children: [AppBar(), Expanded(child: ItemList())],
          ),
        ),
      ],
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