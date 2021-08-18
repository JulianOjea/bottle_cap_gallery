import 'dart:typed_data';

import 'package:bottle_cap_gallery/src/business_logic/assets/countries_list.dart';
import 'package:bottle_cap_gallery/src/business_logic/assets/drink_list.dart';
import 'package:bottle_cap_gallery/src/business_logic/assets/list_iface.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:math';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AddItem extends StatefulWidget {
  AddItem({Key? key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  Item _item = Item(text: "", image: Uint8List(0), id: -1);
  Image _displayimage = Image.memory(kTransparentImage);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              _imageInput(),
              //_sizedBox(),
              _textInput("Nombre"),
              //_sizedBox(),
              PredictiveTextInput(DrinkService(), "Bebidas"),
              //_sizedBox(),
              _textInput("Descripción"),
              //_sizedBox(),
              Row(
                children: [
                  Expanded(
                      child: PredictiveTextInput(CountriesService(), "País")),
                  Expanded(child: _textInput("Ciudad")),
                ],
              ),
              //_sizedBox(),
              _textInput("Fecha de emisión (año)"),
              //_sizedBox(),
              _submitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageInput() {
    return Container(
      height: 300,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Icon(
            Icons.add_a_photo,
            size: 50.0,
            color: Colors.lightBlue,
          ),
          _displayimage,
          GestureDetector(
            onTap: _setItemImage,
          ),
        ],
      ),
      decoration: BoxDecoration(
        color: Colors.black,
      ),
    );
  }

  Widget _textInput(String labelText) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        onChanged: (value) {
          _item.text = value;
        },
      ),
    );
  }

  _setItemImage() async {
    this._item.image = await _getNetworkImage();

    setState(() {
      this._displayimage = Image.memory(_item.image);
    });
  }

  Future<Uint8List> _getNetworkImage() async {
    int r = Random().nextInt(200);
    http.Response response =
        await http.get(Uri.parse("https://picsum.photos/id/$r/300/300"));
    return response.bodyBytes;
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

  /*  Widget _getCountry(BuildContext context) {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        print('Select country: ${country.displayName}');
      },
    );
  } */
/* 
  SizedBox _sizedBox() {
    return SizedBox(height: 10.0);
  } */
}

class PredictiveTextInput extends StatelessWidget {
  final PredictiveListDataManager _list;
  final String _labelText;
  final TextEditingController _typeAheadController = TextEditingController();

  PredictiveTextInput(this._list, this._labelText);

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      keepSuggestionsOnLoading: false,
      hideOnLoading: true,
      hideOnError: true,
      textFieldConfiguration: TextFieldConfiguration(
          controller: this._typeAheadController,
          decoration: InputDecoration(labelText: _labelText)),
      suggestionsCallback: (pattern) {
        return _list.getSuggestions(pattern);
      },
      itemBuilder: (context, String suggestion) {
        return ListTile(
          title: Text(suggestion),
        );
      },
      onSuggestionSelected: (String suggestion) {
        this._typeAheadController.text = suggestion;
      },
    );
  }
}
