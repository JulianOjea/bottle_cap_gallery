import 'dart:math';
import 'dart:typed_data';

import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class EditItem extends StatefulWidget {
  final Item item;
  EditItem(this.item);

  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Edit image"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                _imageInput(Image.memory(widget.item.image)),
                SizedBox(
                  height: 20.0,
                ),
                _textInput(widget.item.brandName),
                SizedBox(
                  height: 20.0,
                ),
                _submitButton(context),
              ],
            ),
          ),
        ));
  }

  Widget _imageInput(Image image) {
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
          image,
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

  _setItemImage() async {
    widget.item.image = await _getNetworkImage();
    setState(() {
      _imageInput(Image.memory(widget.item.image));
    });
  }

  Future<Uint8List> _getNetworkImage() async {
    int r = Random().nextInt(200);
    http.Response response =
        await http.get(Uri.parse("https://picsum.photos/id/$r/300/300"));
    return response.bodyBytes;
  }

  Widget _textInput(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        initialValue: text,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
        onChanged: (value) {
          widget.item.brandName = value;
        },
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          var collection = context.read<Collection>();
          collection.edit(widget.item);
          Navigator.pop(context, []);
        },
        child: Icon(Icons.ac_unit));
  }
}
