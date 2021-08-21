import 'package:bottle_cap_gallery/src/views/ui/item_view.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DisplayItem extends StatefulWidget {
  final Item item;
  final int index;

  DisplayItem(this.item, this.index);

  @override
  _DisplayItemState createState() => _DisplayItemState();
}

class _DisplayItemState extends State<DisplayItem> {
  late Item _item;
  /*
  late Image _image;
  String _text = "";
  */
/*   late Color _containerColorOpacity;
  bool _enabledDeleteButton = false;
  bool _displayTextFlag = false;
  String _displayText = "";
  bool _containerOpacityFlag = false; */

  @override
  void initState() {
    super.initState();
    /* _containerColorOpacity = Colors.black.withOpacity(0); */
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
        /* color: _containerColorOpacity, */
        child: GestureDetector(
          onTap: () {
            _navigateAndItemView(context, _item);
          },
        ),
      ),
      /* Container(
        padding: EdgeInsets.all(10),
        child: Text(
          _displayText,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 30.0,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ), */
      /* _deleteIcon(), */
    ]);
  }

/*   _onTapDisplayItem() {
    if (_enabledDeleteButton == true) {
      setState(() {
        _enabledDeleteButton = false;
      });
    } else {
      if (_displayTextFlag == false) {
        changeContainerOpacity();
        _displayTextFlag = true;
        _displayText = _item.brandName;
      } else {
        changeContainerOpacity();
        _displayTextFlag = false;
        _displayText = "";
      }
    }
  } */

  /* changeContainerOpacity() {
    setState(() {
      if (_containerOpacityFlag == false) {
        _containerOpacityFlag = true;
        _containerColorOpacity = Colors.black.withOpacity(0.5);
      } else {
        _containerOpacityFlag = false;
        _containerColorOpacity = Colors.black.withOpacity(0.0);
      }
    });
  } */

  /* void _navigateAndEditItem(BuildContext context, Item item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditItem(item)),
    );
  } */

  void _navigateAndItemView(BuildContext context, Item item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewItem(item)),
    );
  }
}
