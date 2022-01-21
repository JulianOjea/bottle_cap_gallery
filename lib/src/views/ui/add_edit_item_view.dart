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

//Since add and edit are similar operations they are sumarized on this class

//Adds a new item to the collection
//Item: item to be added
//flag: used to chose between an add or an edit operation.
//edit context: context on the application
class AddEditItem extends StatefulWidget {
  final void Function(int, BuildContext) onButtonTapped;
  final Item item;
  final String flag;
  final BuildContext editContext;
  AddEditItem(this.onButtonTapped, this.item, this.flag, this.editContext);
  @override
  _AddEditItemState createState() => _AddEditItemState();
}

//_displayimage: image set up when there is no image to show
//_formKey: key of the displayed form
//initialReleaseDate: used to generate the release date on the item

//Using a ListView to request display atribute fields.
//List of fields:
//1.Image: _imageInput, it displays the image of the item, for testing purposes it
//    shows an default image onTap
//2.BrandName: _textInput, requesting brandName with Form.
//3.Drink: _typeAheadFormField, a list of drinks is displayed on this Form
//    so the user can select one of them. DrinkService class keeps hard coded list of drinks.
//4.Description: _textInput, requesting brandName with Form.
//5.Country: _typeAheadFormField, as done on drinks. CountriesService() keeps the hard coded
//    list of countries.
//6.City: _textInput, requesting city with Form
//7.ReleaseDate: _intInput, requesting release date with Form

class _AddEditItemState extends State<AddEditItem> {
  Image _displayimage = Image.memory(kTransparentImage);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //int imageLoaded = 0;
  String initialReleaseDate = "";

  @override
  void initState() {
    super.initState();
    if (widget.flag == "e") {
      if (widget.item.releaseDate != -1) {
        initialReleaseDate = widget.item.releaseDate.toString();
      }
      _displayimage = Image.memory(widget.item.image);
    }
    if (widget.flag == "a") {
      loadAsset();
    }
  }

  //being tested
  void loadAsset() async {
    ByteData data = await rootBundle.load('assets/ee.png');
    widget.item.image = data.buffer.asUint8List();
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
                _textInput("Nombre", "brandName", widget.item.brandName),
                //_sizedBox(),
                _typeAheadFormField(DrinkService(), "Bebida", widget.item.type),
                //_sizedBox(),
                _textInput(
                    "Descripción", "description", widget.item.description),
                //_sizedBox(),
                Row(
                  children: [
                    Expanded(
                      child: _typeAheadFormField(
                          CountriesService(), "País", widget.item.country),
                    ),
                    Expanded(
                        child: _textInput("Ciudad", "city", widget.item.city)),
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

  Widget _textInput(
      String labelText, String valueToChange, String initialValue) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        initialValue: initialValue,
        decoration: InputDecoration(
          labelText: labelText,
        ),
        onChanged: (value) {
          if (valueToChange == "brandName") {
            widget.item.brandName = value;
          } else if (valueToChange == "description") {
            widget.item.description = value;
          } else if (valueToChange == "city") {
            widget.item.city = value;
          }
        },
      ),
    );
  }

  Widget _intInput(String labelText) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        initialValue: initialReleaseDate,
        decoration: InputDecoration(
          labelText: labelText,
        ),
        onChanged: (value) {
          widget.item.releaseDate = int.parse(value);
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
    //this.imageLoaded = 1;
    widget.item.image = await _getNetworkImage();

    setState(() {
      this._displayimage = Image.memory(widget.item.image);
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
            if (widget.flag == "a") {
              var collection = context.read<Collection>();
              widget.item.creationDate = DateTime.now();
              print("esta es la ciudad" + widget.item.city);
              collection.add(widget.item);
              widget.onButtonTapped(1, context);
            }
            if (widget.flag == "e") {
              var collection = context.read<Collection>();
              collection.edit(widget.item);
              print("edito el item");
              widget.onButtonTapped(0, widget.editContext);
            }
          }
        },
        child: Icon(Icons.ac_unit));
  }

  _typeAheadFormField(
      PredictiveListDataManager list, String labelText, String initialValue) {
    final TextEditingController typeAheadController =
        TextEditingController(text: initialValue);

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
          widget.item.type = suggestion;
        } else if (labelText == "País") {
          widget.item.country = suggestion;
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
