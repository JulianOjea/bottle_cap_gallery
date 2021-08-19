import 'dart:typed_data';

import 'package:bottle_cap_gallery/src/business_logic/assets/countries_list.dart';
import 'package:bottle_cap_gallery/src/business_logic/assets/drink_list.dart';
import 'package:bottle_cap_gallery/src/business_logic/assets/list_iface.dart';
import 'package:bottle_cap_gallery/src/views/utils/item.dart';
import 'package:bottle_cap_gallery/src/views/utils/item_collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:math';
import 'package:transparent_image/transparent_image.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class AddItem extends StatefulWidget {
  final void Function(int) onButtonTapped;
  AddItem(this.onButtonTapped);
  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  Item _item = Item(
      brandName: '',
      city: '',
      country: '',
      creationDate: DateTime.now(),
      description: '',
      folder: '',
      id: -1,
      image: Uint8List(0),
      releaseDate: -1,
      type: '');

  Image _displayimage = Image.memory(kTransparentImage);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadAsset();
  }

  void loadAsset() async {
    ByteData data = await rootBundle.load('assets/ee.png');
    _item.image = data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                _imageInput(),
                //_sizedBox(),
                _textInput("Nombre", "brandName"),
                //_sizedBox(),
                _typeAheadFormField(DrinkService(), "Bebida"),
                //_sizedBox(),
                _textInput("Descripción", "description"),
                //_sizedBox(),
                Row(
                  children: [
                    Expanded(
                      child: _typeAheadFormField(CountriesService(), "País"),
                    ),
                    Expanded(child: _textInput("Ciudad", "city")),
                  ],
                ),
                //_sizedBox(),
                _intInput("Año de emisión"),
                SizedBox(
                  height: 10.0,
                ),
                _submitButton(context),
              ],
            ),
          ),
          SizedBox(
            height: 500,
          ),
        ],
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

  Widget _textInput(String labelText, String valueToChange) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        onChanged: (value) {
          if (valueToChange == "brandName") {
            _item.brandName = value;
          } else if (valueToChange == "description") {
            _item.description = value;
          } else if (valueToChange == "city") {
            _item.city = value;
          }
        },
      ),
    );
  }

  Widget _intInput(String labelText) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        onChanged: (value) {
          _item.releaseDate = int.parse(value);
        },
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: (value) {
          if (value != "") {
            int comparator = int.parse(value!);
            if (comparator < 1892 || comparator > DateTime.now().year) {
              return "Escribe un año valido";
            }
          }
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
    return ElevatedButton(
        onPressed: () {
          if (this._formKey.currentState!.validate()) {
            var collection = context.read<Collection>();
            _item.creationDate = DateTime.now();
            print("esta es la ciudad" + _item.city);
            collection.add(_item);
            widget.onButtonTapped(1);
          }
        },
        child: Icon(Icons.ac_unit));
  }

  _typeAheadFormField(PredictiveListDataManager list, String labelText) {
    final TextEditingController typeAheadController = TextEditingController();

    return TypeAheadFormField(
      keepSuggestionsOnLoading: false,
      hideOnLoading: true,
      hideOnError: true,
      textFieldConfiguration: TextFieldConfiguration(
          controller: typeAheadController,
          decoration: InputDecoration(labelText: labelText)),
      suggestionsCallback: (pattern) {
        return list.getSuggestions(pattern);
      },
      itemBuilder: (context, String suggestion) {
        if (labelText == "Bebida") {
          _item.type = suggestion;
        } else if (labelText == "País") {
          _item.country = suggestion;
        }
        return ListTile(
          title: Text(suggestion),
        );
      },
      transitionBuilder: (context, suggestionsBox, controller) {
        return suggestionsBox;
      },
      onSuggestionSelected: (String suggestion) {
        typeAheadController.text = suggestion;
      },
      validator: (value) {
        return list.validate(value);
      },
    );
  }
}
