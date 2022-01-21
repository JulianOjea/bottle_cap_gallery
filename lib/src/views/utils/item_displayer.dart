import 'package:bottle_cap_gallery/src/views/ui/item_view.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widget that wraps the item and displays it
class DisplayItem extends StatefulWidget {
  final Item item;
  final int index;

  DisplayItem(this.item, this.index);

  @override
  _DisplayItemState createState() => _DisplayItemState();
}

class _DisplayItemState extends State<DisplayItem> {
  late Item _item;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var collection = context.watch<Collection>();
    _item = collection.itemList[widget.index];

    return Stack(children: [
      Container(
        color: null,
        child: Image.memory(_item.image),
      ),
      Container(
        child: GestureDetector(
          onTap: () {
            _navigateAndItemView(context, _item);
          },
        ),
      ),
    ]);
  }

  void _navigateAndItemView(BuildContext context, Item item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewItem(item)),
    );
  }
}
