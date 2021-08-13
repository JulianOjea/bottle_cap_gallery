import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';

class AddItem extends StatefulWidget {
  AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  Item _item = Item("", Image(image: NetworkImage("")));
  Image _displayimage = Image.memory(kTransparentImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add an image"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20.0,
              ),
              _imageInput(),
              SizedBox(
                height: 20.0,
              ),
              _textInput(),
              SizedBox(
                height: 20.0,
              ),
              _submitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageInput() {
    return Container(
      height: 200,
      width: 200,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Icon(
            Icons.add_a_photo,
            size: 50.0,
            color: Colors.blue,
          ),
          _displayimage,
          GestureDetector(
            onTap: _setItemImage,
          ),
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _textInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          hintText: 'Type something',
        ),
        onChanged: (value) {
          _item.text = value;
        },
      ),
    );
  }

  _setItemImage() {
    int r = Random().nextInt(200);
    this._item.image =
        Image(image: NetworkImage("https://picsum.photos/id/$r/300/300"));
    setState(() {
      this._displayimage = this._item.image;
    });
  }

  Widget _submitButton(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          var collection = context.read<Collection>();
          collection.add(_item);
          Navigator.pop(context, []);
        },
        child: Icon(Icons.ac_unit));
  }
}
