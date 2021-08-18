import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditView extends StatefulWidget {
  final Item item;
  final OutlinedButton submitButton;

  AddEditView(this.item, this.submitButton);

  @override
  _AddEditViewState createState() => _AddEditViewState();
}

class _AddEditViewState extends State<AddEditView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add an image"),
      ),
      body: addEditView(context, widget.item, widget.submitButton),
    );
  }

  SingleChildScrollView addEditView(
      BuildContext context, Item item, OutlinedButton submitButton) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            _imageInput(Image.memory(item.image)),
            SizedBox(
              height: 20.0,
            ),
            _textInput(item.brandName),
            SizedBox(
              height: 20.0,
            ),
            _submitButton(context),
          ],
        ),
      ),
    );
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

  _setItemImage() {
    //int r = Random().nextInt(200);
    //widget.item.image =
    //  Image(image: NetworkImage("https://picsum.photos/id/$r/300/300"));
    setState(() {
      //_imageInput(widget.item.image);
    });
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
