import 'dart:io';
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
import 'package:camera/camera.dart';

import 'dart:async';
import 'package:path_provider/path_provider.dart';

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
                SizedBox(height: 10),
                _imageInput(),
                //_sizedBox(),
                Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                  child: Column(
                    children: [
                      _textInput("Nombre", "brandName", widget.item.brandName),
                      SizedBox(height: 10),
                      _typeAheadFormField(
                          DrinkService(), "Bebida", widget.item.type),
                      SizedBox(height: 10),
                      _textInput("Descripción", "description",
                          widget.item.description),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _typeAheadFormField(CountriesService(),
                                "País", widget.item.country),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                              child: _textInput(
                                  "Ciudad", "city", widget.item.city)),
                        ],
                      ),
                      SizedBox(height: 10),
                      _intInput("Año de emisión"),
                      SizedBox(height: 5),
                      _submitButton(context),
                    ],
                  ),
                )
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
          Container(
            width: 200.0,
            height: 200.0,
            decoration: new BoxDecoration(
              //color: Color.fromARGB(255, 197, 230, 166),
              color: Colors.amber,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(25.0)),
            ),
          ),
          Icon(
            Icons.add_a_photo,
            size: 50.0,
            //color: Color.fromARGB(255, 189, 139, 156),
            color: Colors.white,
          ),
          Container(
            width: 300.0,
            height: 300.0,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
              image: DecorationImage(
                image: _displayimage.image,
                fit: BoxFit.fill,
              ),
            ),
          ),
          GestureDetector(
            onTap: _setItemImage,
          ),
        ],
      ),
      decoration: BoxDecoration(
        //color: Color.fromARGB(255, 189, 139, 156),
        color: Colors.white,
      ),
    );
  }

  Widget _textInput(
      String labelText, String valueToChange, String initialValue) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        style: TextStyle(color: Colors.black),
        initialValue: initialValue,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.amber,
            ),
          ),
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
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
        keyboardType: TextInputType.number,
        style: TextStyle(color: Colors.black),
        initialValue: initialReleaseDate,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black, width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(
              color: Colors.amber,
            ),
          ),
          labelStyle: TextStyle(color: Colors.black),
          border: OutlineInputBorder(),
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
    widget.item.image = await _getCameraImage();

    setState(() {
      this._displayimage = Image.memory(widget.item.image);
    });
  }

  Future<Uint8List> _getCameraImage() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    try {
      File imageFile = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TakePictureScreen(
                    camera: firstCamera,
                    imagepath: "a",
                  )));

      return imageFile.readAsBytes();
    } catch (e) {
      return kTransparentImage;
    }
  }

  Future<Uint8List> _getNetworkImage() async {
    int r = Random().nextInt(200);
    http.Response response =
        await http.get(Uri.parse("https://picsum.photos/id/$r/300/300"));
    return response.bodyBytes;
  }

  Widget _submitButton(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.amber)),
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
              print(widget.item.country);
              widget.onButtonTapped(0, widget.editContext);
            }
          }
        },
        child: Icon(Icons.check, color: Colors.white));
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
          style: TextStyle(color: Colors.black),
          controller: typeAheadController,
          decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.black, width: 0.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: Colors.amber,
                ),
              ),
              labelStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(),
              labelText: labelText)),
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
          textColor: Color.fromARGB(255, 197, 230, 166),
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

class TakePictureScreen extends StatefulWidget {
  final imagepath;
  const TakePictureScreen(
      {Key? key, required this.camera, required this.imagepath})
      : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late final imagepath;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        // You must wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner until the
        // controller has finished initializing.
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 300,
            height: 300,
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // If the Future is complete, display the preview.
                  return CameraPreview(_controller);
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        FloatingActionButton(
          backgroundColor: Colors.amber,
          // Provide an onPressed callback.
          onPressed: () async {
            // Take the Picture in a try / catch block. If anything goes wrong,
            // catch the error.
            try {
              // Ensure that the camera is initialized.
              await _initializeControllerFuture;

              // Attempt to take a picture and get the file `image`
              // where it was saved.
              final image = await _controller.takePicture();
              this.imagepath = image.path;
              // If the picture was taken, display it on a new screen.
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(
                    // Pass the automatically generated path to
                    // the DisplayPictureScreen widget.
                    imagePath: image.path,
                  ),
                ),
              );
            } catch (e) {
              // If an error occurs, log the error to the console.
              print(e);
            }
          },
          child: const Icon(Icons.camera_alt),
        ),
      ]),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: 300.0,
        height: 300.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          image: DecorationImage(
              image: Image.file(
                File(imagePath),
              ).image,
              fit: BoxFit.fill),
        ),
      ),
      ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.amber)),
        onPressed: () {
          // Close the screen and return "Yep!" as the result.
          Navigator.pop(context);
          Navigator.pop(context, File(imagePath));
        },
        child: Icon(Icons.check),
      )
    ]));
  }
}
