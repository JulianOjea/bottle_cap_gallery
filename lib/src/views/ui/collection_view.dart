import 'package:bottle_cap_gallery/src/business_logic/services/database_services/sqflite_collection.dart';
import 'package:bottle_cap_gallery/src/views/ui/add_item_view.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_displayer.dart';

import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ColectionView extends StatefulWidget {
  ColectionView({Key? key}) : super(key: key);

  @override
  _ColectionViewState createState() => _ColectionViewState();
}

class _ColectionViewState extends State<ColectionView> {
  final PageController controller = PageController(initialPage: 1);
  //int _index = 1;
  late SQFliteCollection handler;

  @override
  void initState() {
    super.initState();
    this.handler = SQFliteCollection();
    this.handler.initializeDB();
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
            AddItem(),
            _customScrollView(),
          ],
        ),
      ),
    );
  }

  _customScrollView() {
    return CustomScrollView(
      slivers: [
        _GridAppBar(),
        ItemSliver(),
      ],
    );
  }

  /* _test() {
    final ImagePicker _picker = ImagePicker();
    if (_index == 0) {
      FutureBuilder(
          future: _picker.pickImage(source: ImageSource.camera),
          builder: (context, snapshot) {
            return Container(
              color: Colors.green,
            );
          });
    }
    return Container(
      color: Colors.purple,
    );
  } */
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

class ItemSliver extends StatelessWidget {
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
          collection.readTest();
        },
        icon: Icon(Icons.zoom_out),
      ),
      actions: [
        IconButton(
            onPressed: () {
              _navigateAndReturnNewItem(context);
            },
            icon: Icon(Icons.sort)),
      ],
      title: Text('Collection'),
    );
  }

  /* void _sortByText(BuildContext context) {
    var collection = context.read<Collection>();
    collection.sortByText();
  } */

  void _navigateAndReturnNewItem(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItem()),
    );
  }
}
